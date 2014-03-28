package imree.forms 
{
	/**
	 * ...
	 * @author Jason Steelman
	 */
	
	import fl.controls.Button;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
	import flash.text.TextFieldAutoSize;
	import imree.display_helpers.*;
	import imree.shortcuts.box;
	import imree.text;
	import imree.textFont;
	
	public class f_element_WYSIWYG extends f_element
	{
		private var txt:TextField;
		public function f_element_WYSIWYG(_label:String, _data_column_name:String, _value:String = "") {
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
			//textbox.text =  initial_val;
			textbox.background = true;
			textbox.htmlText = initial_val;
			textbox.defaultTextFormat = inputFormat;
			textbox.multiline = true;
			textbox.wordWrap = true;
			textbox.autoSize = TextFieldAutoSize.LEFT;
			textbox.height = 400;			//@todo re evaluate what this value is
			textbox.width = input_w;
			textbox.border = true;
			textbox.borderColor = 0x000000;
			textbox.x = label_width + padding;
			textbox.y = 20;
			txt = textbox;
			ui.addChild(textbox);
			loader_x = label_width + input_w + padding + 2;
			super.draw(label_width, input_w, padding);
			
			var butt_u_ui:Button = new Button();
			butt_u_ui.label = "Underline";
			butt_u_ui.setSize(20, 20);
			var butt_u:smart_button = new smart_button(butt_u_ui, do_underline);
			function do_underline(e:*= null):void {
				trace("Selection from " + textbox.selectionBeginIndex + " to " + textbox.selectionEndIndex);
			}
			ui.addChild(butt_u);
			
			
			
			
			
			
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