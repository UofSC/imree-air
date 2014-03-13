package imree.data_helpers 
{
	import imree.Main;
	import imree.serverConnect;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class user 
	{
		public var person_id:int;
		public var person_name_last:String;
		public var person_name_first:String;
		public var person_title:String;
		public var person_department_id:int;
		public var ul_user_id:int;
		public var user_is_superAdmin:Boolean = false;
		public var user_is_logged_in:Boolean = false;
		public var user_privileges:Vector.<user_privilege>;
		private var main:Main;
		public function user(_main:Main)  
		{
			main = _main;
			user_privileges = new Vector.<user_privilege>();
		}
		
		/**
		 * Determine if an authenticated user CAN do some action. 
		 * Example: user.can(user_privilege_permission.EDIT, 'exhibit', 12) asks if the user can edit exhibit identified as "12"
		 * @param	permission
		 * @param	privilege
		 * @param	asset_scope
		 */
		public function can(_permission:String, _privilege:String, asset_scope:String = null):Boolean {
			if (user_is_superAdmin && user_is_logged_in) {
				return true;
			}
			
			var target_privilege:user_privilege;
			for each(var i:user_privilege in user_privileges) {
				if(_privilege === i.privilege && i.asset_scope === asset_scope) {
					target_privilege = i;
				}
			}
			if (target_privilege === null) {
				return false;
			} else {
				return target_privilege.can(_permission);
			}
		}
		public function toString():String {
			var str:String = "\n\
			\nUSER DATA:\n\
		id: "+ person_id + "\n\
		name_first: "+ person_name_first + "\n\
		name_last: "+ person_name_last + "\n\
		title: "+ person_title + "\n\
		department: "+ person_department_id + "\n\
		ul_user_id: "+ ul_user_id + "\n\
		super_admin: "+ user_is_superAdmin + "\n\
		logged_in: "+ user_is_logged_in + "\n\
			";
			for each(var p:user_privilege in user_privileges) {
				str += "\n\
		PRIVILEGE: " + p.privilege + " = " + permission(p.permission_level).permission_level + " (scope:'" + p.asset_scope + "')";
			}
			return str;
			
		}
	}

}