package imree.display_helpers 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
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
		public function dump():void {
			if (button !== null) {
				if (contains(button)) {
					removeChild(button);
				}
				button.removeEventListener(MouseEvent.CLICK, clicked);
				button = null;
			}
		}
		
		public var enabled:Boolean = true;
		public function enable():void {
			enabled = true;
			mouseEnabled = true;
			alpha = 1;
		}
		public function disable():void {
			enabled = false;
			mouseEnabled = false;
			alpha = .25;
		}
		
		public var highlighted:Boolean = false;
		public function highlight():void {
			if(!highlighted) {
				var glow:GlowFilter = new GlowFilter();
				filters = [glow];
				highlighted = true;
			}
		}
		public function highlight_remove():void {
			filters = [];
			highlighted = false;
		}
	}

}