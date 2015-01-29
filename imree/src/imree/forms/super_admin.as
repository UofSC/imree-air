package imree.forms 
{
	import com.greensock.events.LoaderEvent;
	import fl.containers.BaseScrollPane;
	import flash.display.Sprite;
	import imree.data_helpers.data_value_pair;
	import imree.Main;
	import imree.serverConnect;
	import imree.text;
	import imree.textFont;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class super_admin extends Sprite
	{
		private var w:int;
		private var h:int;
		private var main:Main;
		public var form:f_data;
		private var options:f_element_DynamicOptions;
		public function super_admin(_w:int, _h:int, _main:Main) 
		{
			w = _w;
			h = _h;
			main = _main;
			var textf:textFont = new textFont( '_sans', 24);
			
			options = new f_element_DynamicOptions(main.connection, 'exhibits', 'exhibit_id', 'exhibit_name');
			
			//prepare list of valid themes
			var theop:Vector.<data_value_pair> = new Vector.<data_value_pair>();
			theop.push(new data_value_pair("Theme 1", 1));
			theop.push(new data_value_pair("Theme 2", 2));
			theop.push(new data_value_pair("Theme 3", 3));
			theop.push(new data_value_pair("Theme 4", 4));
			
			var exh:Vector.<f_element> = new Vector.<f_element>();
			exh.push(new f_element_text("Name", "exhibit_name"));
			exh.push(new f_element_text("Start Date", "exhibit_date_start"));
			exh.push(new f_element_text("Start End", "exhibit_date_end"));
			var departments:f_element_select = new f_element_select("Department", "exhibit_department_id", null, "Please Select");
			departments.dynamic_options = new f_element_DynamicOptions(main.connection, 'departments', 'department_id', 'department_name');
			exh.push(new f_element_select("Theme", "theme_id", theop, "Please Select"));
			exh.push(departments);
			
			form = new f_data(exh);
			form.edit_siblings_allowed = true;
			form.conn = main.connection;
			form.f_table = "exhibits";
			form.f_table_key_column_name = "exhibit_id";
			form.f_table_label_column_name = "exhibit_name";
			form.draw();
			addChild(form);
			var form_label:text = new text("Exhibits", 400, textf);
			addChild(form_label);
			
			
			
			
			var new_user_elements:Vector.<f_element> = new Vector.<f_element>();
			new_user_elements.push(new f_element_text("First Name", "person_name_first"));
			new_user_elements.push(new f_element_text("Last Name", "person_name_last"));
			new_user_elements.push(new f_element_text("Title", "person_title"));
			var new_person_group:f_element_select = new f_element_select("Group", "primary_group",null,'Add to group');
			new_person_group.dynamic_options = new f_element_DynamicOptions(main.connection, 'people_group', 'people_group_id', 'people_group_name');
			new_user_elements.push(new_person_group);
			new_user_elements.push(new f_element_text("Username", "new_username"));
			new_user_elements.push(new f_element_password("Password", "new_password", ""));
			
			var new_user_form:f_data = new f_data(new_user_elements);
			new_user_form.onSubmit = new_user_form_submited;
			new_user_form.draw();
			addChild(new_user_form);
			var new_user_form_label:text = new text("Create User", 400, textf);
			addChild(new_user_form_label);
			
			function new_user_form_submited(obj:Object):void {
				main.connection.server_command("add_user", obj, new_user_form_response, true);
			}
			function new_user_form_response(data:LoaderEvent):void {
				main.toast("User Created");
			}
			
			
			var edit_user_elements:Vector.<f_element> = new Vector.<f_element>();
			edit_user_elements.push(new f_element_text("First Name", "person_name_first"));
			edit_user_elements.push(new f_element_text("Last Name", "person_name_last"));
			edit_user_elements.push(new f_element_text("Title", "person_title"));
			edit_user_elements.push(new f_element_hidden('poop', 'person_id'));
			var primary_group:f_element_select = new f_element_select("Add to Group", "primary_group", null, 'Add to group');
			primary_group.dynamic_options = new f_element_DynamicOptions(main.connection, 'people_group', 'people_group_id', 'people_group_name');
			edit_user_elements.push(primary_group);
			
			var edit_user_form:f_data = new f_data(edit_user_elements);
			edit_user_form.onSubmit = edit_user_form_submited;
			edit_user_form.edit_siblings_allowed = true;
			edit_user_form.conn = main.connection;
			edit_user_form.f_table = "people";
			edit_user_form.f_table_key_column_name = "person_id";
			edit_user_form.f_table_label_column_name = "person_name_last";
			edit_user_form.draw();
			addChild(edit_user_form);
			var edit_user_form_label:text = new text("Edit Users", 400, textf);
			addChild(edit_user_form_label);
			
			function edit_user_form_submited(obj:Object):void {
				main.connection.server_command("edit_user", obj, edit_user_form_response, true);
			}
			function edit_user_form_response(data:LoaderEvent):void {
				main.toast("User Edited");
			}
			
			
			
			var add_user_perm:Vector.<f_element> = new Vector.<f_element>();
			
			var add_user_perm_user:f_element_select = new f_element_select("User", "person_id", null, 'User');
			add_user_perm_user.dynamic_options = new f_element_DynamicOptions(main.connection, 'people', 'person_id', 'person_name_last');
			add_user_perm.push(add_user_perm_user);
			
			var add_user_perm_exhibit:f_element_select = new f_element_select("Exhibit", "exhibit_id", null, 'Exhibit');
			add_user_perm_exhibit.dynamic_options = new f_element_DynamicOptions(main.connection, 'exhibits', 'exhibit_id', 'exhibit_name');
			add_user_perm.push(add_user_perm_exhibit);
			
			var add_user_perm_form:f_data = new f_data(add_user_perm);
			add_user_perm_form.onSubmit = add_user_perm_form_submited;
			add_user_perm_form.edit_siblings_allowed = false;
			add_user_perm_form.conn = main.connection;
			add_user_perm_form.draw();
			addChild(add_user_perm_form);
			var add_user_perm_form_label:text = new text("Grant someone permission to edit an exhibit", 400, textf);
			addChild(add_user_perm_form_label);
			
			function add_user_perm_form_submited(obj:Object):void {
				main.connection.server_command("add_permissions", obj, add_user_perm_form_response, true);
			}
			function add_user_perm_form_response(data:LoaderEvent):void {
				main.toast("Permissions Granted");
			}
			
			
			
			if (main.Imree.Device.orientation === "portrait") {
				form_label.x = 20;
				form_label.y = 20;
				form.x = 20;
				form.y = form_label.height + 10;
				
				edit_user_form_label.x = 20;
				edit_user_form_label.y = form.y + form.height + 100;
				edit_user_form.x = 20;
				edit_user_form.y = edit_user_form_label.y + edit_user_form_label.height +20;
				
				new_user_form_label.x = 20;
				new_user_form_label.y = edit_user_form.y +  edit_user_form.height+100;
				new_user_form.x = 20;
				new_user_form.y = new_user_form_label.y + new_user_form_label.height+20;
			} else {
				form_label.x = 20;
				form_label.y = 20;
				form.x = 20;
				form.y = form_label.height + form_label.y +10;
				
				edit_user_form_label.x =  form.width+50;
				edit_user_form_label.y = 20;
				edit_user_form.x = form.width+50;
				edit_user_form.y = edit_user_form_label.height + edit_user_form_label.y +10;
				
				new_user_form_label.x =  edit_user_form.x + edit_user_form.width + 50;
				new_user_form_label.y = 20;
				new_user_form.x = edit_user_form.x + edit_user_form.width+50;
				new_user_form.y = new_user_form_label.height + new_user_form_label.y +10;
				
				add_user_perm_form_label.x = new_user_form.x + new_user_form.width + 50;
				add_user_perm_form_label.y = 20;
				add_user_perm_form.x = new_user_form.x + new_user_form.width + 50;
				add_user_perm_form.y = add_user_perm_form_label.height + add_user_perm_form_label.y + 10;
			}
		}
		
	}

}