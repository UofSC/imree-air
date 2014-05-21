package imree.data_helpers {
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.GraphicsBitmapFill;
	import flash.display.IGraphicsData;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import imree.Main;
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
		
		static public var background_pattern_primary:BitmapData;
		static public var background_pattern_secondary:BitmapData;
		
		static public var color_transform_page_buttons:ColorTransform;
		static public var color_transform_background_image:ColorTransform;
		
		static private var primary_fields_processed:Boolean = false;
		public var styles:Vector.<textFont>;
		
		

		/**
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
		[Embed(source = "../../../fonts/OpenSans-LightItalic.ttf", fontName = 'OpenSansLightItalic', embedAsCFF = "true")] static public var OpenSansLightItalicFont:Class;
		[Embed(source = "../../../fonts/OpenSans-Semibold.ttf", fontName = 'OpenSansSemibold', embedAsCFF = "true")] static public var OpenSansSemiboldFont:Class;
		[Embed(source = "../../../fonts/OpenSans-SemiboldItalic.ttf", fontName = 'OpenSansSemiboldItalic', embedAsCFF = "true")] static public var OpenSansSemiboldItalicFont:Class;
		*/
		[Embed(source = "../../../fonts/AbrahamLincoln.ttf", 	fontName = 'AbrahamLincoln',	fontWeight="normal", 	embedAsCFF = "true")] static public var AbrahamLincolnFont:Class;
		[Embed(source = "../../../fonts/OpenSans-Light.ttf", 	fontName = 'OpenSansLight', 		fontWeight="normal", 	embedAsCFF = "true")] static public var OpenSansLightFont:Class;
		[Embed(source = "../../../fonts/OpenSans-Regular.ttf", 	fontName = 'OpenSans', 		fontWeight="normal", 	embedAsCFF = "true")] static public var OpenSansFont:Class;
		[Embed(source = "../../../fonts/Dosis-Medium.ttf",		fontName = 'Dosis', 			fontWeight="normal",	embedAsCFF = "true")] static public var DosisFont:Class;
		[Embed(source = "../../../fonts/GarRegular.TTF", 		fontName = 'Garamond', 		fontWeight="normal",	embedAsCFF = "true")] static public var GaramondFont:Class;
		[Embed(source = "../../../fonts/Archer-Book.otf", 		fontName = 'ArcherLight', 		fontWeight="normal",	embedAsCFF = "true")] static public var ArcherFont:Class;
		
		public function Theme() {
			
		}
		
		public function get_theme(id:int, main:Main):* {
			var theme:MovieClip;
			if (id === 1) {
				theme =  MovieClip(new theme_1());
			} else if (id === 2) {
				theme =  MovieClip(new theme_2());
			} else if (id === 3) {
				theme =  MovieClip(new theme_3());
			} else if (id === 4) {
				theme =  MovieClip(new theme_4());
			} 
			
			
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
					} else if (target.getLineText(0).search("heading1") === 0) {
						Theme.font_style_h1 = txtFont
					} else if (target.getLineText(0).search("heading2") === 0) {
						Theme.font_style_h2 = txtFont
					} else if (target.getLineText(0).search("heading3") === 0) {
						Theme.font_style_h3 = txtFont
					} else if (target.getLineText(0).search("caption") === 0) {
						Theme.font_style_caption = txtFont
					} else if (target.getLineText(0).search("description") === 0) {
						Theme.font_style_description = txtFont
					} else if (target.getLineText(0).search("background_color_primary") === 0) {
						Theme.background_color_primary = txtFont.color;
					} else if (target.getLineText(0).search("background_color_secondary") === 0) {
						Theme.background_color_secondary = txtFont.color;
					} else if (target.getLineText(0).search("image_wash_color") === 0) {
						Theme.background_color_secondary = txtFont.color;
					} else {
						// Is not a textfield we're tracking  image_wash_color
					} 
				} else if(theme.getChildAt(i)  is button_back) {
					Theme.color_transform_page_buttons = theme.getChildAt(i).transform.colorTransform;
				} else if (theme.getChildAt(i) is sample_background_image) {
						Theme.color_transform_background_image = theme.getChildAt(i).transform.colorTransform;
				}
					
				
			}
			
			if (main.stage.stageWidth < 600) {
				Theme.font_style_title.size *= .8;
				Theme.font_style_sub_title.size *= .8;
			}
			if (main.stage.stageWidth < 600) {
				Theme.font_style_title.size *= .7;
				Theme.font_style_sub_title.size *= .7;
			}
			return;
		}
		
	}

}