package imree.modules 
{
	import com.greensock.BlitMask;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Elastic;
	import com.greensock.events.LoaderEvent;
	import com.greensock.layout.ScaleMode;
	import com.greensock.loading.data.ImageLoaderVars;
	import com.greensock.loading.display.ContentDisplay;
	import com.greensock.loading.ImageLoader;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.Capabilities;
	import imree.display_helpers.modal;
	import imree.display_helpers.window;
	import imree.images.loading_spinner_sprite;
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
			module_supports_reordering = true;
			
		}
		override public function draw_thumb(_w:int = 200, _h:int = 200, Return:Boolean = false):* {
			thumb_wrapper = new Sprite();
			
			var result:box = new box(_w, _h, 0xFFFFFF, .2);
			thumb_wrapper.addChild(result);
			
			var url_request:URLRequest = new URLRequest(asset_url);
			var url_data:URLVariables = new URLVariables();
			if (can_resize) {
				url_data.size = String(_h);
			}
			
			url_request.data = url_data;
			url_request.method = URLRequestMethod.GET;
			
			var imgvars:ImageLoaderVars = new ImageLoaderVars();
			imgvars.crop(true);
			imgvars.width(_w);
			imgvars.height(_h);
			imgvars.noCache(true);
			imgvars.scaleMode(ScaleMode.PROPORTIONAL_OUTSIDE);
			imgvars.container(result);
			new ImageLoader(asset_url + "?size=" + String(_h), imgvars).load();
			if (onSelect !== null && Return === false) {
				thumb_wrapper.addEventListener(MouseEvent.CLICK, thumb_clicked);
			}
			if (Return) {
				return thumb_wrapper;
			} else {
				addChild(thumb_wrapper);
				return null;
			}
		}
		private function thumb_clicked(e:MouseEvent):void {
			if (onSelect !== null) {
				onSelect(t);
			}
		}
		
		override public function drop_thumb():void {
			if (thumb_wrapper !== null) {
				thumb_wrapper.removeEventListener(MouseEvent.CLICK, thumb_clicked);
			}
			super.drop_thumb();
		}
		override public function draw_feature(_w:int, _h:int):void {
			
			main.log('Loading [id:' + module_id + '] [name: ' + module_name + '] ' + asset_url);
			
			prepare_asset_window(_w, _h);
			
			var vars:ImageLoaderVars = main.img_loader_vars(asset_content_wrapper);
				vars.noCache(true);
				vars.onComplete(image_downloaded);
				vars.crop(false);
				vars.container(null);
				vars.scaleMode(ScaleMode.PROPORTIONAL_INSIDE);
			new ImageLoader(asset_url, vars).load();
			
			function image_downloaded(e:LoaderEvent):void {
				asset_content_wrapper.removeChild(loading_indicator);
				loading_indicator = null;
				var actual_image:ContentDisplay = ImageLoader(e.target).content;
				var bitmap:Bitmap = actual_image.rawContent;
				
				asset_content_wrapper.mouseChildren = false;
				asset_content_wrapper.mouseEnabled = true;
				
				/**
				 * Add bitmap and change scale
				 */
				var original_width:int = asset_content_wrapper.width;
				var original_height:int = asset_content_wrapper.height;
				var image_wrapper:box = new box(original_width, original_height);
				image_wrapper.mouseEnabled = false;
				asset_content_wrapper.addChild(image_wrapper);
				image_wrapper.addChild(bitmap);
				bitmap.scaleX = Math.min(1, bitmap.scaleX);
				bitmap.scaleY = Math.min(1, bitmap.scaleY);
				var max_scale:Number = Math.min(1 / bitmap.scaleX, 1 / bitmap.scaleY);
				
				/**
				 * Offset the registration point of bitmap to be visual center
				 */
				bitmap.x = 0 - bitmap.width /2;
				bitmap.y = 0 - bitmap.height / 2;
				image_wrapper.x = (original_width / 2);
				image_wrapper.y = (original_height/ 2);
				
				/**
				 * Handle Mouse scroll wheel interactions
				 */
				asset_content_wrapper.addEventListener(MouseEvent.MOUSE_WHEEL, scroll_wheel_on_image);
				function scroll_wheel_on_image(m:MouseEvent):void {
					var factor:Number = m.delta *.1;
					if (main.Imree.Device.orientation === 'portrait') {
						factor *= 5;
					}
					TweenLite.to(image_wrapper, .2, { 
						scaleX:Math.max(image_wrapper.scaleX + factor, .5),
						scaleY:Math.max(image_wrapper.scaleY + factor, .5),
						ease:Cubic.easeInOut,
						onComplete:check_resize
					} ); 
				}
				function check_resize(m:*= null):void {
					if(image_wrapper.scaleX > max_scale || image_wrapper.scaleY > max_scale) {
						TweenLite.to(image_wrapper, .6, { 
							scaleX:Math.max(Math.min(max_scale, image_wrapper.scaleX), .5),
							scaleY:Math.max(Math.min(max_scale, image_wrapper.scaleY), .5),
							ease:Elastic.easeOut
						} ); 
					}
				}
				
				/**
				 * Handle mouse/finger drag interactions
				 */
				asset_content_wrapper.addEventListener(MouseEvent.MOUSE_DOWN, start_feature_drag);
				function start_feature_drag(m:MouseEvent):void {
					image_wrapper.startDrag();
					asset_content_wrapper.addEventListener(MouseEvent.MOUSE_OUT, stop_feature_drag);
					asset_content_wrapper.addEventListener(MouseEvent.MOUSE_UP, stop_feature_drag);
				}
				function stop_feature_drag(m:MouseEvent):void {
					image_wrapper.stopDrag();
					asset_content_wrapper.removeEventListener(MouseEvent.MOUSE_OUT, stop_feature_drag);
					asset_content_wrapper.removeEventListener(MouseEvent.MOUSE_UP, stop_feature_drag);
				}
				
				/**
				 * Handle pinch-zoom interactions
				 */
				if (Capabilities.touchscreenType != "none") {
					asset_content_wrapper.addEventListener(TransformGestureEvent.GESTURE_ZOOM, gesture_zoom_start);
				}
				function gesture_zoom_start(fingers:TransformGestureEvent):void {
					var scale_factor:Number = Math.min(fingers.scaleX, fingers.scaleY);
					if ((fingers.scaleX + fingers.scaleY) / 2 > 0) {
						scale_factor = Math.max(fingers.scaleX, fingers.scaleY);
					} 
					image_wrapper.scaleX *= scale_factor;
					image_wrapper.scaleY *= scale_factor;
				}
				
				/**
				 * prepare for garbage collection
				 */
				addEventListener(Event.REMOVED_FROM_STAGE, clear_image_listeners);
				function clear_image_listeners(event:Event):void {
					image_wrapper.removeEventListener(MouseEvent.MOUSE_WHEEL, scroll_wheel_on_image);
					image_wrapper.removeEventListener(TransformGestureEvent.GESTURE_ZOOM, gesture_zoom_start);
					image_wrapper.removeEventListener(MouseEvent.MOUSE_DOWN, start_feature_drag);
				}
			}
			phase_feature = true;
		}
		
		
	}

}