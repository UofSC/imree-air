package imree 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Tonya Holladay
	 */
	public class accordion_item extends Sprite
	{
		public var headline:String;
		public var description:String;
		public function accordion_item(Headline:String, desc:String="") 
		{
			this.headline = Headline;
			this.description = desc;
		}
		
	}

}