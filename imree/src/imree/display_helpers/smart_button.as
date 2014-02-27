package imree.display_helpers 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class smart_button extends Sprite
	{
		public var button:DisplayObject;
		public var onInteract:Function;
		public function smart_button(_button:DisplayObject, _onInteract:Function) 
		{
			button = _button;
			onInteract = _onInteract;
			addChild(button);
			button.addEventListener(MouseEvent.CLICK, clicked);
		}
		private function clicked(e:MouseEvent):void {
			onInteract();
		}
		
	}

}