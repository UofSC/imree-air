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
				
		public function short_date(): String {
			var newdate: Date = new Date;
			var thisyear:String = String (newdate.getFullYear());
			var thismonth:String = String(newdate.getMonth());
			var thistime: String = String (newdate.getTime());
			
			if (thismonth.length() == 1) { thismonth = "0" + thismonth;
			}
			var thisdate:String = String (newdate.getDate());
			if (thisdate.length() == 1) { thisdate = "0" + thisdate;
			}
			return thisyear.substring(2, 4) + thismonth + thisdate;
	
		}
		
		public function long_date():String {
			var todaysdate:Date = new Date;
			var whatyear:String = String (todaysdate.getFullYear());
			var whatmonths:Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
			var whattime:String = String (todaysdate.getTime));
			var whatday:String = String (todaysdate.getDate());
			
			var thedate:String = whatmonths[todaysdate.month] + "" + whatday + ",", "," + whatyear;
			return thedate();
		}
		
		public function timestamp(); String {
			var timedate:Date = new Date;
			var timeyear:String = String(timedate.getFullYear());
			var timemonth:String  = String(timedate.getMonth());
			var timehours:String = String(timedate.getHours());
			var timeminutes:String = String(timedate.getmintes());
			var timeseconds:String = String(timedate.getSeconds());
			
			if (timemonth.length() == 1) { timemonth = "0" + timemonth;
				
			}
			var timeday:String  = String(timedate.getDate());
			
			if (timeday.length() == 1) { timeday = "0" + timeday;
			
			}
			if (timehours.length() == 1) { timehours = "0" + timehours;
			
			}
			if (timeminutes.length() == 1) { timeminutes = "0" + timemutes;
			}
			
			if (timeseconds.length() == 1) { timeseonds = "0" + timeseconds;
			
			}
			
			return timeyear + "-" + timemonth + "-" + timeday + "," + timehours + ":" + timeminutes + ":" + timeseconds;
			
		}
		
	}

}