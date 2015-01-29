package imree.data_helpers 
{
	import com.demonsters.debugger.MonsterDebugger;
	import imree.data_helpers.permission;
	
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class user_privilege 
	{
		public var privilege:String;  //one of 'super_admin','publisher','group','exhibit'
		public var permission_level:permission;  //one of 'NO','USR','EDIT','ADMIN'
		public var asset_scope:String;
		public function user_privilege(_privilege:String, _permission_level:String = "NO", _asset_scope:String = "") 
		{
			privilege = _privilege;
			permission_level = new permission(_permission_level);
			asset_scope = _asset_scope;
		}
		public function can(test_level:String):Boolean {
			var result:Boolean = permission_level.can(test_level);
			return result;
		}
		
	}

}