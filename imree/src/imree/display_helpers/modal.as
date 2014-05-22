package imree.display_helpers {
	//import com.demonsters.debugger.MonsterDebugger;
	import fl.controls.Button;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
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
		private var dir:String;
		public function modal(_w:int, _h:int, _buttons:Vector.<smart_button>=null, preset_content:DisplayObjectContainer=null, objects:Vector.<DisplayObjectContainer>=null, background_color:uint = 0xDEDEDE, background_alpha:Number = .8, direction:String = null) {
			w = _w;
			h = _h;
			t = this;
			if (w > h) {
				dir = "left";
			} else {
				dir = "top";
			}
			if (direction !== null) {
				dir = direction;
			}
			background = new box(w, h, background_color, background_alpha);
			addChild(background);
			scroller = new scrollPaneFancy();
			scroller.setSize(w - 20, h- 80);
			addChild(scroller);
			
			content = new Sprite();
			if (preset_content !== null) {
				content.addChild(preset_content);
				if (direction === "left") {
					preset_content.x = 10;
					preset_content.y = h / 2 - preset_content.height / 2;
				} else {
					preset_content.y = 10;
					preset_content.x = w / 2 - preset_content.width / 2;
				}
			}
			
			
			scroller.source = content;
			update();
			
			top_UI_wrapper = new box(w, 80, 0x000000, 1);
			top_UI_wrapper.y = h - 80;
			addChild(top_UI_wrapper);
			addEventListener(Event.REMOVED_FROM_STAGE, close);
			
			
			buttons = _buttons;
			if (_buttons === null) {
				buttons = new Vector.<smart_button>();
				var butt_ok:Button = new Button();
				butt_ok.label = "Close";
				butt_ok.setSize(80, 70);
				buttons.push(new smart_button(butt_ok, okay_event));
			}
			
			new_buttons(buttons);
			
			if (objects !== null) {
				add_displayObjects_as_grid(objects);
			}
		}
		public function close(e:*=null):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, close);
			for each(var butt:smart_button in buttons) {
				if (butt !== null && butt.parent !== null) {
					butt.parent.removeChild(butt);
				}
			}
		}
		public function update():void {
			scroller.update();
		}
		public function new_buttons(butts:Vector.<smart_button>):void {
			for (var i:int = 0; i < top_UI_wrapper.numChildren; i++) {
				if (top_UI_wrapper.getChildAt(i) is smart_button) {
					top_UI_wrapper.removeChildAt(i);
					i--;
				}
			}
			
			buttons = butts;
			var current_x:int = top_UI_wrapper.width;
			for each(var butt:smart_button in buttons) {
				top_UI_wrapper.addChild(butt);
				current_x -= butt.width + 15;
				butt.x = current_x;
				butt.y = 5;
			}
		}
		public function remove_button(butt:smart_button):void {
			if (buttons.indexOf(butt) > -1) {
				buttons.splice(buttons.indexOf(butt), 1);
				new_buttons(buttons);
			}
		}
		public function add_button(butt:smart_button):void {
			if (buttons.indexOf(butt) == -1) {
				buttons.push(butt);
				new_buttons(buttons);
			}
		}
		
		public function add_displayObjects_as_grid(items:Vector.<DisplayObjectContainer>, padding:int = 10 ):void {
			var proxies:Vector.<position_data> = new Vector.<position_data>();
			for each(var obj:DisplayObjectContainer in items) {
				var position_info:position_data = new position_data(200, 200);
				trace(position_info);
				proxies.push(position_info);
				
			}
			trace("here");
			trace(proxies);
			var mason:layout = new layout();
			var positions:Vector.<position_data> = mason.abstract_box_solver(proxies, w, h, padding,dir);
			
			var objs_wrapper:Sprite = new Sprite();
			
			for (var i:int = 0; i < items.length; i++) {
				objs_wrapper.addChild(items[i]);
				items[i].x = positions[i].x;
				items[i].y = positions[i].y;
			}
			
			if (dir == "left") {
				objs_wrapper.x = content.width;
				objs_wrapper.y = h / 2 - objs_wrapper.height / 2 -40 ;
			} else {
				objs_wrapper.y = content.height;
				objs_wrapper.x = w / 2 - objs_wrapper.width / 2 - 20;
			}
			content.addChild(objs_wrapper);
			update();
		}
		private function okay_event(e:*= null):void  {
			t.parent.removeChild(t);
			t = null;
		}
		public function scroll_to(_x:int, _y:int):void {
			scroller.horizontalScrollPosition = _x;
			scroller.verticalScrollPosition = _y;
		}
		public function get_scoll_point():Point {
			return new Point(scroller.horizontalScrollPosition, scroller.verticalScrollPosition);
		}
		
	}

}