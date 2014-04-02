package imree 
{
	import com.greensock.TweenMax;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import imree.shortcuts.box;
	/**
	 * ...
	 * @author Tonya Holladay
	 */
	public class news_accordion extends Sprite 
	{
		public var Items:Vector.<news_accordion_item>;
		public var boxes:Vector.<box>;
		public var w:int;
		public var h:int;
		public function news_accordion(items:Vector.<news_accordion_item>, _w:int = 500, _h:int = 300) 
		{
			Items = items;
			w = _w;
			h = _h;
			boxes = new Vector.<box>()
			
			this.addEventListener(Event.ADDED_TO_STAGE, added2stage);
		}
		private function added2stage(e:Event):void {
			for each(var post:news_accordion_item in Items) {
				addChild(post);
			}
		}
		
		public function show() {
			
		}
		
	}

}