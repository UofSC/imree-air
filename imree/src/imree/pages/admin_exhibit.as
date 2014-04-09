package imree.pages 
{
	import fl.controls.ComboBox;
	import flash.display.Sprite;
	import flash.events.Event;
	import imree.forms.f_data;
	import imree.forms.f_element;
	import imree.forms.f_element_DynamicOptions;
	import imree.forms.f_element_select;
	import imree.forms.f_element_text;
	import imree.Main;
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
			
			options = new f_element_DynamicOptions(main.connection, 'exhibits', 'exhibit_id', 'exhibit_name');
			
			var exh:Vector.<f_element> = new Vector.<f_element>();
			exh.push(new f_element_text("Name", "exhibit_name"));
			exh.push(new f_element_text("Start Date", "exhibit_date_start"));
			exh.push(new f_element_text("Start End", "exhibit_date_end"));
			var departments:f_element_select = new f_element_select("Deptartment", "exhibit_department_id", null, "Please Select");
			departments.dynamic_options = new f_element_DynamicOptions(main.connection, 'departments', 'department_id', 'department_name');
			exh.push(new f_element_text("Theme", "theme_id"));
			exh.push(departments);
			
			form = new f_data(exh);
			form.edit_siblings_allowed = false;
			form.conn = main.connection;
			form.f_table = "exhibits";
			form.f_table_key_column_name = "exhibit_id";
			form.f_table_label_column_name = "exhibit_name";
			addChild(form);
			
		}
		public function draw(i:int = 0):void {
			form.connect(main.connection, i, 'exhibits', 'exhibit_id');
			form.draw();
		}
		
		
	}

}