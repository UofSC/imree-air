package imree 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class logger extends Sprite
	{
		public var txt:TextField;
		public function logger() 
		{
			/**
			 * We need to make a displayObject (sprite, movieclip, etc...) that includes txt
			 * the displayObject needs to have a vertical scrolling feature so we can "scroll up" to log entries that may be too far back in time to be visible
			 */
			txt = new TextField();
			this.visible = false;
		}
		public function show():void {
			/**
			 * this needs to be registered to the keycommander
			 */
			this.visible = true;
		}
		public function hide():void {
			/**
			 * this needs to be registered to the keycommander
			 */
			this.visible = false;
		}
		public function add(str:*):void {
			txt.appendText(String(str));
			trace(str); //this is here so that it also logs everything to the output log too
		}
		
	}

}