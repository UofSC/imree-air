package imree.forms 
{
	/**
	 * ...
	 * @author Jason Steelman / Tonya Holladay
	 */
	
	import fl.controls.Button;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
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
						
			
			
			var container:Sprite = new Sprite;
			container.graphics.beginFill(0xFFFFFFF, 1);
			container.graphics.lineStyle(2, 0x000000);			
			container.graphics.drawRect(0,0, input_w, 100+30);
			container.graphics.endFill();
			ui.addChild(container);
			
			
			var label_display:text = new text(this.label, label_width, this.label_textFont);
			label_display.y += 5;
		
			container.addChild(label_display)
			
			var currentText:String;
			var currentSelect:String;
			var beforeSelect:String;
			var afterSelect:String;
			
			
			var inputFormat:TextFormat = new TextFormat('_sans', input_element_fontSize);
			
			var textbox:TextField = new TextField();
				
			textbox.setTextFormat(inputFormat);
			textbox.type = TextFieldType.INPUT;
			//textbox.text =  initial_val;
			textbox.background = false;
			textbox.htmlText = initial_val;
			textbox.defaultTextFormat = inputFormat;
			textbox.multiline = true;
			textbox.wordWrap = true;
			textbox.autoSize = TextFieldAutoSize.LEFT;
			textbox.height = 100;			//@todo re evaluate what this value is
			textbox.width = input_w;
			textbox.border = true;
			textbox.borderColor = 0x000000;
			textbox.x = 0;//label_width + padding;
			textbox.y = 35;
			txt = textbox;
			container.addChild(textbox);
			loader_x = label_width + input_w + padding + 2;
			super.draw(label_width, input_w, padding);
			
			var butt_u_ui:Button = new Button();
			butt_u_ui.label = "U";
			butt_u_ui.setSize(20, 20);
			butt_u_ui.x = 5;
			butt_u_ui.y = 10;
			var butt_u:smart_button = new smart_button(butt_u_ui, do_underline);
			function do_underline(e:*= null):void {
				trace("Selection from " + textbox.selectionBeginIndex + " to " + textbox.selectionEndIndex);
			}
			container.addChild(butt_u);
			
			butt_u.addEventListener(MouseEvent.CLICK, UnderlineClick);
			
			
			function UnderlineClick(e:MouseEvent):void {
				replace_with("u");
			}	
			function replace_with(format:String):void {
				currentText = txt.text;
				currentSelect = currentText.substring(txt.selectionBeginIndex, txt.selectionEndIndex);
				beforeSelect = currentText.substring(0, txt.selectionBeginIndex);
				afterSelect = currentText.substring(txt.selectionEndIndex);
				initial_val = beforeSelect + "<"+format+">" + currentSelect + "</"+format+">" + afterSelect;
				ui = null;
				draw(label_width, input_w, padding);
			}
						
			var butt_i_ui:Button = new Button();
			butt_i_ui.label = "I";
			butt_i_ui.setSize(20, 20);
			butt_i_ui.x = butt_u_ui.x + 25;
			butt_i_ui.y = 10;
			var butt_i:smart_button = new smart_button(butt_i_ui, do_italics);
			function do_italics(e:*= null):void {
				trace("Selection from " + textbox.selectionBeginIndex + " to " + textbox.selectionEndIndex);
			}
			container.addChild(butt_i);
			
			butt_i.addEventListener(MouseEvent.CLICK, ItalicClick);
			
			
		function ItalicClick(e:MouseEvent):void {
			currentText = txt.text;
			currentSelect = currentText.substring(txt.selectionBeginIndex, txt.selectionEndIndex);
			beforeSelect = currentText.substring(0, txt.selectionBeginIndex);
			afterSelect = currentText.substring(txt.selectionEndIndex);
			txt.text = beforeSelect + " <i>" + currentSelect + "</i>" + afterSelect;
						
			}	
			
			
			var butt_b_ui:Button = new Button();
			butt_b_ui.label = "B";
			butt_b_ui.setSize(20, 20);
			butt_b_ui.x = butt_u_ui.width + butt_i_ui.width + 15;
			butt_b_ui.y = 10;
			var butt_b:smart_button = new smart_button(butt_b_ui, do_Bold);
			function do_Bold(e:*= null):void {
				trace("Selection from " + textbox.selectionBeginIndex + " to " + textbox.selectionEndIndex);
			}
			container.addChild(butt_b);
			
			
			butt_b.addEventListener(MouseEvent.CLICK, BoldClick);
			
			
		function BoldClick(e:MouseEvent):void {
			currentText = txt.text;
			currentSelect = currentText.substring(txt.selectionBeginIndex, txt.selectionEndIndex);
			beforeSelect = currentText.substring(0, txt.selectionBeginIndex);
			afterSelect = currentText.substring(txt.selectionEndIndex);
			txt.text = beforeSelect + " <b>" + currentSelect + "</b>" + afterSelect;
						
			}	
			
			
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