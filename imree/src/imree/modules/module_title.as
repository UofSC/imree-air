package imree.modules 
{
	import flash.display.Sprite;
	import imree.Main;
	import imree.pages.exhibit_display;
	import imree.shortcuts.box;
	import imree.text;
	import imree.textFont;
	import flashx.textLayout.formats.TextAlign;
	
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class module_title extends module
	{
		public function module_title(_main:Main, _Exhibit:exhibit_display, _items:Vector.<module>=null)
		{
			super(_main, _Exhibit, _items);
		}
		
		override public function draw_feature(_w:int, _h:int):void {
			var coverfont:textFont = new textFont('_sans', 28);
			coverfont.align = TextAlign.CENTER;
			var covertext:text = new text(module_name, _w * .5, coverfont, _h * .5);
			covertext.x = (_w * .5) / 2 - covertext.width / 2;
			covertext.y = (_h * .5) / 2 - covertext.height / 2;
			addChild(covertext);
			addChild(new box(_w * .5, _h * .5));
			
		}
	}

}