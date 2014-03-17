package imree.data_helpers 
{
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class date_from_mysql extends Object
	{
		private var this_str:String;
		private var time:Date;
		private var months:Array;
		public function date_from_mysql(str:String = null)
		{
			
			
		}
		
		public function date_to_string(date:Date, short_date:Boolean = false, include_time:Boolean=false):String {
			var string:String = "";
			if (short_date) {
				string += this.short_date(date);
			} else {
				string += this.long_date(date);
			}
			
			if (include_time) {
				string += " " + timestring(date);
			}
			return string;
		}
		public function string_to_date(string:String):Date {
			//expects string like 1995/03/12 15:29:45
			//var year:int = int(string.substr(0, 4));
			return new Date();
		}
		
		private function timestring(date:Date):String {
			var string:String = "";
			if (date.getHours() > 12) {
				string += String(date.getHours() - 12) + ":" + String(date.getMinutes()) + "pm";
			} else {
				string += String(date.getHours())  + ":" + String(date.getMinutes()) + "am";;
			}
			return string;
		}
		
		private function short_date(newdate:Date):String {
			var thisyear:String = String (newdate.getFullYear());
			
			var thismonth:String = String(newdate.getMonth()+1);
			if (thismonth.length == 1) { 
				thismonth = "0" + thismonth;
			}
			
			var thisdate:String = String (newdate.getDate());
			if (thisdate.length == 1) { 
				thisdate = "0" + thisdate;
			}
			
			return thismonth + "/" +  thisdate + "/" + thisyear;
	
		}
		
		private function long_date(todaysdate:Date):String {
			var whatyear:String = String (todaysdate.getFullYear());
			var whatmonths:Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
			var whatday:String = String (todaysdate.getDate());
			
			return whatmonths[todaysdate.month] + " " + whatday + ", " + whatyear;
		}
		
		public function timestamp(timedate:Date):String {
			var timeyear:String = String(timedate.getFullYear());
			var timemonth:String  = String(timedate.getMonth()+1);
			var timehours:String = String(timedate.getHours());
			var timeminutes:String = String(timedate.getMinutes());
			var timeseconds:String = String(timedate.getSeconds());
			
			if (timemonth.length == 1) { 
				timemonth = "0" + timemonth;
			}
			
			var timeday:String  = String(timedate.getDate());
			if (timeday.length == 1) { 
				timeday = "0" + timeday;
			}
			
			if (timehours.length == 1) { 
				timehours = "0" + timehours;
			}
			
			if (timeminutes.length == 1) { 
				timeminutes = "0" + timeminutes;
			}
			
			if (timeseconds.length == 1) { 
				timeseconds = "0" + timeseconds;
			}
			
			return timeyear + "-" + timemonth + "-" + timeday + " " + timehours + ":" + timeminutes + ":" + timeseconds;
			
		}
		
	}

}