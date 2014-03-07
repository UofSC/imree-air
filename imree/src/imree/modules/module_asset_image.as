package imree.modules 
{
	import com.greensock.layout.ScaleMode;
	import com.greensock.loading.data.ImageLoaderVars;
	import com.greensock.loading.ImageLoader;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
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
			t = this;
			super(_main, _Exhibit, _items);
		}
		override public function draw_thumb(_w:int = 200, _h:int = 200):void {
			var result:box = new box(_w, _h, 0xFFFFFF, .2);
			addChild(result);
			var url_request:URLRequest = new URLRequest(asset_url);
			var url_data:URLVariables = new URLVariables();
			if (can_resize) {
				url_data.size = String(_h);
			}
			
			url_request.data = url_data;
			url_request.method = URLRequestMethod.GET;
			main.que_image(new ImageLoader(url_request, main.img_loader_vars(result)));
			if (onSelect !== null) {
				addEventListener(MouseEvent.CLICK, selected);
			}
			function selected(e:MouseEvent):void {
				onSelect(t);
			}
		}
		override public function draw_feature(_w:int, _h:int):void {
			if (draw_feature_on_object !== null) {
				trace('loading ' + asset_url);
				var vars:ImageLoaderVars = main.img_loader_vars(draw_feature_on_object);
					vars.noCache(true);
					vars.scaleMode(ScaleMode.PROPORTIONAL_INSIDE);
				new ImageLoader(asset_url, vars).load();
				
			}
		}
		
	}

}