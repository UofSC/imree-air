package imree.modules 
{
	import imree.Main;
	import imree.pages.exhibit_display;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class module_asset extends module 
	{
		public var feature_item:module;
		public var caption:String;
		public var description:String;
		public var filename:String;
		public var asset_url:String;
		public var can_resize:Boolean;
		public var module_asset_id:String;
		public function module_asset( _main:Main, _Exhibit:exhibit_display, _items:Vector.<module>=null)
		{
			super(_main, _Exhibit, _items);
		}
		
	}

}