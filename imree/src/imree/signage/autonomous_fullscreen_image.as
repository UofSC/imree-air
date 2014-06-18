package imree.signage 
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.XMLLoader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
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
		private var background_timer:Timer;
		private var current_background_image_url:String;
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
				load_background();
			}
		}
		
		private function load_background(asdf:*= null):void {
			background_timer.stop();
			main.connection.server_command('signage_properties', '', background_image_info_loaded);
			function background_image_info_loaded(e:LoaderEvent):void {
				var xml:XML = XML(XMLLoader(e.target).content);
				var new_url:String = String(xml.result.item.device_background_image_url);
				if (xml.result.item.signage_device_background_image_url) {
					new_url = String(xml.result.item.signage_device_background_image_url);
				}
				if (current_background_image_url != new_url) {		
					current_background_image_url = new_url;
					trace('new image ' + current_background_image_url);
					var original_w:int = background_wrapper.width;
					var original_h:int = background_wrapper.height;
					while (background_wrapper.numChildren) {
						background_wrapper.removeChildAt(0);
					}
					background_wrapper = new box(original_w, original_h, 0x111111, 1);
					addChild(background_wrapper);
					var imgLoader:ImageLoader = new ImageLoader(new_url, main.img_loader_vars(background_wrapper));
					imgLoader.load();
				}
				background_timer.start();
			}
		}
		
	}

}