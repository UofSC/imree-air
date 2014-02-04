package imree.data_helpers 
{
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class date_helper 
	{
		public var string:String;
		public function date_helper(str:String = null) 
		{
			string = str;
		}
		public function from_mysql():Date {
			//assumes YYYY-MM-DD HH:ii:ss
			//        0123 56 89 12 45 78
			var d:Date = new Date();
			d.setFullYear(string.substr(0, 4));
			d.setMonth(string.substr(5, 2));
			d.setDate(string.substr(8, 2));
			d.setHours(string.substr(11, 2));
			d.setMinutes(string.substr(14, 2));
			d.setSeconds(string.substr(17, 2));
			return d;
		}
		
	}

}