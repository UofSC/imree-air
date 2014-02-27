package imree.forms 
{
	/**
	 * ...
	 * @author Jason Steelman
	 */
	import fl.controls.Button;
	import fl.controls.BaseButton;
	import fl.events.ComponentEvent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import imree.data_helpers.data_value_pair;
	import imree.display_helpers.*;
	import imree.images.loading_spinner_sprite;
	import imree.serverConnect;
	import imree.shortcuts.box;
	import com.greensock.events.LoaderEvent;
	
	public class f_data extends Sprite
	{
		public var elements:Vector.<f_element>;
		public var w:int;
		public var h:int;
		public var background_color:uint
		public var base_font_size:int;
		public var use_submit_btn:Boolean;
		public var onSubmit:Function;
		public var onSave:Function;
		public var f_table:String;
		public var f_table_key_column_name:String;
		public var f_row_id:int;
		public var f_method:String;
		public var conn:serverConnect;
		private var t:f_data;
		public function f_data(_elements:Vector.<f_element>) 
		{
			t = this;
			elements = _elements;
			w = 300;
			h = 300;
			background_color =  0xFFFFFF;
			base_font_size = 16;
			use_submit_btn = true;
			f_method = "insert";
			f_row_id = 0;
			f_table = "";
			
		}
		public function layout(_base_font_size:int = 16, _width:int = 300, _height:int = 300):void {
			base_font_size = _base_font_size;
			w = _width;
			h = _height;
		}
		/**
		 * Not really required in order to get, update, or insert... but its a shortcut to add the four required parameters in one line. 
		 */
		public function connect(_conn:serverConnect, _row_id:int, _table:String, _table_key_column_name:String):void {
			if (_table.length > 0) {
				f_method = "update";
				f_row_id = _row_id;
				f_table = _table;
				t.conn = _conn;
				f_table_key_column_name = _table_key_column_name;
			}
			if (_row_id == 0) {
				f_method = "insert";
			}
		}
		public function prepared_for_mysql():Boolean {
			return 	conn.password_is_set() && 
					conn.username != null && 
					conn != null && 
					f_method != null &&
					f_method.length > 0 && 
					f_table != null && 
					f_table.length > 0 && 
					f_table_key_column_name != null && 
					f_table_key_column_name.length > 0;
		}
		public function draw():void {
			trace("method: " + f_method, "row:" + f_row_id, "f_table" + f_table);
			if (f_method === "update" && f_row_id > 0 && f_table.length > 0) {
				data_get_row();
			} else {
				get_dynamic_data_for_all();
			}
			var j:int = 0;
			for each(var i:f_element in t.elements) {
				i.draw();
				i.x = 10;
				i.y = j;
				j += i.get_height() + 10;
				t.addChild(i);
			}
			if (use_submit_btn) {
				var btn:Button = new Button();
				btn.label = "Submit";
				btn.x = 10;
				btn.y = j;
				btn.addEventListener(ComponentEvent.BUTTON_DOWN, submit);
				t.addChild(btn);
			}
			
		}
		
		private var dynamic_data_current_i:int = 0;
		public function get_dynamic_data_for_all(e:*=null):void {
			var dynamic_elements:Vector.<String> = new Vector.<String>();
			for (var i:String in t.elements) {
				if (elements[i].dynamic_options !== null) {
					dynamic_elements.push(i);
				}
			}
			
			if (dynamic_data_current_i < dynamic_elements.length) {
				get_dynamic_data_for_row(dynamic_elements[dynamic_data_current_i]);
			} else {
				dynamic_data_current_i = 0;
			}
		}
		public function get_dynamic_data_for_row(i:String):void {
			t.elements[i].dynamic_options.onUpdate = fetched;
			t.elements[i].dynamic_options.fetch();
			function fetched(e:* = null):void {
				t.elements[i].options = t.elements[i].dynamic_options.data;
				t.elements[i].draw();
				get_dynamic_data_for_all();
				dynamic_data_current_i++;
			}
		}
		
		public function data_get_row(e:*=null):void {
			var obj:Object = new Object();
			obj.table = f_table;
			obj.row_id = f_row_id;
			obj.table_key_column_name = f_table_key_column_name;
			obj.columns = new Object();
			for(var i:String in elements) {
				obj.columns[i] = elements[i].data_column_name;
				elements[i].indicate_waiting();
			}
			conn.server_command("query", obj, data_ready, true);
			function data_ready(evt:LoaderEvent):void {
				var xml:XML = XML(evt.currentTarget.content);
				for each (var row:f_element in elements) {
					row.indicate_ready();
					row.set_value(xml['result']['item'][row.data_column_name]);
				}
				get_dynamic_data_for_all();
			}
		}
		public function data_put(e:*=null):void {
			
		}
		
		public function submit(e:*=null):void {
			if (onSubmit === null ) {
				if (t.prepared_for_mysql()) {
					trace("Sending " + f_method + " request for table " + f_table + " where row_id = " + f_row_id + "...");
					
				} else {
					trace("Form Submitted without onSubmit listener nor MySQL connection information");
					for each(var i:f_element in elements) {
						trace("\t" + i.label + ": " + i.get_value());
					}
				}
			} else {
				var values:Object = new Object();
				for each (var j:f_element in elements) {
					values[j.data_column_name] = j.get_value();
				}
				onSubmit(values);
			}
		}
		
		
	}

}