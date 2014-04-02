package imree.display_helpers {
	import fl.controls.Button;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import imree.data_helpers.position_data;
	import imree.layout;
	import imree.shortcuts.box;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class modal extends Sprite {
		
		public var scroller:scrollPaneFancy;
		public var content:Sprite;
		public var background:box;
		public var top_UI_wrapper:box;
		public var buttons:Vector.<smart_button>
		public var w:int;
		public var h:int;
		private var t:modal;
		public function modal(_w:int, _h:int, _buttons:Vector.<smart_button>=null, preset_content:DisplayObjectContainer=null, objects:Vector.<DisplayObjectContainer>=null) {
			w = _w;
			h = _h;
			t = this;
			background = new box(w, h, 0x000000, .8);
			addChild(background);
			scroller = new scrollPaneFancy();
			scroller.setSize(w - 20, h- 80);
			addChild(scroller);
			
			content = new Sprite();
			if (preset_content !== null) {
				content.addChild(preset_content);
			}
			
			scroller.source = content;
			update();
			
			top_UI_wrapper = new box(w, 80, 0x000000, 1);
			top_UI_wrapper.y = h - 80;
			addChild(top_UI_wrapper);
			addEventListener(Event.REMOVED_FROM_STAGE, close);
			var current_x:int = top_UI_wrapper.width;
			
			buttons = _buttons;
			if (_buttons === null) {
				buttons = new Vector.<smart_button>();
				var butt_ok:Button = new Button();
				butt_ok.label = "Okay";
				butt_ok.setSize(80, 70);
				buttons.push(new smart_button(butt_ok, okay_event));
			}
			
			for each(var butt:smart_button in buttons) {
				top_UI_wrapper.addChild(butt);
				current_x -= butt.width - 5;
				butt.x = current_x;
				butt.y = 5;
			}
			
			if (objects !== null) {
				add_displayObjects_as_grid(objects);
			}
		}
		public function close(e:*=null):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, close);
		}
		public function update():void {
			scroller.update();
		}
		public function add_displayObjects_as_grid(items:Vector.<DisplayObjectContainer>, padding:int = 10 ):void {
			var proxies:Vector.<position_data> = new Vector.<position_data>();
			for each(var obj:DisplayObjectContainer in items) {
				proxies.push(new position_data(obj.width, obj.height));
			}
			var mason:layout = new layout();
			var positions:Vector.<position_data> = mason.abstract_box_solver(proxies, w, h, padding);
			var objs_wrapper:Sprite = new Sprite();
			content.addChild(objs_wrapper);
			objs_wrapper.y = content.height;
			for (var i:int = 0; i < items.length; i++) {
				objs_wrapper.addChild(items[i]);
				items[i].x = positions[i].x;
				items[i].y = positions[i].y;
			}
			objs_wrapper.x = w / 2 - objs_wrapper.width / 2 - 20;
			update();
		}
		private function okay_event(e:*= null):void  {
			t.parent.removeChild(t);
			t = null;
		}
		
	}

}