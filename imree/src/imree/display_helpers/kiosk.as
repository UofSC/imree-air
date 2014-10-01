package imree.display_helpers 
{
	import flash.display.Sprite;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.XMLLoader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	import imree.IMREE;
	import imree.Main;
	import imree.pages.home;
	import imree.shortcuts.box;
	import imree.textFont;
	import fl.containers.BaseScrollPane;
	import flash.display.Sprite;
	import imree.data_helpers.data_value_pair;
	import imree.serverConnect;
	import imree.text;
	import imree.forms.*;
	import imree.pages.exhibit_display;
	
	/**
	 * ...
	 * @author Cole Mendes
	 */
	public class kiosk extends Sprite
	{
		private var background_wrapper:box;
		public var main:Main;
		public var form:f_data;
		private var options:f_element_DynamicOptions;
		private var current_background_image_url:String;
		private var background_timer:Timer;
		private var t:kiosk;
		public var staging_area:box;
		public var Exhibit:exhibit_display;
		private var exhibit_id:int;
		private var start_at_module:int;
		public var Device:device;
		public var UI_width:int;
		public var Home:home;
		public var imree:IMREE;
		
		public function kiosk(_main:Main, imree:IMREE, exhibit_id:int, start_at_module:int) 
		{
			main = _main;
			t = this;
			this.exhibit_id = exhibit_id;
			this.start_at_module = start_at_module;
			this.imree = imree;
			
			Device = new device(main);
			UI_width = Device.ui_size;
			
			staging_area = new box(main.stage.stageWidth, main.stage.stageHeight - UI_width);
			staging_area.y = UI_width;
			
			load();
		}
		
		
		private function load():void
		{
			main.addChild(main.Imree);
			main.Imree.load_exhibit(exhibit_id, start_at_module, 0);
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		private function load_background():void
		{
			var new_url:String = new String("http://imree.tcl.sc.edu/imree-php/file/222");
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
		}
	}

}