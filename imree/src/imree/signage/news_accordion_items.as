package imree.signage 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Tonya Holladay
	 */
	public class news_accordion_items extends Sprite
	{
		public var headline:String;
		public var description:String;
		public function news_accordion_items(Headline:String, desc:String="") 
		{
			this.headline = Headline;
			this.description = desc;
		}
		
	}

}