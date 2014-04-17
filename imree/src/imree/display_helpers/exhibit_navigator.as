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
				wrapper = new box(main.stage.stageWidth, main.Imree.Device.box_size / 2, 0xFFFFFF, 1);
				wrapper.y = main.stage.stageHeight - wrapper.height;
				for each(butt in butts) {
					wrapper.addChild(butt);
					butt.y = 5;
					butt.x = butt.width* butts.indexOf(butt);
				}
			} else {
				wrapper  = new box(main.Imree.Device.box_size / 2, main.stage.stageHeight, 0xFFFFFF, 1);
				wrapper.x = main.stage.stageWidth - wrapper.width;
				var butt_y:int = 0;
				for each(butt in butts) {
					wrapper.addChild(butt);
					butt.x = 5;
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