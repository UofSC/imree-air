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
		public function connect(_conn:serverConnect, _row_id:int, _table:String, _table_key_column_name:String):void {
			if (_row_id > 0 && _table.length > 0) {
				f_method = "update";
				f_row_id = _row_id;
				f_table = _table;
				t.conn = _conn;
				f_table_key_column_name = _table_key_column_name;
			}
		}
		public function draw():void {
			if (f_method === "update" && f_row_id > 0 && f_table.length > 0) {
				data_get();
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
		
		public function data_get(e:*=null):void {
			var loaders:Vector.<DisplayObject> = new Vector.<DisplayObject>();
			var obj:Object = new Object();
			obj.table = f_table;
			obj.row_id = f_row_id;
			obj.table_key_column_name = f_table_key_column_name;
			obj.columns = new Object();
			for(var i:String in elements) {
				obj.columns[i] = elements[i].data_column_name;
				var loader:loading_spinner_sprite = new loading_spinner_sprite(18);
				loader.x = elements[i].width - 22;
				loader.y = elements[i].y + 2;
				loaders.push(loader);
				t.addChild(loader);
			}
			conn.server_command("query", obj, data_ready, true);
			function data_ready(xml:XML):void {
				for each (loader in loaders) {
					t.removeChild(loader);
					loader = null;
				}
				for each (var row:f_element in elements) {
					row.set_value(xml['result']['item'][row.data_column_name]);
				}
			}
		}
		public function data_put(e:*=null):void {
			
		}
		
		public function submit(e:*=null):void {
			if (onSubmit === null) {
				trace("Form Submitted without onSubmit listener");
				for each(var i:f_element in elements) {
					trace("\t" + i.label + ": " + i.get_value());
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