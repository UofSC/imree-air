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
	import imree.data_helpers.permission;
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
			t = this;
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
				items[j].addEventListener(MouseEvent.MOUSE_DOWN, start_longpress_test);
				items[j].addEventListener(MouseEvent.CLICK, item_selected);
			}
			addChild(wrapper);
			
			var indicator:longpress_indicator = new longpress_indicator(longpress_complete);
			indicator.stop();
			var longpress_inProgress:Boolean = false;
			var longpress_activated_mouseDown:Boolean = false;
			function start_longpress_test(evt:MouseEvent):void {
				var permissions:permission = new permission();
				if(main.User.can("exhibit", permissions.EDIT, String(Exhibit.id))) {
					if (!longpress_inProgress) {
						longpress_inProgress = true;
						main.stage.addEventListener(MouseEvent.MOUSE_UP, longpress_terminated);
						indicator.gotoAndPlay(0);
						main.addChild(indicator);
						indicator.x = stage.mouseX;
						indicator.y = stage.mouseY;
					}
				}
			}
			function longpress_terminated(evt:*= null):void {
				indicator.stop();
				indicator.parent.removeChild(indicator);
				main.stage.removeEventListener(MouseEvent.MOUSE_UP, longpress_terminated);
				var tim:Timer = new Timer(300);
				tim.addEventListener(TimerEvent.TIMER, tick);
				tim.start();
				function tick(te:TimerEvent):void {
					longpress_inProgress = false;
					longpress_activated_mouseDown = false;
					tim.removeEventListener(TimerEvent.TIMER, tick);
					tim.stop();
					tim = null;
				}
			}
			function longpress_complete(evt:* = null):void {
				longpress_activated_mouseDown = true;
				Exhibit.reorder_items_in_module(t, save_new_mod_order);
			}
			
			
			
			function item_selected(e:MouseEvent):void {
				if(!longpress_activated_mouseDown) {
					Exhibit.bring_asset_to_front(module_asset(e.currentTarget));
				}
				
			}
			
		}
		
		private var pending_save:int = 0;
		public function save_new_mod_order():void {
			
			for each(var m:module in items) {
				if (m is module_asset) {
					pending_save++;
					var data:Object = { 'table':'module_assets', 'where':" module_asset_id = '" + module_asset(m).module_asset_id + "' ", 'columns': { "module_asset_order":String(items.indexOf(m)) } };
					main.connection.server_command("update", data, reload, true);
				}
			}
		}
		public function reload(e:*=null):void {
			main.log("Save Pending: " + String(pending_save));
			pending_save--;
			if (pending_save === 0) {
				Exhibit.reload_current_page();
			}
		}
		
		
	}

}