package imree.modules 
{
	import com.greensock.loading.ImageLoader;
	import flash.display.Sprite;
	import imree.Main;
	import imree.pages.exhibit_display;
	import imree.shortcuts.box;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class module_asset_image extends module_asset
	{
		
		public function module_asset_image(_main:Main, _Exhibit:exhibit_display,_items:Vector.<module>=null)
		{
			super(_main, _Exhibit, _items);
		}
		override public function draw_thumb(_w:int = 200, _h:int = 200):void {
			var result:box = new box(_w, _h);
			addChild(result);
			var thumb_url:String = asset_url;
			if (can_resize) {
				thumb_url = asset_url + "?size=" + String(_h);
			}
			new ImageLoader(thumb_url, main.img_loader_vars(result)).load();
			
			
		}
		
	}

}