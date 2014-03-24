package imree.forms 
{
	/**
	 * ...
	 * @author Jason Steelman
	 */
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
	import flash.text.TextFieldAutoSize;
	import imree.display_helpers.*;
	import imree.shortcuts.box;
	import imree.text;
	import imree.textFont;
	
	public class f_element_text extends f_element
	{
		private var txt:TextField;
		public var is_password:Boolean;
		public function f_element_text(_label:String, _data_column_name:String, _value:String = "") {
			label = _label;
			value = _value;
			initial_val = _value;
			data_column_name = _data_column_name;
			super();
		}
		
		override public function draw(label_width:int = 100, input_w:int = 200, padding:int = 10 ):void {
			ui = new Sprite();
			
			var label_display:text = new text(this.label, label_width, this.label_textFont);
			label_display.y += 5;
			ui.addChild(label_display)
			
			var inputFormat:TextFormat = new TextFormat('_sans', input_element_fontSize);
			
			var textbox:TextField = new TextField();
				
				textbox.setTextFormat(inputFormat);
				textbox.type = TextFieldType.INPUT;
				textbox.text =  initial_val;
				textbox.background = true;
				
				textbox.defaultTextFormat = inputFormat;
				textbox.multiline = false;
				textbox.wordWrap = false;
				textbox.autoSize = TextFieldAutoSize.NONE;
				textbox.height = input_element_fontSize * 2 - 10;
				textbox.width = input_w;
				textbox.border = true;
				textbox.borderColor = 0x000000;
				textbox.x = label_width + padding;
				textbox.y = 0;
				textbox.type = TextFieldType.INPUT;
				txt = textbox;
				ui.addChild(textbox);
				
			if (is_password) {
				txt.displayAsPassword = true;
			}
			loader_x = label_width + input_w + padding + 2;
			super.draw(label_width, input_w, padding);
		}
		override public function get_value():* {
			return txt.text;
		}
		override public function set_value(e:*):void {
			txt.replaceText(0, txt.text.length, String(e));
			super.set_value(e);
		}
		override public function set_disable():void {
			if (txt != null) {
				txt.selectable = false;
				txt.type = TextFieldType.DYNAMIC;
				txt.borderColor = 0xFF99FF;
				txt.mouseEnabled = false;
				txt.tabEnabled = false;
				txt.restrict = "";
			}
		}
		override public function set_enabled():void {
			if (txt != null) {
				txt.selectable = true;
				txt.type = TextFieldType.INPUT;
				txt.borderColor = 0xFFFFFF;
				txt.mouseEnabled = true;
				txt.tabEnabled = true;
				txt.restrict = null;
			}
		}
	}

}