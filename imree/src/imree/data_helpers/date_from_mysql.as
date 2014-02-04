package imree.data_helpers 
{
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class date_from_mysql extends Date
	{
		public var this_str:String;
		public function date_from_mysql(str:String = null)
		{
			if(str !== null) {
				this.this_str = str;
				make_date();
			}
		}
		public function make_date(str):Date {
			//assumes YYYY-MM-DD HH:ii:ss
			//        0123 56 89 12 45 78
			var str:String = this.this_str;
			this.setFullYear(str.substr(0, 4));
			this.setMonth(str.substr(5, 2));
			this.setDate(str.substr(8, 2));
			this.setHours(str.substr(11, 2));
			this.setMinutes(str.substr(14, 2));
			this.setSeconds(str.substr(17, 2));
			return this;
		}
		public function as_Date():Date {
			return this as Date;
		}
		
	}

}