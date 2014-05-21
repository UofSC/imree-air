package imree.display_helpers 
{
	import com.demonsters.debugger.MonsterDebugger;
	import flash.desktop.*;
	import flash.display.Stage;
	import flash.system.Capabilities;
	import flash.system.TouchscreenType;
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
		public var dpi:Number;
		public var is_web_player:Boolean;
		public var is_flash_player:Boolean;
		public var orientation:String;
		public var box_size:int;
		public var supports_qr:Boolean;
		public var ui_size:int;
		public function device(main:Main) 
		{
			
			screen_inches_wide = main.stage.stageWidth / Capabilities.screenDPI;
			screen_inches_tall = main.stage.stageHeight / Capabilities.screenDPI;
			screen_square_inches = screen_inches_tall * screen_inches_wide;
			main.log("Device: square_inches = " + screen_inches_wide + " x " + screen_inches_tall + " = " + screen_square_inches);
			
			
			dpi = Capabilities.screenDPI;
			box_size = dpi * 1.5;
			box_size = 100;
			ui_size = 90;
			
			if (Capabilities.touchscreenType === TouchscreenType.NONE) {
				ui_size = 72;
			}
			
			var max_dimension:int;
			if (screen_inches_tall > screen_inches_wide) {
				orientation = "portrait";
				max_dimension = main.stage.stageHeight;
			} else {
				orientation = "landscape";
				max_dimension = main.stage.stageWidth;
			}
			
			if (max_dimension / box_size > 6) {
				box_size *= 2;
			}
			if (max_dimension / box_size > 8) {
				box_size *= 2;
			}
			if (max_dimension / box_size > 15) {
				box_size *= 2;
			}
			if (main.Imree !== null) {
				main.Imree.web_bar();
			}
			
			
			//determine device type with http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/desktop/NativeApplication.html features
			if (Capabilities.playerType == "StandAlone" || Capabilities.playerType == "ActiveX" || Capabilities.playerType == "PlugIn") {
				is_flash_player = true;
			} else {
				is_flash_player = false;
			}
			trace("Player Type: " + Capabilities.playerType);
		}
		
	}

}