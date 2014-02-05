package imree.data_helpers 
{
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class position_data extends Object
	{
		public var width:Number;
		public var height:Number;
		public var x:Number;
		public var y:Number;
		public function position_data(w:Number = 100, h:Number = 100, _x:Number = 0, _y:Number = 0) 
		{
			this.width = w;
			this.height = h;
			this.x = _x;
			this.y = _y;
		}
		
	}

}