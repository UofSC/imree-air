package imree.modules 
{
	import com.greensock.data.TweenLiteVars;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import fl.controls.Button;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
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
		public var grid_feature_drawn:Boolean = false;
		public function module_grid(_main:Main, _Exhibit:exhibit_display, _items:Vector.<module>=null)
		{
			t = this;
			super(_main, _Exhibit, _items);
		}
		override public function draw_thumb(_w:int = 200, _h:int = 200):void {
			
		}
		override public function draw_feature(_w:int, _h:int):void {
			phase_feature = true;
			grid_feature_drawn = true;
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
		
		override public function draw_edit_button():void {
			if(edit_button === null) {
				edit_button = new Sprite();
				var button:Button = new Button();
				button.setSize(main.Imree.Device.box_size / 4, main.Imree.Device.box_size / 4);
				button.label = "Edit Grid";
				edit_button.addChild(button);
				edit_button.y -= main.Imree.Device.box_size / 3;
				edit_button.addEventListener(MouseEvent.CLICK, draw_edit_UI);
			}
			phase_feature = grid_feature_drawn;
			super.draw_edit_button();
		}
		override public function draw_edit_UI(e:* = null, animate:Boolean = true):void {			
			edit_background = new Sprite();
			edit_background.addChild(new box(main.stage.stageWidth, main.stage.stageHeight, 0x00FF66,1));
			main.Imree.Exhibit.addChild(edit_background);
			edit_wrapper = new Sprite();
			edit_background.addChild(edit_wrapper);
			var proxies:Vector.<box> = make_proxies(edit_background);
			for (var i:int = 0; i < proxies.length; i++ ) {
				edit_wrapper.addChild(proxies[i]);
				if (animate) {
					TweenLite.from(proxies[i], .5, { x:items[i].getBounds(main.stage).x, y:items[i].getBounds(main.stage).y, delay:.08 * i, ease:Cubic.easeInOut } );
				}
				proxies[i].addEventListener(MouseEvent.MOUSE_DOWN, proxy_mouseDown);
			}
			edit_wrapper.x = main.Imree.Device.box_size / 4;
			edit_wrapper.y = main.Imree.Device.box_size / 4;
			
			var current_proxy_focus:Sprite;
			var proxy_cursor:box;
			function proxy_mouseDown(evt:MouseEvent):void {
				current_proxy_focus = Sprite(evt.currentTarget);
				proxy_cursor = new box(100, 100);
				var bits:BitmapData = new BitmapData(100, 100);
				bits.draw(current_proxy_focus);
				proxy_cursor.addChild(new Bitmap(bits));
				edit_wrapper.addChild(proxy_cursor);
				proxy_cursor.x = main.stage.mouseX - edit_wrapper.x;
				proxy_cursor.y = main.stage.mouseY - edit_wrapper.y;
				main.stage.addEventListener(MouseEvent.MOUSE_MOVE, proxy_mouseMove);
				main.stage.addEventListener(MouseEvent.MOUSE_UP, proxy_mouseUp);
				function proxy_mouseUp(stage_event:MouseEvent):void {
					main.stage.removeEventListener(MouseEvent.MOUSE_MOVE, proxy_mouseMove);
					main.stage.removeEventListener(MouseEvent.MOUSE_UP, proxy_mouseUp);
					edit_wrapper.removeChild(proxy_cursor);
					proxy_cursor = null;
					var target:box = test_proxies_for_mouse_position();
					if (target !== null) {
						change_mod_order(box(current_proxy_focus).data.mod, target.data.index);
						dump_edit_UI();
						draw_edit_UI(null, false );
					}
				}
				function proxy_mouseMove(stage_event:MouseEvent):void {
					var match:box = test_proxies_for_mouse_position();
					proxy_cursor.x = main.stage.mouseX - edit_wrapper.x;
					proxy_cursor.y = main.stage.mouseY - edit_wrapper.y;
				}
			}
			function dump_edit_UI():void {
				for each(var poo:box in proxies) {
					poo.addEventListener(MouseEvent.MOUSE_DOWN, proxy_mouseDown);
					poo.parent.removeChild(poo);
					poo = null;
				}
				while (edit_wrapper.numChildren) {
					edit_wrapper.removeChildAt(0);
				}
			}
			function test_proxies_for_mouse_position():box {
				var hero:box;
				for each(var p:box in proxies) {
					if (p != current_proxy_focus) {
						if (p.hitTestPoint(stage.mouseX, stage.mouseY)) {
							Sprite(p).transform.colorTransform = new ColorTransform(0, 0, 0);
							hero = p;
						} else {
							Sprite(p).transform.colorTransform = new ColorTransform();
						}
					}
				}
				return hero;
			}
			
			/**
			 * save button
			 */

			var cancel_btn:Button = new Button();
			edit_wrapper.addChild(cancel_btn);
			cancel_btn.addEventListener(MouseEvent.CLICK, cancel_btn_click);
			cancel_btn.label = "Cancel";
			cancel_btn.x = edit_background.width - cancel_btn.textField.width - 20;
			cancel_btn.y = edit_background.height - cancel_btn.textField.height - 20;
			function cancel_btn_click(m:MouseEvent):void {
				dump_edit_UI();
				main.Imree.Exhibit.removeChild(edit_background);
				edit_background = null;
			}
			var save_btn:Button = new Button();
			edit_wrapper.addChild(save_btn);
			save_btn.addEventListener(MouseEvent.CLICK, save_btn_click);
			save_btn.label = "Save";
			save_btn.x = cancel_btn.x - save_btn.textField.width - 20;
			save_btn.y = cancel_btn.y;
			function save_btn_click(m:MouseEvent):void {
				dump_edit_UI();
				save_new_mod_order();
				main.Imree.Exhibit.removeChild(edit_background);
				edit_background = null;
			}
		}
		
		public function make_proxies(wrapper:DisplayObject):Vector.<box> {
			var proxies:Vector.<box> = new Vector.<box>();
			var i:module;
			var originals:Vector.<position_data> = new Vector.<position_data>();
			for each(i in items) {
				originals.push(new position_data(i.width, i.height));
			}
			var lay:layout = new layout();
			var positions:Vector.<position_data> = lay.abstract_box_solver(originals, wrapper.width * .8, wrapper.height * .8, 5, "left");
			for (var k:int = 0; k < items.length; k++ ) {
				var proxy:box = new box(items[k].width, items[k].height);
				var bits:BitmapData = new BitmapData(items[k].width, items[k].height);
				bits.draw(items[k]);
				proxy.addChild(new Bitmap(bits));
				proxy.x = positions[k].x;
				proxy.y = positions[k].y;
				proxy.data = { index:k, mod:items[k] };
				proxies.push(proxy);
			}
			return proxies;
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