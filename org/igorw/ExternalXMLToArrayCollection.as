package org.igorw
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.collections.ArrayCollection;
	import mx.collections.XMLListCollection;
	import mx.controls.Alert;
	import mx.rpc.xml.SimpleXMLDecoder;
	
	public class ExternalXMLToArrayCollection
	{
		private var path:String;
		private var XMLFile:File;
		private var parsedXML:XML;
		private var fileStream:FileStream;
		private var parsedArrayCollection:ArrayCollection;
		
		public function ExternalXMLToArrayCollection(path:String,itemName:String)
		{
			this.path = path;
			try{
				XMLFile = new File(File.applicationDirectory.resolvePath(path).nativePath);
				fileStream = new FileStream();
				fileStream.open(XMLFile, FileMode.READ);
				
				parsedXML = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
				fileStream.close();
			}catch(error:Error){
				Alert.show(error.message,"错误");
			}
			
			parsedArrayCollection = XMLToArrayCollection(parsedXML,itemName);
		}
		
		public function get arrayCollection():ArrayCollection{
			return parsedArrayCollection;
		}
		
		public static function XMLToArrayCollection( XMLInstance:XML,itemName:String ):ArrayCollection{
			var decoder:SimpleXMLDecoder = new SimpleXMLDecoder(true);
			var xmlList:XMLList = new XMLList();
			xmlList = XMLInstance.elements(itemName);
			var xmlListCollection:XMLListCollection = new XMLListCollection(xmlList);
			return new ArrayCollection(xmlListCollection.toArray());
		}
	}
}