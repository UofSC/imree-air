package imree.modules 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
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
		override public function draw_thumb(_w:int = 200, _h:int = 200, Return:Boolean = false):* {
			var coverfont:textFont = new textFont('_sans', 28);
			coverfont.align = TextAlign.CENTER;
			var covertext:text = new text(module_name, _w * .5, coverfont, _h * .5);
			covertext.x = (_w * .5) / 2 - covertext.width / 2;
			covertext.y = (_h * .5) / 2 - covertext.height / 2;
			var wrapper:Sprite = new Sprite();
			wrapper.addChild(covertext);
			wrapper.addChild(new box(_w * .5, _h * .5));
			if (Return) {
				var bits:BitmapData = new BitmapData(_w, _h);
				bits.draw(wrapper);
				var ret:Sprite = new Sprite();
				ret.addChild(new Bitmap(bits));
				return ret;
			} else {
				addChild(wrapper);
			}
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