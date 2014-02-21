package imree.forms 
{
	import flash.display.Sprite;
	import imree.data_helpers.data_value_pair;
	import imree.serverConnect;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class exhibit_properties extends Sprite
	{
		private var conn:serverConnect;
		public function exhibit_properties(_conn:serverConnect) 
		{
			conn = _conn.clone();
			/**
			var options:Vector.<data_value_pair> = new Vector.<data_value_pair>();
				options.push(new data_value_pair("Systems", 2));
				options.push(new data_value_pair("RBSC", 1));
				options.push(new data_value_pair("SCPC", 3));
			*/
			
			var options:f_element_DynamicOptions = new f_element_DynamicOptions(conn, 'exhibits', 'exhibit_id', 'exhibit_name');
			
			var exh:Vector.<f_element> = new Vector.<f_element>();
			exh.push(new f_element_text("Name", "exhibit_name"));
			exh.push(new f_element_text("Start Date", "exhibit_date_start"));
			exh.push(new f_element_text("Start End", "exhibit_date_end"));
			exh.push(new f_element_select("Deptartment", "exhibit_department_id",options, "Please Select"));
			var form:f_data = new f_data(exh);
			form.connect(conn, 1, 'exhibits', 'exhibit_id');
			form.draw();
			
			addChild(form);
		}
		
	}

}