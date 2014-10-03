package imree.signage 
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.data.ImageLoaderVars;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.XMLLoader;
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	import imree.Main;
	import imree.shortcuts.box;
	
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class autonomous_fullscreen_image extends MovieClip 
	{
		private var main:Main;
		private var background_wrapper:box;
		private var image_wrappers:Vector.<MovieClip>;
		private var background_timer:Timer;
		private var animated_images_timer:Timer;
		private var current_background_image_url:String;
		private var current_background_images:String;
		private var t:autonomous_fullscreen_image;
		public function autonomous_fullscreen_image(_main:Main) 
		{
			super();
			main = _main;
			t = this;
			this.addEventListener(Event.ADDED_TO_STAGE, added_to_stage);
			function added_to_stage(e:Event):void {
				t.removeEventListener(Event.ADDED_TO_STAGE, added_to_stage);
				background_wrapper = new box(main.stage.fullScreenWidth, main.stage.fullScreenHeight, 0x111111, 1);
				addChild(background_wrapper);
				background_timer = new Timer(5000, 0);
				background_timer.addEventListener(TimerEvent.TIMER, load_background);
				animated_images_timer = new Timer(5000, 0);
				load_background();
			}
		}
		private function clean_image_wrappers():void {
			if (image_wrappers !== null) {
				while (image_wrappers.length > 0) {
					image_wrappers[0] = null;
					image_wrappers.shift();
				}
			}
			image_wrappers = new Vector.<MovieClip>();
		}
		private function clean_background_wrapper(w:int, h:int):void {
			while (background_wrapper.numChildren) {
				background_wrapper.removeChildAt(0);
			}
			if (this.contains(background_wrapper)) {
				removeChild(background_wrapper);
				background_wrapper = null;
			}
			background_wrapper = new box(w, h, 0x111111, 1);
			addChild(background_wrapper);
		}
		
		private function load_background(asdf:*= null):void {
			background_timer.stop();
			main.connection.server_command('signage_properties', '', background_image_info_loaded);
			function background_image_info_loaded(e:LoaderEvent):void {
				Mouse.hide();
				var xml:XML = XML(XMLLoader(e.target).content);
				if (String(xml.result.item.signage_device_extra_images_urls) !== "") {
					trace("device is slideshow");
					background_timer = new Timer(30000);
					background_timer.addEventListener(TimerEvent.TIMER, load_background);
					var urls:Array = String(xml.result.item.signage_device_extra_images_urls).replace(" ", "").split(',');
					for (var k:int = 0; k < urls.length; k++) {
						if (String(urls[k]).substr(0, 1) === " ") {
							urls[k] = String(urls[k]).substr(1);
						}
					}
					
					if (urls.join('') != current_background_images) {
						trace('new images for the slideshow, reloading show');
						current_background_images = urls.join('');
						var original_w:int = background_wrapper.width;
						var original_h:int = background_wrapper.height;
						
						clean_image_wrappers();
						clean_background_wrapper(original_w,original_h);
						if (animated_images_timer !== null) {
							animated_images_timer.removeEventListener(TimerEvent.TIMER, cycle_images);
							animated_images_timer.stop();
							animated_images_timer = null;
						}
						
						for (var i:int = 0; i < urls.length; i++) {
							var wrapper_i:MovieClip = new MovieClip();
							wrapper_i.addChild(new box(original_w, original_h, 0x111111, 1));
							wrapper_i.alpha = 0;
							background_wrapper.addChild(wrapper_i);
							image_wrappers.push(wrapper_i);
							trace('loading: ' + urls[i]);
							var loader_i:ImageLoader = new ImageLoader(String(urls[i]), main.img_loader_vars(wrapper_i).onComplete(image_i_loaded));
							loader_i.load();
						}
						var waiting_on:int = urls.length;
						function image_i_loaded(poop:*= null):void {
							waiting_on--;
							trace("waiting for " + waiting_on + " images to load");
							if (waiting_on < 1) {
								animated_images_timer = new Timer(Number(xml.result.item.signage_device_slide_length) * 1000);
								animated_images_timer.addEventListener(TimerEvent.TIMER, cycle_images);
								animated_images_timer.start();
							}
						}
						
						var current_image:int = 0;
						function cycle_images (evt:*=null):void {
							TweenLite.to(image_wrappers[current_image], .5, { alpha:0 } );
							if (current_image >= image_wrappers.length - 1) {
								current_image = 0;
							} else {
								current_image++;
							}
							TweenLite.to(image_wrappers[current_image], 1, { alpha:1 } );
						}
					}
				} else {
					var new_url:String = String(xml.result.item.device_background_image_url);
					if (xml.result.item.signage_device_background_image_url) {
						new_url = String(xml.result.item.signage_device_background_image_url);
					}
					if (current_background_image_url != new_url) {		
						current_background_image_url = new_url;
						trace('new image ' + current_background_image_url);
						clean_image_wrappers();
						clean_background_wrapper(background_wrapper.width,background_wrapper.height);
						
						var imgLoader:ImageLoader = new ImageLoader(new_url, main.img_loader_vars(background_wrapper));
						imgLoader.load();
					}
				}
				background_timer.start();
			}
		}
		
	}

}