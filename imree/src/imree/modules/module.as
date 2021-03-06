package imree.modules
{
	//import com.demonsters.debugger.MonsterDebugger;
	import com.greensock.easing.Cubic;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.XMLLoader;
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import fl.controls.Button;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import imree.forms.f_element_date;
	import imree.Main;
	import imree.pages.exhibit_display;
	import imree.shortcuts.box;
	import com.greensock.data.TweenLiteVars;
	import com.greensock.loading.ImageLoader;
	import fl.containers.ScrollPane;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import imree.data_helpers.data_value_pair;
	import imree.data_helpers.permission;
	import imree.data_helpers.position_data;
	import imree.display_helpers.modal;
	import imree.display_helpers.search;
	import imree.display_helpers.smart_button;
	import imree.images.loading_spinner_sprite;
	import imree.forms.f_data;
	import imree.forms.f_element;
	import imree.forms.f_element_select;
	import imree.forms.f_element_text;
	import imree.layout;
	import imree.shortcuts.box;
	
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class module extends Sprite
	{
		public var items:Vector.<module>;
		public var module_id:String;
		public var module_name:String;
		public var module_sub_name:String;
		public var module_type:String;
		public var module_order:int;
		public var original_order:int;
		public var main:Main;
		public var parent_module:module;
		public var Exhibit:exhibit_display;
		public var thumb_wrapper:Sprite;
		public var thumb_display_columns:int;
		public var thumb_display_rows:int;
		public var module_is_visible:Boolean;
		public var module_display_name:Boolean;
		public var module_display_child_names:Boolean;
		public var onSelect:Function;
		public var draw_feature_on_object:DisplayObjectContainer;
		public var t:module;
		public var user_can_use:Boolean;
		public var user_can_edit:Boolean;
		public var user_can_admin:Boolean;
		public var onUserPermissionsUpdated:Function;
		public var module_supports_reordering:Boolean = false;
		public var edit_button:Sprite;
		public var edit_background:Sprite;
		public var edit_wrapper:Sprite;
		public var phase_feature:Boolean;
		
		public function module(_main:Main, _Exhibit:exhibit_display, _items:Vector.<module> = null)
		{
			items = _items;
			main = _main;
			Exhibit = _Exhibit;
			phase_feature = false;
			module_is_visible = true;
			addEventListener(Event.REMOVED_FROM_STAGE, dump);
		
		}
		
		public function draw_thumb(_w:int = 200, _h:int = 200, Return:Boolean = false):*
		{
			return null;
		}
		
		public function drop_thumb():void
		{
			if (thumb_wrapper !== null)
			{
				if (t.contains(thumb_wrapper))
				{
					t.removeChild(thumb_wrapper);
				}
				thumb_wrapper = null;
			}
		}
		
		public function draw_feature(_w:int, _h:int):void
		{
			phase_feature = true;
			for each (var i:module in items)
			{
				i.draw_thumb();
			}
		}
		
		public function slide_out():void
		{
			if (module_is_visible)
			{
				module_is_visible = false;
				phase_feature = false;
				if (main.Imree.Device.orientation == 'portrait')
				{
					y += main.Imree.Device.box_size * 2;
				}
				else
				{
					x += main.Imree.Device.box_size * 2;
				}
			}
		}
		
		public function slide_in():void
		{
			if (!module_is_visible)
			{
				module_is_visible = true;
				if (main.Imree.Device.orientation == 'portrait')
				{
					TweenLite.to(this, .5, {y: this.y - main.Imree.Device.box_size * 2, ease: Cubic.easeOut});
				}
				else
				{
					TweenLite.to(this, .5, {x: x - main.Imree.Device.box_size * 2, ease: Cubic.easeOut});
				}
			}
		}
		
		public function trace_heirarchy(mod:module, tab:int = 0):String
		{
			
			var tabs:Array = ["", "\t", "\t\t", "\t\t\t", "\t\t\t\t", "\t\t\t\t\t", "\t\t\t\t\t\t", "\t\t\t\t\t\t\t", "\t\t\t\t\t\t\t\t", "\t\t\t\t\t\t\t\t\t", "\t\t\t\t\t\t\t\t\t\t", "\t\t\t\t\t\t\t\t\t\t\t", "\t\t\t\t\t\t\t\t\t\t\t\t", "\t\t\t\t\t\t\t\t\t\t\t\t"];
			var str:String = "";
			for each (var i:module in mod.items)
			{
				if (i.items !== null && i.items.length > 0)
				{
					str += "\n" + tabs[tab] + i.module_name + " [" + i.module_type + "]" + " { " + trace_heirarchy(i, tab + 1) + " \n" + tabs[tab] + "}";
				}
				else
				{
					str += "\n" + tabs[tab] + i.module_name + " [" + i.module_type + "]";
				}
				if (i is module_asset)
				{
					for each (var asset:module_asset in module_asset(i).asset_relations)
					{
						str += " [Relates to: " + asset.module_type + " " + asset.module_asset_id + " as " + asset.asset_relates_to_node_as + "]";
					}
				}
			}
			return str;
		}
		
		public function dump(e:* = null):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, dump);
			for each (var i:module in items)
			{
				i.dump();
				i = null;
			}
			while (numChildren)
			{
				if (getChildAt(0) is DisplayObjectContainer)
				{
					//dump_recursive(DisplayObjectContainer(getChildAt(0)));
				}
				removeChildAt(0);
			}
			if (t !== null && t.parent !== null)
			{
				t.parent.removeChild(t);
			}
			items = null;
		}
		
		public function dump_recursive(obj:DisplayObjectContainer):void
		{
			while (obj.numChildren)
			{
				if (obj.getChildAt(0) is DisplayObjectContainer)
				{
					dump_recursive(DisplayObjectContainer(obj.getChildAt(0)));
				}
				obj.removeChildAt(0);
			}
		}
		
		public function hide(e:* = null):void
		{
			this.visible = false;
		}
		
		public function show(e:* = null):void
		{
			this.visible = true;
		}
		
		public function draw_edit_button():void
		{
			if (phase_feature)
			{
				if (edit_button === null)
				{
					edit_button = new Sprite();
					var butt:button_edit_module = new button_edit_module();
					main.Imree.UI_size(butt);
					edit_button.addChild(butt);
				}
				if (!contains(edit_button))
				{
					addChild(edit_button);
				}
				if (!edit_button.hasEventListener(MouseEvent.CLICK))
				{
					edit_button.addEventListener(MouseEvent.CLICK, draw_edit_UI);
				}
			}
		}
		
		public function draw_edit_UI(e:* = null, animate:Boolean = true, start_at_position:int = 0):void
		{
			main.toast("This module has no edit UI");
		}
		
		public function focus_on_sub_module(mod:module, focused:Function = null):void
		{
			//by default, this is already centered and ready, should be overriden for grids and narratives
			if (focused !== null)
			{
				focused();
			}
		}
		
		public function update_user_privileges(user:Boolean = true, edit:Boolean = false, admin:Boolean = false):void
		{
			if (String(user) + String(edit) + String(admin) !== String(user_can_use) + String(user_can_edit) + String(user_can_admin))
			{
				user_can_use = user;
				user_can_edit = edit;
				user_can_admin = admin;
				for each (var i:module in items)
				{
					i.update_user_privileges(user, edit, admin);
				}
				if (onUserPermissionsUpdated !== null)
				{
					onUserPermissionsUpdated();
				}
				if (user_can_edit)
				{
					draw_edit_button();
					if (main.Imree.current_page is exhibit_display && t === exhibit_display(main.Imree.current_page).current_module())
					{
						main.Imree.Menu.update();
						
					}
				}
			}
		}
		
		private var pending_save:int = 0;
		
		public function save_new_mod_order():void
		{
			pending_save = 0;
			main.loading_indicator_add();
			for each (var m:module in items)
				if (m.original_order != items.indexOf(m))
				{
					if (m is module_asset && module_asset(m).module_asset_id !== null)
					{
						pending_save++;
						var data:Object = {'module_asset_id': String(module_asset(m).module_asset_id), 'module_asset_order': String(items.indexOf(m))};
						main.connection.server_command("change_module_asset_order", data, reload, true);
					}
					else if (module(m).module_id !== null)
					{
						pending_save++;
						var data2:Object = {'module_id': String(module(m).module_id), 'module_order': String(items.indexOf(m))};
						main.connection.server_command("change_module_order", data2, reload, true);
					}
				}
		
		}
	
	public function reload(e:* = null):void
	{
		pending_save--;
		main.log("Save Pending: " + String(pending_save));
		if (pending_save <= 1)
		{
			
			main.loading_indicator_remove();
			
			Exhibit.reload_current_page();
		}
	}
	
	public function change_mod_order(mod:module, new_index:int):void
	{
		items.splice(items.indexOf(mod), 1);
		items.splice(new_index, 0, mod);
	}
	
	override public function toString():String
	{
		return module_name + " " + module_type;
	}
	
	public function standard_edit_UI(e:* = null, animate:Boolean = true, start_at_position:int = 0):void
	{
		var buttons:Vector.<smart_button> = new Vector.<smart_button>();
		var cancel_btn:Button = new Button();
		cancel_btn.setSize(85, 40);
		cancel_btn.label = "Close";
		function cancel_btn_click(m:MouseEvent = null):void
		{
			dump_edit_UI();
		}
		var save_btn:Button = new Button();
		save_btn.setSize(85, 40);
		save_btn.textField.multiline = true;
		save_btn.label = "Save \nNew Order";
		function save_btn_click(m:MouseEvent = null):void
		{
			dump_edit_UI();
			save_new_mod_order();
		}
		var add_butt:Button = new Button();
		add_butt.setSize(85, 40);
		add_butt.label = "Add Material";
		buttons.push(new smart_button(cancel_btn, cancel_btn_click), new smart_button(save_btn, save_btn_click), new smart_button(add_butt, draw_search));
		
		var truefalse:Vector.<data_value_pair> = new Vector.<data_value_pair>();
		truefalse.push(new data_value_pair('Yes', '1'));
		truefalse.push(new data_value_pair("No", '0'));
		var elements:Vector.<f_element> = new Vector.<f_element>();
		elements.push(new f_element_text('Name', 'module_name'));
		elements.push(new f_element_select('Show Name', 'module_display_name', truefalse));
		
		//Timeline module is not ready yet
		//elements.push(new f_element_date("Date Start", "module_display_date_start"));
		//elements.push(new f_element_date("Date End", "module_display_date_end"));
		
		var form:f_data = new f_data(elements);
		form.connect(main.connection, int(module_id), 'modules', 'module_id');
		form.get_dynamic_data_for_all();
		form.draw();
		
		var form_wrapper:box = new box(form.width + main.Imree.Device.box_size / 2, form.height + main.Imree.Device.box_size / 2);
		form_wrapper.addChild(form);
		form.x = main.Imree.Device.box_size / 5;
		form.y = main.Imree.Device.box_size / 4;
		
		var proxies:Vector.<DisplayObjectContainer> = make_proxies(main.Imree.staging_area.width, main.Imree.staging_area.height);
		for (var i:int = 0; i < proxies.length; i++)
		{
			proxies[i].addEventListener(MouseEvent.MOUSE_DOWN, proxy_mouseDown);
		}
		
		var dialog:modal = new modal(main.Imree.staging_area.width, main.Imree.staging_area.height, buttons, form_wrapper, proxies, 0x6A6A6A, .97, "left");
		main.Imree.Exhibit.overlay_add(dialog);
		
		var location_mark_ui:Button = new Button();
		location_mark_ui.setSize(100, 40);
		location_mark_ui.label = "Mark Location";
		var location_mark:smart_button = new smart_button(location_mark_ui, location_mark_click);
		var location_unmark_ui:Button = new Button();
		location_unmark_ui.setSize(100, 40);
		location_unmark_ui.label = "Unmark Location";
		var location_unmark:smart_button = new smart_button(location_unmark_ui, location_unmark_click);
		main.connection.server_command("module_location_id", module_id, location_response);
		function location_response(L:LoaderEvent):void
		{
			if (XML(XMLLoader(L.target).content).result == '0')
			{
				dialog.add_button(location_mark);
			}
			else
			{
				dialog.add_button(location_unmark);
			}
		}
		function location_mark_click(L:* = null):void
		{
			main.connection.server_command("device_mark_location", {'module_id': module_id, 'location_name': module_name}, location_mark_response, true);
			dialog.remove_button(location_mark);
		}
		function location_mark_response(L:LoaderEvent):void
		{
			if (XML(XMLLoader(L.target).content).success == 'true')
			{
				main.Logger.add("Loaded Location");
			}
			else
			{
				main.Logger.add("Request to add location failed: " + XML(XMLLoader(L.target).content).error);
			}
			dialog.add_button(location_unmark);
		}
		function location_unmark_click(L:* = null):void
		{
			main.connection.server_command("device_unmark_location", {'module_id': module_id}, device_unmark_location, true);
			dialog.remove_button(location_unmark);
		}
		function device_unmark_location(L:LoaderEvent):void
		{
			dialog.add_button(location_mark);
		}
		
		var current_proxy_focus:Sprite;
		var proxy_cursor:box;
		var trash:icon_trashcan = new icon_trashcan();
		trash.x = main.Imree.staging_area.width - trash.width;
		trash.y = main.Imree.staging_area.height - trash.height;
		dialog.addChild(trash);
		trash.visible = false;
		function proxy_mouseDown(evt:MouseEvent):void
		{
			trash.visible = true;
			current_proxy_focus = Sprite(evt.currentTarget);
			proxy_cursor = new box(100, 100);
			var bits:BitmapData = new BitmapData(100, 100);
			bits.draw(current_proxy_focus);
			proxy_cursor.addChild(new Bitmap(bits));
			dialog.addChild(proxy_cursor);
			proxy_cursor.x = main.stage.mouseX;
			proxy_cursor.y = main.stage.mouseY;
			main.stage.addEventListener(MouseEvent.MOUSE_MOVE, proxy_mouseMove);
			main.stage.addEventListener(MouseEvent.MOUSE_UP, proxy_mouseUp);
			function proxy_mouseUp(stage_event:MouseEvent):void
			{
				trash.visible = false;
				main.stage.removeEventListener(MouseEvent.MOUSE_MOVE, proxy_mouseMove);
				main.stage.removeEventListener(MouseEvent.MOUSE_UP, proxy_mouseUp);
				dialog.removeChild(proxy_cursor);
				proxy_cursor = null;
				var target:box = test_proxies_for_mouse_position();
				if (target !== null)
				{
					var start_at_position_target:int = dialog.get_scoll_point().x;
					change_mod_order(box(current_proxy_focus).data.mod, target.data.index);
					dump_edit_UI();
					draw_edit_UI(null, false, start_at_position_target);
				}
				if (trash.hitTestPoint(main.stage.mouseX, main.stage.mouseY))
				{
					var tar:box = box(current_proxy_focus);
					var data:Object;
					if (tar.data.mod is module_asset)
					{
						data = {"module_asset_id": module_asset(tar.data.mod).module_asset_id};
					}
					else
					{
						data = {"module_id": module(tar.data.mod).module_id};
					}
					main.connection.server_command("remove_module", data, null, true);
					items.splice(items.indexOf(module(tar.data.mod)), 1);
					var start_at_position_target2:int = dialog.get_scoll_point().x;
					dump_edit_UI();
					draw_edit_UI(e, animate, start_at_position_target2);
				}
			}
			function proxy_mouseMove(stage_event:MouseEvent):void
			{
				var match:box = test_proxies_for_mouse_position();
				proxy_cursor.x = main.stage.mouseX;
				proxy_cursor.y = main.stage.mouseY;
			}
		}
		function dump_edit_UI():void
		{
			for each (var poo:box in proxies)
			{
				poo.removeEventListener(MouseEvent.MOUSE_DOWN, proxy_mouseDown);
				poo.parent.removeChild(poo);
				poo = null;
			}
			Exhibit.overlay_remove();
		}
		
		function test_proxies_for_mouse_position():box
		{
			var hero:box;
			for each (var p:box in proxies)
			{
				if (p != current_proxy_focus)
				{
					if (p.hitTestPoint(stage.mouseX, stage.mouseY))
					{
						Sprite(p).transform.colorTransform = new ColorTransform(0, 0, 0);
						hero = p;
					}
					else
					{
						Sprite(p).transform.colorTransform = new ColorTransform();
					}
				}
			}
			return hero;
		}
		
		if (start_at_position > 0)
		{
			dialog.scroll_to(start_at_position, 0);
		}
	
	}
	
	public function draw_search(e:* = null):void
	{
		var Search:search = new search(new_assets_ingested, main, this, destroy_search, main.Imree.staging_area.width, main.Imree.staging_area.height);
		Search.allow_modules = true;
		var search_wrapper:Sprite = new Sprite();
		Exhibit.overlay_add(search_wrapper);
		search_wrapper.addChild(new box(main.Imree.staging_area.width, main.Imree.staging_area.height, 0xFFFFFF, 1));
		Search.draw_search_box();
		search_wrapper.addChild(Search);
		function destroy_search(e:* = null):void
		{
			search_wrapper.removeChild(Search);
			Exhibit.overlay_remove();
			Search = null;
			search_wrapper = null;
		}
		function new_assets_ingested(ingests:Array, fails:int):void
		{
			trace(ingests + " :: Fails: " + fails);
			if (ingests.length > 0)
			{
				Exhibit.reload_current_page();
			}
		}
	}
	
	public function make_proxies(_w:int, _h:int):Vector.<DisplayObjectContainer>
	{
		var proxies:Vector.<DisplayObjectContainer> = new Vector.<DisplayObjectContainer>();
		var originals:Vector.<position_data> = new Vector.<position_data>();
		for each (var i:module in items)
		{
			
			var bk:box;
			if (i is module_next)
			{
				//ignore
			}
			else if (i is module_asset_image)
			{
				if (i.width + i.height < 1)
				{
					main.toast("The page editor will look weird because all the pages haven't loaded yet");
					bk = new box(main.Imree.Device.box_size, main.Imree.Device.box_size);
				}
				else
				{
					bk = new box(main.Imree.Device.box_size, main.Imree.Device.box_size);
					var bits:BitmapData = new BitmapData(main.Imree.Device.box_size, main.Imree.Device.box_size, true, 0);
					bits.draw(i);
					bk.addChild(new Bitmap(bits));
				}
				proxies.push(bk);
				originals.push(new position_data(main.Imree.Device.box_size, main.Imree.Device.box_size));
			}
			else
			{
				bk = new box(main.Imree.Device.box_size, main.Imree.Device.box_size);
				var bk_content:DisplayObject = i.draw_thumb(main.Imree.Device.box_size, main.Imree.Device.box_size, true)
				if(bk_content !== null) {
					bk.addChild(bk_content);
				}
				proxies.push(bk);
				originals.push(new position_data(main.Imree.Device.box_size, main.Imree.Device.box_size));
			}
		}
	
		var dir:String;
		if (main.Imree.Device.orientation === "portrait")
		{
			dir = "top";
		}
		else
		{
			dir = "left";
		}
		var lay:layout = new layout();
		var positions:Vector.<position_data> = lay.abstract_box_solver(originals, _w - 80, _h - 50, 5, dir);
		for (var k:int = 0; k < originals.length; k++)
		{
			proxies[k].x = positions[k].x;
			proxies[k].y = positions[k].y;
			box(proxies[k]).data = {index: k, mod: items[k]};
		}
		return proxies;
	}
}
}
