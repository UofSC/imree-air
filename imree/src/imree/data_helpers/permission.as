package imree.data_helpers 
{
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class permission 
	{
		public const NONE:String = "NO";
		public const USE:String = "USR";
		public const EDIT:String = "EDIT";
		public const ADMIN:String = "ADMIN";
		public var permission_level:String;
		
		public function permission(_permission_level:String=NONE) 
		{
			permission_level = _permission_level;
		}
		public function can(test_level:String):Boolean {
			if (permission_level === NONE) {
				return false;
			}
			return test_level.length < permission_level.length;
		}
		
	}

}