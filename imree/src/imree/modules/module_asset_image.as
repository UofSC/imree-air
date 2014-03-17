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
	import flash.events.GestureEvent;
	import flash.events.GesturePhase;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.events.TransformGestureEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.sensors.Accelerometer;
	import flash.system.Capabilities;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
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
		
		public var loading_indicator:loading_spinner_sprite;
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
				if (onSelect !== null) {
					onSelect(t);
				}
			}
			
		}
		override public function draw_feature(_w:int, _h:int):void {
			if (draw_feature_on_object !== null) {
				main.log('Loading module.module_asset_image [id:' + module_id + '] [name: ' + module_name + '] ' + asset_url);
				var vars:ImageLoaderVars = main.img_loader_vars(draw_feature_on_object);
					vars.noCache(true);
					vars.scaleMode(ScaleMode.PROPORTIONAL_INSIDE);
					vars.onComplete(image_downloaded);
					vars.crop(false);
					vars.container(null);
				new ImageLoader(asset_url, vars).load();
				loading_indicator = new loading_spinner_sprite();
				loading_indicator.blendMode = BlendMode.SCREEN;
				draw_feature_on_object.addChild(loading_indicator);
				loading_indicator.x = _w/ 2 - 128/2;
				loading_indicator.y = _h/ 2 - 128/2;
			} else {
				main.log('you need to have set the draw_feature_on_object from outside the module before calling draw_feature()');
			}
			
			function image_downloaded(e:LoaderEvent):void {
				draw_feature_on_object.removeChild(loading_indicator);
				loading_indicator = null;
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
				
				var blitmask:BlitMask = new BlitMask(wrapper, 0, 0,original_width, original_height);
				blitmask.bitmapMode = false;
				var max_scale:Number = Math.min(1 / bitmap.scaleX, 1 / bitmap.scaleY) + .05;
				
				function scroll_wheel_on_image(m:MouseEvent):void {
					var factor:Number = m.delta *.1;
					if (main.Imree.Device.orientation === 'portrait') {
						factor *= 5;
					}
					TweenLite.to(wrapper, .2, { 
						scaleX:Math.max(wrapper.scaleX + factor, .5),
						scaleY:Math.max(wrapper.scaleY + factor, .5),
						ease:Cubic.easeInOut,
						onComplete:check_resize
					} ); 
				}
				function check_resize(m:*= null):void {
					if(wrapper.scaleX > max_scale || wrapper.scaleY > max_scale) {
						TweenLite.to(wrapper, .6, { 
							scaleX:Math.max(Math.min(max_scale, wrapper.scaleX), .5),
							scaleY:Math.max(Math.min(max_scale, wrapper.scaleY), .5),
							ease:Elastic.easeOut
						} ); 
					}
				}
				
				wrapper.addEventListener(MouseEvent.MOUSE_DOWN, start_feature_drag);
				function start_feature_drag(m:MouseEvent):void {
					wrapper.startDrag();
					wrapper.addEventListener(MouseEvent.MOUSE_OUT, stop_feature_drag);
					wrapper.addEventListener(MouseEvent.MOUSE_UP, stop_feature_drag);
				}
				function stop_feature_drag(m:MouseEvent):void {
					wrapper.stopDrag();
					wrapper.removeEventListener(MouseEvent.MOUSE_OUT, stop_feature_drag);
					wrapper.removeEventListener(MouseEvent.MOUSE_UP, stop_feature_drag);
				}
				
			
					trace("Ac support is "	+ Accelerometer.isSupported);
					var ac:Accelerometer = new Accelerometer();
					var isSupported:Boolean = Accelerometer.isSupported;
					checkSupport();
					
				function checkSupport():void {
					if (isSupported){
				
				Multitouch.inputMode = MultitouchInputMode.GESTURE;
				wrapper.addEventListener(TransformGestureEvent.GESTURE_ZOOM, onZoom);
				
				function onZoom(evt:TransformGestureEvent):void {
					var scaleResult:Number = 1 / ((evt.scaleX + evt.scaleY) / 2);
					wrapper.scaleX += 1-scaleResult;
					wrapper.scaleY += 1 - scaleResult;
					
					if (evt.phase==GesturePhase.END) { 
						check_resize();
					}
				}
				function distanceofTwo(x1:Number, x2:Number, y1:Number, y2:Number):Number {
					var dx:Number = x1 - x2;
					var dy:Number = y1 - y2;
					return Math.sqrt(dx^2 + dy^2);							
				}
			}
						
			else {
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
				}
			}
			
		}
		
		}
		override public function dump():void {
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			super.dump();
		}
		
	}

}