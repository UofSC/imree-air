package imree.display_helpers 
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
	import imree.display_helpers.f_element;
	import imree.shortcuts.box;
	import imree.text;
	import imree.textFont;
	
	public class f_element_password extends f_element
	{
		private var txt:TextField;
		private var initial_val:String;
		public function f_element_password(_label:String, _data_column_name:String, _value:String = "") {
			this.label = _label;
			this.data_column_name = _data_column_name;
			this.value = _value;
			initial_val = _value;
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
				textbox.background = true;
				textbox.defaultTextFormat = inputFormat;
				textbox.multiline = false;
				textbox.text = initial_val;
				textbox.wordWrap = false;
				textbox.autoSize = TextFieldAutoSize.NONE;
				textbox.height = input_element_fontSize * 2 - 10;
				textbox.border = true;
				textbox.borderColor = 0xFFFFFF;
				textbox.width = input_w;
				textbox.x = label_width + padding;
				textbox.y = 0;
				textbox.type = TextFieldType.INPUT;
				txt = textbox;
				textbox.displayAsPassword = true;
				
				ui.addChild(textbox);
				
			super.draw();
		}
		override public function get_value():* {
			return txt.text;
		}
		
	}

}