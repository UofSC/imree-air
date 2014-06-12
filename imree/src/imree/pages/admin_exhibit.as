package imree.pages 
{
	//import com.demonsters.debugger.MonsterDebugger;
	import fl.controls.Button;
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import imree.data_helpers.data_value_pair;
	import imree.data_helpers.position_data;
	import imree.data_helpers.Theme;
	import imree.display_helpers.device;
	import imree.display_helpers.modal;
	import imree.display_helpers.search;
	import imree.display_helpers.smart_button;
	import imree.forms.f_data;
	import imree.forms.f_element;
	import imree.forms.f_element_DynamicOptions;
	import imree.forms.f_element_select;
	import imree.forms.f_element_text;
	import imree.IMREE;
	import imree.layout;
	import imree.Main;
	import imree.modules.module;
	import imree.modules.module_asset;
	import imree.modules.module_asset_image;
	import imree.modules.module_next;
	import imree.shortcuts.box;
	import imree.text;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class admin_exhibit extends Sprite
	{
		
		public var w:Number;
		public var h:Number;
		public var main:Main;
		public var form:f_data;
		private var options:f_element_DynamicOptions;
		public function admin_exhibit(_w:int, _h:int, _main:Main)  {
			w = _w;
			h = _h;
			main = _main;
			
			
			
			
		}
		public function draw(i:int = 0):void {
			standard_edit_UI();
		}
		
		public function standard_edit_UI(e:* = null, animate:Boolean = true):void {
			var target_exhibit:exhibit_display = exhibit_display(main.Imree.current_page);
			var buttons:Vector.<smart_button> = new Vector.<smart_button>();
			var cancel_btn:Button = new Button(); 
			cancel_btn.setSize(85, 40);
			cancel_btn.label = "Close"; 
			function cancel_btn_click(m:MouseEvent=null):void {
				dump_edit_UI();
			}
			var save_btn:Button = new Button();
			save_btn.setSize(85, 40);
			save_btn.textField.multiline = true;
			save_btn.label = "Save \nNew Order";
			function save_btn_click(m:MouseEvent=null):void {
				dump_edit_UI();
				save_new_mod_order();
			}
			
			buttons.push(new smart_button(cancel_btn, cancel_btn_click), new smart_button(save_btn, save_btn_click));
			
			options = new f_element_DynamicOptions(main.connection, 'exhibits', 'exhibit_id', 'exhibit_name');
			var exh:Vector.<f_element> = new Vector.<f_element>();
			exh.push(new f_element_text("Name", "exhibit_name"));
			exh.push(new f_element_text("Start Date", "exhibit_date_start"));
			exh.push(new f_element_text("Start End", "exhibit_date_end"));
			var departments:f_element_select = new f_element_select("Department", "exhibit_department_id", null, "Please Select");
			departments.dynamic_options = new f_element_DynamicOptions(main.connection, 'departments', 'department_id', 'department_name');
			exh.push(new f_element_text("Theme", "theme_id"));
			exh.push(departments);
			
			form = new f_data(exh);
			form.edit_siblings_allowed = false;
			form.conn = main.connection;
			form.f_table = "exhibits";
			form.f_table_key_column_name = "exhibit_id";
			form.f_table_label_column_name = "exhibit_name";
			form.f_row_id = target_exhibit.id;
			form.f_method = "update";
			form.data_get_row();
			form.draw();
			
			var selector:ComboBox = new ComboBox();
			selector.prompt = "Add new module";
			selector.setSize (150, 20);
			var selector_label:text  = new text("Add a\nnew Module", 215, Theme.font_style_h2);
			//var datas:Array = [{label:"Title", data:"title"}, {label:"Linear/Narrative",data:"narrative"}, {label:"Grid/Gallery",data:"grid"}];
			var datas:Array = [{label:"Linear/Narrative",data:"narrative"}];
			selector.dataProvider = new DataProvider(datas);
			selector.addEventListener(Event.CHANGE, add_module_by_name);
			selector.x = form.height;
			function add_module_by_name(s:Event):void {
				var obj:Object = {
					'module_order':'9999',
					'module_name':'new module',
					'module_parent_id':'0',
					'module_type':String(selector.selectedItem.data),
					'exhibit_id':String(target_exhibit.id)
				};
				trace(obj);
				main.connection.server_command("new_module", obj, add_module_by_name_done, true);
			}
			function add_module_by_name_done(s:Event):void {
				main.Imree.load_exhibit(exhibit_display(main.Imree.current_page).id);
			}
			
			var proxies_wrapper:Sprite  = new Sprite();
			var proxies:Vector.<DisplayObjectContainer> = make_proxies(main.Imree.staging_area.width, main.Imree.staging_area.height);
			for (var i:int = 0; i < proxies.length; i++ ) {
				proxies[i].addEventListener(MouseEvent.MOUSE_DOWN, proxy_mouseDown);
				proxies_wrapper.addChild(proxies[i]);
			}
			
			var edit_ui:Sprite = new Sprite();
			edit_ui.addChild(form);
			edit_ui.addChild(selector);
			edit_ui.addChild(selector_label);
			edit_ui.addChild(proxies_wrapper);
			selector.x = form.width + 50;
			selector.y = selector_label.height + 5;
			selector_label.x = form.width + 50;
			proxies_wrapper.x = form.width + selector.width + 150;
			
			var dialog:modal = new modal(main.Imree.staging_area.width, main.Imree.staging_area.height, buttons, edit_ui, null, 0x6a6a6a, .9, "left");
			main.Imree.Exhibit.overlay_add(dialog);
			
			
			var current_proxy_focus:Sprite;
			var proxy_cursor:box;
			var trash:icon_trashcan = new icon_trashcan();
			trash.x = main.Imree.staging_area.width - trash.width;
			trash.y = main.Imree.staging_area.height - trash.height;
			dialog.addChild(trash);
			trash.visible = false;
			function proxy_mouseDown(evt:MouseEvent):void {
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
				function proxy_mouseUp(stage_event:MouseEvent):void {
					trash.visible = false;
					main.stage.removeEventListener(MouseEvent.MOUSE_MOVE, proxy_mouseMove);
					main.stage.removeEventListener(MouseEvent.MOUSE_UP, proxy_mouseUp);
					dialog.removeChild(proxy_cursor);
					proxy_cursor = null;
					var target:box = test_proxies_for_mouse_position();
					if (target !== null) {
						change_mod_order(box(current_proxy_focus).data.mod, target.data.index);
						dump_edit_UI();
						standard_edit_UI();
					} 
					if (trash.hitTestPoint(main.stage.mouseX, main.stage.mouseY)) {
						var tar:box = box(current_proxy_focus);
						if (tar.data.mod is module_asset) {
							pending_save++;
							
							var data:Object = { "module_asset_id" : module_asset(tar.data.mod).module_asset_id };
							main.connection.server_command("remove_module", data, reload, true);
						} else {
							pending_save++;
							var dat:Object = { "module_id" : module(tar.data.mod).module_id};
							main.connection.server_command("remove_module", dat, reload, true);
						}
						target_exhibit.modules.splice(target_exhibit.modules.indexOf(box(current_proxy_focus)), 1);
						dump_edit_UI();
						standard_edit_UI();
					}
				}
				function proxy_mouseMove(stage_event:MouseEvent):void {
					var match:box = test_proxies_for_mouse_position();
					proxy_cursor.x = main.stage.mouseX;
					proxy_cursor.y = main.stage.mouseY;
				}
			}
			function dump_edit_UI():void {
				for each(var poo:box in proxies) {
					poo.removeEventListener(MouseEvent.MOUSE_DOWN, proxy_mouseDown);
					poo.parent.removeChild(poo);
					poo = null;
				}
				target_exhibit.overlay_remove();
			}
			
			function test_proxies_for_mouse_position():box {
				var hero:box;
				for each(var p:box in proxies) {
					if (p != current_proxy_focus) { 
						if (p.hitTestPoint(main.stage.mouseX, main.stage.mouseY)) { 
							Sprite(p).transform.colorTransform = new ColorTransform(0, 0, 0);
							hero = p;
						} else {
							Sprite(p).transform.colorTransform = new ColorTransform();
						}
					}
				}
				return hero;
			}
			
		}
		
		
		public function reload(e:*=null):void {
			main.log("Save Pending: " + String(pending_save));
			pending_save--;
			if (pending_save === 0) {
				main.Imree.load_exhibit(exhibit_display(main.Imree.current_page).id);
			}
		}
		
		private var pending_save:int = 0;
		public function save_new_mod_order():void {
			var target:exhibit_display = exhibit_display(main.Imree.current_page);
			
			for each(var m:module in target.modules) {
				if (m is module_asset) {
					pending_save++;
					var data:Object = { 
						'module_asset_id':String(module_asset(m).module_asset_id),
						'module_asset_order':String(target.modules.indexOf(m)) 
					}; 
					main.connection.server_command("change_module_asset_order", data, reload, true);
				} else {
					pending_save++;
					var data2:Object = { 
						'module_id':String(module(m).module_id),
						'module_order':String(target.modules.indexOf(m)) 
					}; 
					main.connection.server_command("change_module_order", data2, reload, true);
					
				}
			}
		}
		
		public function change_mod_order(mod:module, new_index:int):void {
			var target:exhibit_display = exhibit_display(main.Imree.current_page);
			target.modules.splice(target.modules.indexOf(mod), 1);
			target.modules.splice(new_index, 0, mod);
		}
		
		public function make_proxies(_w:int, _h:int):Vector.<DisplayObjectContainer> {
			var proxies:Vector.<DisplayObjectContainer> = new Vector.<DisplayObjectContainer>();
			var originals:Vector.<position_data> = new Vector.<position_data>();
			var target:exhibit_display = exhibit_display(main.Imree.current_page);
			
			for each(var i:module in target.modules) {
				var bk:box;
				if ( i is module_next) {
					//ignore for now
				} else {
					if ( i is module_asset_image ) {
						bk = new box(i.width, i.height);
						var bits:BitmapData = new BitmapData(i.width, i.height);
						bits.draw(i);
						bk.addChild(new Bitmap(bits));
						proxies.push(bk);
						bk.mouseChildren = false;
						originals.push(new position_data(i.width, i.height));
					} else {
						bk = new box(main.Imree.Device.box_size, main.Imree.Device.box_size);
						bk.addChild(i.draw_thumb(main.Imree.Device.box_size, main.Imree.Device.box_size, true));
						proxies.push(bk);
						bk.mouseChildren = false;
						originals.push(new position_data(main.Imree.Device.box_size,main.Imree.Device.box_size));
					}
					bk.addChild(new box(bk.width, bk.height, Theme.background_color_secondary, .7));
					bk.addChild(new text(i.module_name, bk.width, Theme.font_style_description));
				}
			}
			
			var dir:String;
			if (main.Imree.Device.orientation === "portrait") {
				dir = "top";
			} else {
				dir = "left";
			}
			var lay:layout = new layout();
			var positions:Vector.<position_data> = lay.abstract_box_solver(originals, _w -80, _h -80, 5, dir);
			for (var k:int = 0; k < originals.length; k++ ) {
				proxies[k].x = positions[k].x;
				proxies[k].y = positions[k].y;
				box(proxies[k]).data = { index:k, mod:target.modules[k] };
			}
			return proxies;
		}
		
		
	}

}