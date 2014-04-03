package imree.modules 
{
	import fl.controls.Button;
	import flash.events.MouseEvent;
	import imree.shortcuts.box;
	import imree.data_helpers.position_data;
	import imree.layout;
	import imree.Main;
	import imree.pages.exhibit_display;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class module_next extends module
	{
		
		public function module_next(_main:Main, _Exhibit:exhibit_display, _items:Vector.<module>=null)
		{
			super(_main, _Exhibit, _items);
		}
		override public function draw_thumb(_w:int = 200, _h:int = 200, Return:Boolean = false):* {
			var arrow:button_back = new button_back();
			arrow.rotation = 180;
			arrow.x = arrow.width * 2;
			arrow.y = arrow.height;
			addChild(arrow);
			arrow.addEventListener(MouseEvent.CLICK, next_clicked);
			return null;
		}
		override public function draw_feature(_w:int, _h:int):void 
		{
			var arrow:button_back = new button_back();
			arrow.rotation = 180;
			arrow.x = arrow.width * 2;
			arrow.y = arrow.height;
			addChild(arrow);
			arrow.addEventListener(MouseEvent.CLICK, next_clicked);
		}
		private function next_clicked(e:MouseEvent):void {
			if (onSelect !== null) {
				onSelect(t);
			}
		}
	}

}