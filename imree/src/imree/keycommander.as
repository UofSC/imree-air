package imree 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import imree.data_helpers.KeyCode;
	/**
	 * ...
	 * @author Jason Steelman - uscart@gmail.com
	 */
	public class keycommander extends Sprite
	{
		private var t:keycommander;
		private var m:Main;
		public function keycommander(main:Main) 
		{
			this.t = this;
			this.m = main;
			t.addEventListener(Event.ADDED_TO_STAGE, addedtostage);
		}
		private function addedtostage(e:Event):void {
			t.removeEventListener(Event.ADDED_TO_STAGE, addedtostage);
			t.stage.addEventListener(KeyboardEvent.KEY_DOWN, testkey);
		}
		private function testkey(e:KeyboardEvent):void {
				if (e.keyCode === KeyCode.S) {
					//the "S" key was pressed, etc...
				}
		}
		
		
	}

}