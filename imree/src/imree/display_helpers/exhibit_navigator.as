package imree.display_helpers {
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import fl.controls.Button;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	import imree.data_helpers.Theme;
	import imree.IMREE;
	import imree.Main;
	import imree.modules.module;
	import imree.pages.exhibit_display;
	import imree.shortcuts.box;
	import imree.text;
	import imree.textFont;
	
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class exhibit_navigator extends MovieClip {
		
		public var exhibit:exhibit_display;
		public var main:Main;
		public var wrapper:box;
		private var portrait:Boolean;
		private var butts:Vector.<smart_button>;
		private var t:exhibit_navigator;
		private var on_x:int;
		private var on_y:int;
		private var off_x:int;
		private var off_y:int;
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
			portrait = main.Imree.Device.orientation === "portrait";
			var max_width:int = 320;
			
			if (Theme.font_style_title === null) {
				return;
			}
			
			butts = new Vector.<smart_button>();
			var format:textFont = Theme.font_style_description;
			for each(var mod:module in exhibit.modules) {
				var original_align:String = format.align;
				format.align = TextFormatAlign.CENTER;
				var butt_text:text = new text(mod.module_name, max_width - 20, format);
				format.align = original_align;
				var butt_ui:box = new box(max_width, butt_text.height + 10);
				butt_ui.addChild(butt_text);
				butt_text.x = 10; 
				butt_text.y = 5;
				var butt:smart_button = new smart_button(butt_ui, shortcut_clicked);
				butt.data = mod;
				butts.push(butt);
				if (mod === exhibit.current_module()) {
					for each(var mod2:module in mod.items) {
						var small_butt_ui:box = new box(40, 40);
						small_butt_ui.graphics.beginFill(Theme.font_style_description.color, 1);
						small_butt_ui.graphics.drawCircle(small_butt_ui.width / 2, small_butt_ui.height / 2, 10);
						small_butt_ui.graphics.endFill();
						var small_butt:smart_button = new smart_button(small_butt_ui, small_shortcut_clicked);
						small_butt.data = mod2;
						butts.push(small_butt);
					}
				}
			}
			
			
			
			wrapper  = new box(max_width, main.Imree.staging_area.height, Theme.background_color_secondary, 1);
			wrapper.x = main.stage.stageWidth - wrapper.width;
			off_x = 0;
			off_y = 0 - wrapper.height;
			var butt_y:int = 10;
			for each(butt in butts) {
				wrapper.addChild(butt);
				butt.x = max_width/2 - butt.width /2 + 5;
				butt.y = butt_y;
				butt_y += butt.height + 5;
			}
			
			addChild(wrapper);
			
			var toggle_b:Sprite = new Sprite();
			toggle_b.addChild(new box(max_width, IMREE.web_bar_height, 0x333333, 1));
			var original_align2:String = format.align;
			format.align = TextFormatAlign.CENTER;
			if(exhibit.current_module() !== null) {
				var txt:text = new text(exhibit.current_module().module_name, max_width, format);
				format.align = original_align2;
				txt.y = toggle_b.height / 2 - txt.height / 2;
				toggle_b.addChild(txt);
			}
			toggler= new smart_button(toggle_b, toggle);
			
			on = true;
			
			main.Imree.web_bar();
			TweenLite.from(this, .6, { x:off_x, y:off_y, ease:Cubic.easeOut } );
			var tim:Timer = new Timer(2500, 1);
			tim.addEventListener(TimerEvent.TIMER, timer_ticked);
			tim.start();
			function timer_ticked(f:Event):void {
				tim.stop();
				tim.removeEventListener(TimerEvent.TIMER, timer_ticked);
				tim = null;
				hide();
			}
			
		}
		public var toggler:smart_button;
		private var on:Boolean;
		public function toggle(e:* = null):void {
			if (on) {
				hide();
			} else {
				show();
			}
		}
		public function show(e:*= null):void {
			if(!on) {
				TweenLite.to(this, .5, { x:0, y:0, ease:Cubic.easeOut } );
				if (main.Imree.current_page is exhibit_display) {
					exhibit_display(main.Imree.current_page).overlay_remove();
				}
				on = true;
			}
		}
		public function hide(e:* = null):void {
			if (on) {
				TweenLite.to(this, .6, { x:off_x, y:off_y, ease:Cubic.easeIn } );
				on = false;
			}
		}
		private function removed_from_stage(e:Event):void {
			this.removeEventListener(Event.REMOVED_FROM_STAGE, removed_from_stage);
			if(wrapper !== null) {
				removeChild(wrapper);
				wrapper = null;
			}
		}
		private function shortcut_clicked(probably_module:*= null):void {
			hide();
			exhibit.dump_and_draw(exhibit.modules.indexOf(module(probably_module)));
		}
		private function small_shortcut_clicked(probably_module:* = null):void {
			hide();
			exhibit.current_module().focus_on_sub_module(module(probably_module));
		}
		
	}

}