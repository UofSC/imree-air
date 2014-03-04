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
	public class admin_exhibits extends Sprite
	{
		
		public var w:Number;
		public var h:Number;
		public var main:Main;
		public var form:f_data;
		public var exhibit_select:f_data;
		public function admin_exhibits(_w:int, _h:int, _main:Main)  {
			w = _w;
			h = _h;
			main = _main;
			var exhibit_select_elements:Vector.<f_element> = new Vector.<f_element>();
			var exhibit_select_options:f_element_DynamicOptions = new f_element_DynamicOptions(main.connection, 'exhibits', 'exhibit_id', 'exhibit_name');
			var exhibit_select_elements_item:f_element_select = new f_element_select('Exhibit', 'exhibit_name',null,"Please Select");
				exhibit_select_elements_item.dynamic_options = exhibit_select_options;
				exhibit_select_elements_item.onChange = request_changed_exhibit;
			exhibit_select = new f_data(exhibit_select_elements);
			function request_changed_exhibit(e:Event):void {
				draw(ComboBox(exhibit_select_elements_item.component).selectedItem.data);
			}
			addChild(exhibit_select);
			exhibit_select.draw();
			exhibit_select.visible = false;
			var options:f_element_DynamicOptions = new f_element_DynamicOptions(main.connection, 'exhibits', 'exhibit_id', 'exhibit_name');
			
			var exh:Vector.<f_element> = new Vector.<f_element>();
			exh.push(new f_element_text("Name", "exhibit_name"));
			exh.push(new f_element_text("Start Date", "exhibit_date_start"));
			exh.push(new f_element_text("Start End", "exhibit_date_end"));
			var departments:f_element_select = new f_element_select("Deptartment", "exhibit_department_id", null, "Please Select");
			departments.dynamic_options = new f_element_DynamicOptions(main.connection, 'departments', 'department_id', 'department_name');
			exh.push(new f_element_text("Theme", "theme_id"));
			exh.push(departments);
			
			form = new f_data(exh);
			addChild(form);
			
		}
		public function draw(i:int = 0):void {
			exhibit_select.visible = true;
			form.connect(main.connection, i, 'exhibits', 'exhibit_id');
			form.draw();
		}
		
		
	}

}