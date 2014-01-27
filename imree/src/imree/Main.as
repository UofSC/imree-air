package imree
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import imree.shortcuts.box;
	import imree.exhibit;
	
	/**
	 * ...
	 * @author Jason Steelman <uscart@gmail.com>, add yur name here as you work on this project/file
	 */
	public class Main extends Sprite 
	{
		public var connection:serverConnect;
		public var stack:exhibit;
		public function Main():void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			stage.addChild(this);
			
			connection = new serverConnect("http://imree.tcl.sc.edu/imree-php/api/");
			
			var layouts:layout = new layout();
			stage.addChild(layouts);
			var layout_answer = layouts.asset_grid_solver();
			
			stack = new exhibit();
			this.addChild(stack);
			
		}
		
		private function deactivate(e:Event):void 
		{
			// make sure the app behaves well (or exits) when in background
			//NativeApplication.nativeApplication.exit();
		}
		
	}
	
}