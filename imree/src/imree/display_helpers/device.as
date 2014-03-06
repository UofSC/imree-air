package imree.display_helpers 
{
	import flash.desktop.NativeApplication;
	import flash.system.Capabilities;
	import imree.Main;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class device 
	{
		public var type:String;
		public var input_type:String;
		public var screen_square_inches:Number;
		public var screen_inches_wide:Number;
		public var screen_inches_tall:Number;
		public var orientation:String;
		public var box_size:int;
		public function device(main:Main) 
		{
			screen_inches_wide = main.stage.fullScreenWidth / Capabilities.screenDPI;
			screen_inches_tall = main.stage.fullScreenHeight / Capabilities.screenDPI;
			screen_square_inches = screen_inches_tall * screen_inches_wide;
			main.log("Device: square_inches = " + screen_inches_wide + " x " + screen_inches_tall + " = " + screen_square_inches);
			
			//y = mx + b
			//block_size = screenwidth/5 + 100;
			if (screen_inches_tall > screen_inches_wide) {
				orientation = "portrait";
				box_size = Math.round(main.stage.stageHeight / 5 + 100);
			} else {
				orientation = "landscape";
				box_size = Math.round(main.stage.stageWidth / 5 + 100);
			}
			
			
			
			
			
			//determine device type with http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/desktop/NativeApplication.html features
		}
		
	}

}