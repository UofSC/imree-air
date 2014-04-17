package imree 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import imree.data_helpers.KeyCode;
	import flash.display.*;
	import flash.display.StageScaleMode;
	
	
	
	/**
	 * ...
	 * @author Jason Steelman - uscart@gmail.com
	 */
	public class keycommander extends Sprite
	{
		private var t:keycommander;
		private var main:Main;
		public function keycommander(_main:Main ) 
		{
			this.t = this;
			main = _main;
			t.addEventListener(Event.ADDED_TO_STAGE, addedtostage);
		}
		private function addedtostage(e:Event):void {
			t.removeEventListener(Event.ADDED_TO_STAGE, addedtostage);
			t.stage.addEventListener(KeyboardEvent.KEY_DOWN, testkey);
		}
		private function testkey(e:KeyboardEvent):void {
			if (e.keyCode === KeyCode.SPACEBAR) {
				main.orientation_update(null);
			}
			if (e.keyCode === KeyCode.I) {
				main.removeChild(main.Logger);
				main.addChild(main.Logger);
				main.Logger.toggle();
			}
			
			if (e.keyCode === KeyCode.D) {
				main.removeChild(main.Logger_IO);
				main.addChild(main.Logger_IO);
				main.Logger_IO.toggle();
			}
		}
	}		
}

