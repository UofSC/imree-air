package imree.modules 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.system.Worker;
	import flash.utils.Timer;
	import imree.data_helpers.position_data;
	import imree.layout;
	import imree.Main;
	import imree.pages.exhibit_display;
	import imree.shortcuts.box;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class module_grid extends module
	{
		public function module_grid(_main:Main, _Exhibit:exhibit_display, _items:Vector.<module>=null)
		{
			super(_main, _Exhibit, _items);
		}
		override public function draw_thumb(_w:int = 200, _h:int = 200):void {
			
		}
		override public function draw_feature(_w:int, _h:int):void {
			var overflow_from_direction:String;
			if (main.Imree.Device.orientation === 'portrait') {
				overflow_from_direction = "top";
			} else {
				overflow_from_direction = "left";
			}
			
			var raw_positions:Vector.<position_data> = new Vector.<position_data>();
			for each(var i:module in items) {
				raw_positions.push(new position_data(main.Imree.Device.box_size * i.thumb_display_columns, main.Imree.Device.box_size * i.thumb_display_rows));
			}
			
			var positions:Vector.<position_data> = new layout().abstract_box_solver(raw_positions, _w+50, _h, 5, overflow_from_direction, true);
			
			var wrapper:Sprite = new Sprite();
			for (var j:int = 0; j < items.length; j++) {
				items[j].draw_thumb(positions[j].width, positions[j].height);
				wrapper.addChild(items[j]);
				items[j].x = positions[j].x;
				items[j].y = positions[j].y;
				items[j].addEventListener(MouseEvent.MOUSE_DOWN, test4longpress);
				items[j].addEventListener(MouseEvent.CLICK, item_selected);
			}
			addChild(wrapper);
			
			var tim:Timer = new Timer(1100);
			var longpress_waiting:Boolean = false;
			function test4longpress(e:MouseEvent):void {
				if(user_can_edit) {
					tim.reset();
					tim.addEventListener(TimerEvent.TIMER, mouse_held);
					e.currentTarget.addEventListener(MouseEvent.MOUSE_OUT, mouse_end);
					e.currentTarget.addEventListener(MouseEvent.MOUSE_UP, mouse_end);
					e.currentTarget.addEventListener(MouseEvent.ROLL_OUT, mouse_end);
					e.currentTarget.addEventListener(MouseEvent.MOUSE_MOVE, mouse_moved);
					tim.start();
					longpress_waiting = false;
				}
				function mouse_held(te:TimerEvent):void {
					longpress();
					longpress_waiting = true;
					e.currentTarget.removeEventListener(MouseEvent.MOUSE_OUT, mouse_end);
					e.currentTarget.removeEventListener(MouseEvent.MOUSE_UP, mouse_end);
					e.currentTarget.removeEventListener(MouseEvent.ROLL_OUT, mouse_end);
					e.currentTarget.removeEventListener(MouseEvent.MOUSE_MOVE, mouse_moved);
					tim.stop();
					tim.removeEventListener(TimerEvent.TIMER, longpress);	
				}
				function mouse_moved(e2:MouseEvent):void {
					if ((e2.stageX - e.stageX) + (e2.stageY - e.stageY) > 10) {
						mouse_end(e2);
					}
				}
				function mouse_end(e2:MouseEvent):void {
					e.currentTarget.removeEventListener(MouseEvent.MOUSE_OUT, mouse_end);
					e.currentTarget.removeEventListener(MouseEvent.MOUSE_UP, mouse_end);
					e.currentTarget.removeEventListener(MouseEvent.ROLL_OUT, mouse_end);
					e.currentTarget.removeEventListener(MouseEvent.MOUSE_MOVE, mouse_moved);
					tim.stop();
					tim.removeEventListener(TimerEvent.TIMER, longpress);	
					longpress_waiting = false;
				}
			}
			
			function longpress(e:*=null):void {
				Exhibit.sort_background = new box(main.stage.stageWidth, main.stage.stageHeight, 0xEDEDED, .5);
				Exhibit.sort_background.mouseChildren = false;
				Exhibit.addChild(Exhibit.sort_background);
				var sort_wrapper:Sprite = new Sprite();
				Exhibit.sort_background.addChild(sort_wrapper);
				sort_wrapper.x = this.x;
				sort_wrapper.y = this.y;
				
				var hero:box;
				var bks:Vector.<box> = new Vector.<box>();
				
				for (var j:int = 0; j < items.length; j++ ) {
					items[j].module_order = j;
					var bk:box = new box(items[j].width, items[j].height, 0x66DD66, .2, 1, 0xFFFFFF);
					bk.data = { item:items[j], index:j };
					bk.x = items[j].getBounds(Exhibit).x;
					bk.y = items[j].getBounds(Exhibit).y;
					var bits:BitmapData = new BitmapData(items[j].width, items[j].height, false);
					bits.draw(items[j]);
					bk.alpha = .5;
					bk.addChild(new Bitmap(bits));
					sort_wrapper.addChild(bk);
					bks.push(bk);
					if (bk.hitTestPoint(stage.mouseX, stage.mouseY)) {
						hero = bk;
					}
				}
				
				Exhibit.sort_background.addEventListener(MouseEvent.MOUSE_MOVE, drag);
				
				function drag(evt_move:MouseEvent):void {
					trace(evt_move.localX);
					get_mouse_target();
					hero.x = stage.mouseX - hero.width / 2;
					hero.y = stage.mouseY - hero.height / 2;
				}
				
				function get_mouse_target():box {
					var result:box;
					for each(var b:box in bks) {
						if(hero !== b) {
							if (b.hitTestPoint(stage.mouseX, stage.mouseY)) {
								b.alpha = 1;
								result = b;
							} else {
								b.alpha = .5;
							}
						}
					}
					return result;
				}
				
				Exhibit.sort_background.addEventListener(MouseEvent.CLICK, drag_end);
				Exhibit.sort_background.addEventListener(MouseEvent.MOUSE_UP, drag_end);
				function drag_end(evt2:MouseEvent):void {
					Exhibit.sort_background.removeEventListener(MouseEvent.MOUSE_MOVE, drag);
					Exhibit.sort_background.removeEventListener(MouseEvent.MOUSE_UP, drag_end);
					Exhibit.sort_background.removeEventListener(MouseEvent.CLICK, drag_end);
					while (Exhibit.sort_background.numChildren) {
						Exhibit.sort_background.removeChildAt(0);
					}
					if (Exhibit.sort_background.parent === Exhibit) {
						Exhibit.removeChild(Exhibit.sort_background);
					}
				}
				
			}
			
			
			function item_selected(e:MouseEvent):void {
				if (!longpress_waiting) {
					Exhibit.bring_asset_to_front(module_asset(e.currentTarget));
				}
			}
			
		}
		
		
	}

}