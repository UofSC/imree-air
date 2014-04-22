package imree.display_helpers {
	import fl.controls.Button;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import imree.Main;
	import imree.modules.module;
	import imree.pages.exhibit_display;
	import imree.shortcuts.box;
	
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class exhibit_navigator extends MovieClip {
		
		public var exhibit:exhibit_display;
		public var main:Main;
		private var wrapper:box;
		private var portrait:Boolean;
		private var butts:Vector.<smart_button>;
		private var t:exhibit_navigator;
		public function exhibit_navigator(_exhibit:exhibit_display, _main:Main) {
			exhibit = _exhibit;
			main = _main;
			t = this;
			portrait = main.Imree.Device.orientation === "portrait";
			this.addEventListener(Event.ADDED_TO_STAGE, added2stage);
			super();
		}
		private function added2stage(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, added2stage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removed_from_stage);
			
			var big_butt_sample:button_navigator_primary_module = new button_navigator_primary_module();
			var small_butt_sample:button_navigator_secondary_module = new button_navigator_secondary_module();
			
			butts = new Vector.<smart_button>();
			for each(var mod:module in exhibit.modules) {
				var butt_ui:button_navigator_primary_module = new button_navigator_primary_module();
				var butt:smart_button = new smart_button(butt_ui, shortcut_clicked);
				butt.data = mod;
				butts.push(butt);
				if (mod === exhibit.current_module()) {
					for each(var mod2:module in mod.items) {
						var small_butt_ui:button_navigator_secondary_module = new button_navigator_secondary_module();
						var small_butt:smart_button = new smart_button(small_butt_ui, small_shortcut_clicked);
						small_butt.data = mod2;
						butts.push(small_butt);
					}
				}
			}
			
			
			if (portrait) {
				wrapper = new box(main.stage.stageWidth, big_butt_sample.height + 20, 0xFFFFFF, 1);
				wrapper.y = main.stage.stageHeight - wrapper.height;
				var butt_x:int = 10;
				for each(butt in butts) {
					wrapper.addChild(butt);
					butt.y = big_butt_sample.height/2 - butt.height /2 + 10;
					butt.x = butt_x;
					butt_x += butt.width + 10;
				}
			} else {
				wrapper  = new box(big_butt_sample.width + 20, main.stage.stageHeight, 0xFFFFFF, 1);
				wrapper.x = main.stage.stageWidth - wrapper.width;
				var butt_y:int = 10;
				for each(butt in butts) {
					wrapper.addChild(butt);
					butt.x = big_butt_sample.width/2 - butt.width /2 + 10;
					butt.y = butt_y;
					butt_y += butt.height + 10;
				}
			}
			addChild(wrapper);
		}
		private function removed_from_stage(e:Event):void {
			this.removeEventListener(Event.REMOVED_FROM_STAGE, removed_from_stage);
			removeChild(wrapper);
			wrapper = null;
		}
		private function shortcut_clicked(probably_module:*=null):void {
			exhibit.dump_and_draw(exhibit.modules.indexOf(module(probably_module)));
		}
		private function small_shortcut_clicked(probably_module:* = null):void {
			exhibit.current_module().focus_on_sub_module(module(probably_module));
		}
		
	}

}