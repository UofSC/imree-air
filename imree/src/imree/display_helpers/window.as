package imree.display_helpers 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import imree.data_helpers.Theme;
	import imree.Main;
	import imree.shortcuts.box;
	/**
	 * ...
	 * @author Jason Steelman - uscart@gmail.com
	 */
	public class window extends Sprite
	{
		public var background:box;
		public var foreground:box;
		public var foreground_content_wrapper:Sprite;
		public var close_hit_area:box;
		public var offset:int;
		private var main:Main;
		public function window(_w:int, _h:int, _main:Main, content:DisplayObject = null) {
			main = _main;
			background = new box(_w, _h, Theme.background_color_primary, .7);
			
			offset = main.Imree.Device.ui_size;
			if (main.Imree.Device.orientation === "portrait") {
				foreground = new box(_w, _h - offset, Theme.background_color_primary, 1);
				foreground.y = offset;
				close_hit_area = new box(_w, offset);
			} else {
				foreground = new box(_w - offset, _h, Theme.background_color_primary, 1);
				foreground.x = offset;
				close_hit_area = new box(offset, _h);
			}
			
			close_hit_area.addEventListener(MouseEvent.CLICK, remove);
			
			foreground_content_wrapper = new Sprite();
			
			addChild(background);
			addChild(close_hit_area);
			addChild(foreground);
			foreground.addChild(foreground_content_wrapper);
			
		}
		
		public function remove(e:Event):void {
			close_hit_area.removeEventListener(MouseEvent.CLICK, remove);
			main.animator.off_stage(this);
		}
		
		
	}

}