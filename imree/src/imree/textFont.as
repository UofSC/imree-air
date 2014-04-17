package imree 
{
	import flash.system.Capabilities;
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
		public static var main:Main;
		
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
			this.padding = 0;
			
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
			f.lineHeight = this.size + leading;
			f.fontSize = this.size;
			f.fontStyle = posture;
			f.textAlign = this.align;
			
			if (main !== null && main.Imree !== null && main.Imree.Device !== null) {
				var DPI:Number = Capabilities.screenDPI;
				f.fontSize = ((2 / 9) *  DPI) * (f.fontSize / 12);
			}
			
			return f;
		}
		
	}

}