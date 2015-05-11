package org.igorw
{
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.events.DNSResolverEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.net.dns.AAAARecord;
	import flash.net.dns.ARecord;
	import flash.net.dns.DNSResolver;
	import flash.net.dns.MXRecord;
	import flash.net.dns.PTRRecord;
	import flash.net.dns.SRVRecord;
	import flash.utils.getQualifiedClassName;
	
	public class ResolveDNS extends Sprite
	{
		private var resolver:DNSResolver;
		private var url:String;
		public var result:String = new String();
		
		private function parseURLToRoot(url:String):String
		{
			var rootURL:String;
			if (url.indexOf("https://") == 0){
				url = url.substring(String("https://").length);
			} else if (url.indexOf("http://") == 0){
				url = url.substring(String("http://").length);
			}
			
			rootURL = url.substring(0, (url.indexOf("/") == -1) ? url.length : url.indexOf("/"));
			trace(rootURL);
			
			return rootURL;		
		}
		
		public function ResolveDNS(url:String)
		{
			resolver = new DNSResolver();
			
			this.url = parseURLToRoot(url);
		}
		
		public function resolve():void
		{
			resolver.lookup( this.url, ARecord );
			resolver.addEventListener(DNSResolverEvent.LOOKUP, lookupComplete);
			resolver.addEventListener(ErrorEvent.ERROR, lookupError);
			//resolver.lookup( url, AAAARecord );
			//resolver.lookup( url, MXRecord );
			//resolver.lookup( url, PTRRecord );
			//resolver.lookup( url, SRVRecord );
		}
		
		private function lookupComplete( event:DNSResolverEvent ):void
		{
			trace( "Query string: " + event.host );
			trace( "Record type: " +  flash.utils.getQualifiedClassName( event.resourceRecords[0] ) + 
				", count: " + event.resourceRecords.length );
			for each( var record in event.resourceRecords )
			{
				if( record is ARecord ) result += record.name + " : " + record.address + "\n";
				if( record is AAAARecord ) result += record.name + " : " + record.address + "\n";
				if( record is MXRecord ) result += record.name + " : " + record.exchange + ", " + record.preference + "\n";
				if( record is PTRRecord ) result += record.name + " : " + record.ptrdName + "\n";
				if( record is SRVRecord ) result += record.name + " : " + record.target + ", " + record.port +
					", " + record.priority + ", " + record.weight + "\n";
			}
			this.dispatchEvent(new Event("DNS_RESOLVE_COMPLETE", true));
		}
		
		private function lookupError( error:ErrorEvent ):void
		{
			result += "Error: " + error.text + "\n";
		}
	}
}