package imree.modules 
{
	import flash.display.Sprite;
	import imree.Main;
	import imree.pages.exhibit_display;
	import imree.text;
	import imree.textFont;
	import flashx.textLayout.formats.TextAlign;
	
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class module_title extends Sprite
	{
		public var title:String;
		public var subtitle:String;
		public function module_title(_main:Main, _Exhibit:exhibit_display, _items:Vector.<module>=null)
		{
			super(_main, _Exhibit, _items);
		}
		override public function draw_thumb(_w:int = 200, _h:int = 200):void {
			
		}
		override public function draw_feature(_w:int, _h:int):void {
			var coverfont:textFont = new textFont('_sans', 28);
			coverfont.align = TextAlign.CENTER;
			var covertext:text = new text(title,_w, coverfont, _h);
			covertext.x = _w * .1;
			covertext.y = _h / 2 - covertext.height / 2;
			addChild(covertext);
		}
	}

}