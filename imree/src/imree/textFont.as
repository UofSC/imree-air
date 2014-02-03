package imree 
{
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.text.engine.Kerning;
	import flash.text.Font;
	import flash.text.FontStyle;
	import flashx.textLayout.formats.LeadingModel;
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.formats.TextLayoutFormat;
	/**
	 * ...
	 * @author Jason Steelman - uscart@gmail.com
	 */
	public class textFont extends Object
	{
		public var lookup:String;
		public var size:int;
		public var color:uint;
		public var bold:Boolean;
		public var italic:Boolean;
		public var underline:Boolean;
		public var name:String;
		public var leading:Number;
		public var align:String;
		public var padding:Number;
				
		[Embed(source = "../fonts/AbrahamLincoln.ttf", fontName = 'AbrahamLincoln')] public var AbrahamLincolnFont:Class;
		[Embed(source = "../fonts/Lavanderia Delicate.otf", fontName = 'LavanderiaDelicate')] public var LavanderiaDelicateFont:Class;
		[Embed(source = "../fonts/Lavanderia Regular.otf", fontName = 'LavanderiaRegular')] public var LavanderiaRegularFont:Class;
		[Embed(source = "../fonts/Lavanderia Sturdy.otf", fontName = 'LavanderiaSturdy')] public var LavanderiaSturdyFont:Class;
		[Embed(source = "../fonts/Lobster.ttf", fontName = 'Lobster')] public var LobsterFont:Class;
		[Embed(source = "../fonts/Lora-Bold.ttf", fontName = 'LoraBold')] public var LoraBoldFont:Class;
		[Embed(source = "../fonts/Lora-BoldItalic.ttf", fontName = 'LoraBoldItalic')] public var LoraBoldItalicFont:Class;
		[Embed(source = "../fonts/Lora-Italic.ttf", fontName = 'LoraItalic')] public var LoraItalicFont:Class;
		[Embed(source = "../fonts/Lora-Regular.ttf", fontName = 'Lora')] public var LoraFont:Class;
		[Embed(source = "../fonts/OpenSans-Bold.ttf", fontName = 'OpenSansBold')] public var OpenSansBoldFont:Class;
		[Embed(source = "../fonts/OpenSans-BoldItalic.ttf", fontName = 'OpenSansBoldItalic')] public var OpenSansBoldItalicFont:Class;
		[Embed(source = "../fonts/OpenSans-ExtraBold.ttf", fontName = 'OpenSansExtraBold')] public var OpenSansExtraBoldFont:Class;
		[Embed(source = "../fonts/OpenSans-ExtraBoldItalic.ttf", fontName = 'OpenSansExtraBoldItalic')] public var OpenSansExtraBoldItalicFont:Class;
		[Embed(source = "../fonts/OpenSans-Italic.ttf", fontName = 'OpenSansItalic')] public var OpenSansItalicFont:Class;
		[Embed(source = "../fonts/OpenSans-Light.ttf", fontName = 'OpenSansLight')] public var OpenSansLightFont:Class;
		[Embed(source = "../fonts/OpenSans-LightItalic.ttf", fontName = 'OpenSansLightItalic')] public var OpenSansLightItalicFont:Class;
		[Embed(source = "../fonts/OpenSans-Regular.ttf", fontName = 'OpenSans')] public var OpenSansFont:Class;
		[Embed(source = "../fonts/OpenSans-Semibold.ttf", fontName = 'OpenSansSemibold')] public var OpenSansSemiboldFont:Class;
		[Embed(source = "../fonts/OpenSans-SemiboldItalic.ttf", fontName = 'OpenSansSemiboldItalic')] public var OpenSansSemiboldItalicFont:Class;
		
		public function textFont(name:String = '_sans', size:int=12) {
			if (name.substr(0, 1) === '_') {
				this.lookup = FontLookup.DEVICE
			} else {
				this.lookup = FontLookup.EMBEDDED_CFF;
			}
			this.name = name;
			this.size = size;
			this.color = 0x000000;
			this.bold = false;
			this.italic = false;
			this.underline = false;
			this.leading = 1.25;
			this.align = TextAlign.LEFT;
			this.padding = 5;
			
		}
		public function describe():TextLayoutFormat {
			var weight:String;
			if (this.bold) {
				weight = FontWeight.BOLD;
			} else {
				weight = FontWeight.NORMAL;
			}
			var posture:String;
			if (this.italic) {
				posture = FontPosture.ITALIC;
			} else {
				posture = FontPosture.NORMAL;
			}
			var f:TextLayoutFormat = new TextLayoutFormat();
				f.kerning = Kerning.ON;
				f.fontLookup = FontLookup.EMBEDDED_CFF;
				f.fontFamily = this.name;
				f.color = this.color;
				f.lineHeight = this.size * leading;
				
				f.fontSize = this.size;
				//f.fontWeight = weight;
				f.fontStyle = posture;
				f.textAlign = this.align;
			return f;
		}
		
	}

}