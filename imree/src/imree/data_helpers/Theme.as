package imree.data_helpers {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import imree.textFont;
	
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class Theme extends Object{
		
		static public var font_style_h1:textFont;
		static public var font_style_h2:textFont;
		static public var font_style_h3:textFont;
		
		static public var font_style_title:textFont;
		static public var font_style_sub_title:textFont;
		static public var font_style_caption:textFont;
		static public var font_style_description:textFont;
		
		static public var background_color_primary:uint;
		static public var background_color_secondary:uint;
		
		
		public var styles:Vector.<textFont>;
		
		
		public function Theme() {
			
		}
		
		public function get_theme(id:int):* {
			var theme:MovieClip =  MovieClip(new theme_1());
			
			for (var i:int = 0; i < theme.numChildren; i++) {
				if (theme.getChildAt(i) is TextField) {
					var target:TextField = TextField(theme.getChildAt(i));
					var format:TextFormat = target.getTextFormat(0, 1);
					var txtFont:textFont = new textFont();
					txtFont.name = format.font;
					txtFont.bold = format.bold;
					txtFont.color = uint(format.color);
					txtFont.italic = format.italic;
					txtFont.size = int(format.size);
					txtFont.align = format.align;
					txtFont.leading = Number(format.leading);
					
					if (target.getLineText(0).search("title") === 0) {
						Theme.font_style_title = txtFont;
						trace("Case " + Theme.font_style_title);
					} else if (target.getLineText(0).search("sub_title") === 0) {
						Theme.font_style_sub_title = txtFont
					}else if (target.getLineText(0).search("heading1") === 0) {
						Theme.font_style_h1 = txtFont
					}else if (target.getLineText(0).search("heading2") === 0) {
						Theme.font_style_h2 = txtFont
					}else if (target.getLineText(0).search("heading3") === 0) {
						Theme.font_style_h3 = txtFont
					}else if (target.getLineText(0).search("caption") === 0) {
						Theme.font_style_caption = txtFont
					}else if (target.getLineText(0).search("description") === 0) {
						Theme.font_style_description = txtFont
					}else if (target.getLineText(0).search("background_color_primary") === 0) {
						Theme.background_color_primary = txtFont.color;
					}else if (target.getLineText(0).search("background_color_secondary") === 0) {
						Theme.background_color_secondary = txtFont.color;
					}  else {
						//
					}
				} else {
					trace("Is not important: " + theme.getChildAt(i));
				}
			}
			trace ("OMG HERE: " + Theme.font_style_title);
			return null;
		}
		
	}

}