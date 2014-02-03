package imree.data_helpers 
{
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class date_from_mysql extends Date
	{
		
		public function date_from_mysql(str:String)
		{
			//assumes YYYY-MM-DD HH:ii:ss
			//        0123 56 89 12 45 78
			this.setFullYear(str.substr(0, 4));
			this.setMonth(str.substr(5, 2));
			this.setDate(str.substr(8, 2));
			this.setHours(str.substr(11, 2));
			this.setMinutes(str.substr(14, 2));
			this.setSeconds(str.substr(17, 2));
			
		}
		
	}

}