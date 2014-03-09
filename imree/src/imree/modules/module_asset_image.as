package imree.modules 
{
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Elastic;
	import com.greensock.events.LoaderEvent;
	import com.greensock.layout.ScaleMode;
	import com.greensock.loading.data.ImageLoaderVars;
	import com.greensock.loading.display.ContentDisplay;
	import com.greensock.loading.ImageLoader;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
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
					vars.onComplete(image_downloaded);
					vars.crop(false);
					vars.container(null);
					
				new ImageLoader(asset_url, vars).load();
			}
			
			function image_downloaded(e:LoaderEvent):void {
				var actual_image:ContentDisplay = ImageLoader(e.target).content;
				var bitmap:Bitmap = actual_image.rawContent;
				
				var original_width:int = draw_feature_on_object.width;
				var original_height:int = draw_feature_on_object.height;
				
				var wrapper:box = new box(draw_feature_on_object.width, draw_feature_on_object.height);
				draw_feature_on_object.addChild(wrapper);
				wrapper.addEventListener(MouseEvent.MOUSE_WHEEL, scroll_wheel_on_image);
				wrapper.addChild(bitmap);
				bitmap.scaleX = Math.min(1, bitmap.scaleX);
				bitmap.scaleY = Math.min(1, bitmap.scaleY);
				bitmap.x = 0 - bitmap.width /2;
				bitmap.y = 0 - bitmap.height / 2;
				wrapper.x = (original_width/2) ;
				wrapper.y = (original_height/ 2);
				
				var max_scale:Number = Math.min(1 / bitmap.scaleX, 1 / bitmap.scaleY);
				
				function scroll_wheel_on_image(m:MouseEvent):void {
					TweenLite.to(wrapper, .2, { 
						scaleX:Math.max(wrapper.scaleX + m.delta * .1, .5),
						scaleY:Math.max(wrapper.scaleY + m.delta * .1, .5),
						ease:Cubic.easeInOut,
						onComplete:check_resize
					} ); 
				}
				function check_resize(m:*= null):void {
					TweenLite.to(wrapper, .3, { 
						scaleX:Math.max(Math.min(max_scale, wrapper.scaleX), .5),
						scaleY:Math.max(Math.min(max_scale, wrapper.scaleY), .5),
						ease:Elastic.easeOut
					} ); 
				}
				
			}
		}
		
		
	}

}