package imree.modules 
{
	import imree.pages.exhibit;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class module_asset extends module 
	{
		public var feature_item:module;
		public function module_asset( _main:Main, _Exhibit:exhibit_display, _items:Vector.<module>=null)
		{
			super(_items, _main, _Exhibit);
		}
		
	}

}