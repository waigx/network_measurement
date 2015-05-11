package objs
{
	public class NMData extends Object
	{
		[Bindable] public var url:String;
		[Bindable] public var state:String = "unknown";
		[Bindable] public var delay:String = "Pending";
		[Bindable] public var pagesize:int;
		public function NMData()
		{
			super();
		}
	}
}