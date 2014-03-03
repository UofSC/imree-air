package imree.data_helpers 
{
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class date_from_mysql extends Object
	{
		public var this_str:String;
		public var time:Date;
		public var months:Array;
		public function date_from_mysql(str:String = null)
		{
			if(str !== null) {
				this.this_str = str;
				make_date(str);
			}
			months = ['January', 'February', '...'];
			
		}
		public function make_date(str:String):Date {
			//assumes YYYY-MM-DD HH:ii:ss
			//        0123 56 89 12 45 78
			time = new Date();
			time.setFullYear(str.substr(0, 4));
			time.setMonth(int(str.substr(5, 2)) - 1);
			time.setDate(str.substr(8, 2));
			time.setHours(str.substr(11, 2));
			time.setMinutes(str.substr(14, 2));
			time.setSeconds(str.substr(17, 2));
			return time;
		}
		
		public function pretty_date(str:String, short:Boolean = true, include_time:Boolean = true):String {
			var result:String = "";
			var date:Date = make_date(str);
			
			if (short) {
				
				//something like 7/4/1014
			} else {
				//returns something like "July 4, 2014"
				result += months[date.month];
			}
			
			if (include_time) {
				result += "time"; //3:28pm
			}
		}
		
	}

}