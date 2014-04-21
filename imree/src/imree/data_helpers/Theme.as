package imree.data_helpers {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
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
		
		static public var image_color_transform:ColorTransform;
		
		public var styles:Vector.<textFont>;
		
		
		[Embed(source = "../../../fonts/AbrahamLincoln.ttf", fontName = 'AbrahamLincoln', embedAsCFF = "true")] static public var AbrahamLincolnFont:Class;
		[Embed(source = "../../../fonts/Lobster.ttf", fontName = 'Lobster', embedAsCFF = "true")] static public var LobsterFont:Class;
		[Embed(source = "../../../fonts/Lora-Bold.ttf", fontName = 'LoraBold', embedAsCFF = "true")] static public var LoraBoldFont:Class;
		[Embed(source = "../../../fonts/Lora-BoldItalic.ttf", fontName = 'LoraBoldItalic', embedAsCFF = "true")] static public var LoraBoldItalicFont:Class;
		[Embed(source = "../../../fonts/Lora-Italic.ttf", fontName = 'LoraItalic', embedAsCFF = "true")] static public var LoraItalicFont:Class;
		[Embed(source = "../../../fonts/Lora-Regular.ttf", fontName = 'Lora', embedAsCFF = "true")] static public var LoraFont:Class;
		[Embed(source = "../../../fonts/OpenSans-Bold.ttf", fontName = 'OpenSansBold', embedAsCFF = "true")] static public var OpenSansBoldFont:Class;
		[Embed(source = "../../../fonts/OpenSans-BoldItalic.ttf", fontName = 'OpenSansBoldItalic', embedAsCFF = "true")] static public var OpenSansBoldItalicFont:Class;
		[Embed(source = "../../../fonts/OpenSans-ExtraBold.ttf", fontName = 'OpenSansExtraBold', embedAsCFF = "true")] static public var OpenSansExtraBoldFont:Class;
		[Embed(source = "../../../fonts/OpenSans-ExtraBoldItalic.ttf", fontName = 'OpenSansExtraBoldItalic', embedAsCFF = "true")] static public var OpenSansExtraBoldItalicFont:Class;
		[Embed(source = "../../../fonts/OpenSans-Italic.ttf", fontName = 'OpenSansItalic', embedAsCFF = "true")] static public var OpenSansItalicFont:Class;
		[Embed(source = "../../../fonts/OpenSans-Light.ttf", fontName = 'OpenSansLight', embedAsCFF = "true")] static public var OpenSansLightFont:Class;
		[Embed(source = "../../../fonts/OpenSans-LightItalic.ttf", fontName = 'OpenSansLightItalic', embedAsCFF = "true")] static public var OpenSansLightItalicFont:Class;
		[Embed(source = "../../../fonts/OpenSans-Regular.ttf", fontName = 'OpenSans', embedAsCFF = "true")] static public var OpenSansFont:Class;
		[Embed(source = "../../../fonts/OpenSans-Semibold.ttf", fontName = 'OpenSansSemibold', embedAsCFF = "true")] static public var OpenSansSemiboldFont:Class;
		[Embed(source = "../../../fonts/OpenSans-SemiboldItalic.ttf", fontName = 'OpenSansSemiboldItalic', embedAsCFF = "true")] static public var OpenSansSemiboldItalicFont:Class;
		
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
						// Is not a textfield we're tracking
					}
				} else if(theme.getChildAt(i)  is MovieClip) {
					Theme.image_color_transform = MovieClip(theme.getChildAt(i)).transform.colorTransform;
				}
			}
			return null;
		}
		
	}

}