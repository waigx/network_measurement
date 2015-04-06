package org.igorw.events
{
	import flash.events.Event;
	
	public class DetailsClicked extends Event
	{
		public static const DETAILS_CLICKED:String = "ITEM_DETAILS_CLICKED";
		public var url:String;
		public function DetailsClicked(url:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(DETAILS_CLICKED, bubbles, cancelable);
			this.url = url;
		}
	}
}