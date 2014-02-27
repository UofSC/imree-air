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
			if (e.keyCode === KeyCode.T) {
				trace("T");
				stage.scaleMode = StageScaleMode.SHOW_ALL;
				stage.displayState =  StageDisplayState.FULL_SCREEN;
			}
			if (e.keyCode === KeyCode.TAB) {
				main.Imree.Menu.toggle();
			}
		}
	}		
}

