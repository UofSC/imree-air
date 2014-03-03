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
		public function device(main:Main) 
		{
			screen_inches_wide = main.stage.fullScreenWidth / Capabilities.screenDPI;
			screen_inches_tall = main.stage.fullScreenHeight / Capabilities.screenDPI;
			screen_square_inches = screen_inches_tall * screen_inches_wide;
			main.log("Device: square_inches = " + screen_inches_wide + " x " + screen_inches_tall + " = " + screen_square_inches);
			
			if (screen_square_inches < 50) {
				
			}
			
			//determine device type with http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/desktop/NativeApplication.html features
		}
		
	}

}