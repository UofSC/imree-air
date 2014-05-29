package imree.forms
{
	/**
	 * ...
	 * @author  Tonya Holladay
	 */
	
	import com.adobe.utils.StringUtil;
	//import com.demonsters.debugger.MonsterDebugger;
	import fl.containers.BaseScrollPane;
	import fl.containers.ScrollPane;
	import fl.controls.Button;
	import fl.controls.ScrollPolicy;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
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
		
		public var textbox:TextField;
		override public function draw(label_width:int = 100, input_w:int = 200, padding:int = 10):void {
			ui = new Sprite();
			
			var label_display:text = new text(this.label, label_width, this.label_textFont);
			label_display.y += 5;
			ui.addChild(label_display)
			
			var currentText:String;
			var currentSelect:String;
			var beforeSelect:String;
			var afterSelect:String;
			
			var dumb_prepend:String = '<P ALIGN="LEFT"><FONT FACE="_sans" SIZE="16" COLOR="#000000" LETTERSPACING="0" KERNING="0">';
			var dumb_append:String = "</font></p>";
			
			
			var inputFormat:TextFormat = new TextFormat('_sans', input_element_fontSize);
			
			textbox = new TextField();
			textbox.setTextFormat(inputFormat);
			textbox.type = TextFieldType.INPUT;
			textbox.background = false;
			textbox.multiline = true;
			textbox.condenseWhite = true;
			textbox.htmlText = "<p>" + initial_val + "</p>";
			trace(textbox.htmlText);
			textbox.defaultTextFormat = inputFormat;
			
			textbox.wordWrap = true;
			//textbox.autoSize = TextFieldAutoSize.LEFT;
			textbox.height = 200; 
			textbox.width = input_w;
			txt = textbox;
			loader_x = label_width;
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = inputFormat;
			trace(txt.textHeight / Number(myFormat.size));
			
			var scroller:ScrollPane = new ScrollPane();
			scroller.setSize(input_w + 20, 200);
			scroller.source = textbox;
			var background:box = new box(input_w +10, 200, 0xFFFFFF, 1, 1, 0x000000);
			background.x = label_width + 5;
			background.y = 25;
			ui.addChild(background);
			ui.addChild(scroller);
			scroller.x = label_width + 10;
			scroller.y = 30;
			scroller.update();
			scroller.horizontalScrollPolicy = ScrollPolicy.OFF
			scroller.verticalScrollPolicy = ScrollPolicy.AUTO;
			textbox.addEventListener(TextEvent.TEXT_INPUT, update_scroller);
			function update_scroller(e:Event):void {
				scroller.update();
			}
			
			var butt_u_ui:Button = new Button();
			butt_u_ui.label = "U";
			butt_u_ui.setSize(20, 20);
			butt_u_ui.x = label_width + 5;
			butt_u_ui.y = 0;
			ui.addChild(butt_u_ui);
			butt_u_ui.addEventListener(MouseEvent.CLICK, UnderlineClick);
			function UnderlineClick(e:MouseEvent):void {
				//replace_with("u");
				var t:TextFormat = new TextFormat;
				var s:int = txt.selectionBeginIndex;
				var f:int = txt.selectionEndIndex;
				if (s != f) {
					t = txt.getTextFormat(s, f);
					t.underline ? t.underline = false : t.underline = true;
					txt.setTextFormat(t, s, f);
				}
			}
			
			var butt_i_ui:Button = new Button();
			butt_i_ui.label = "I";
			butt_i_ui.setSize(20, 20);
			butt_i_ui.x = butt_u_ui.x + butt_u_ui.width + 5;
			butt_i_ui.y = 0;
			ui.addChild(butt_i_ui);
			butt_i_ui.addEventListener(MouseEvent.CLICK, ItalicClick);
			function ItalicClick(e:MouseEvent):void {
				//replace_with("i");
				var t:TextFormat = new TextFormat;
				var s:int = txt.selectionBeginIndex;
				var f:int = txt.selectionEndIndex;
				if (s != f) {
					t = txt.getTextFormat(s, f);
					t.italic ? t.italic = false : t.italic = true;
					txt.setTextFormat(t, s, f);
				}
			}
			
			var butt_b_ui:Button = new Button();
			butt_b_ui.label = "B";
			butt_b_ui.setSize(20, 20);
			butt_b_ui.x = butt_i_ui.x + butt_i_ui.width + 5;
			butt_b_ui.y = 0;
			ui.addChild(butt_b_ui);
			butt_b_ui.addEventListener(MouseEvent.CLICK, BoldClick);
			function BoldClick(e:MouseEvent):void {
				//replace_with("b");
				var t:TextFormat = new TextFormat;
				var s:int = txt.selectionBeginIndex;
				var f:int = txt.selectionEndIndex;
				if (s != f) {
					t = txt.getTextFormat(s, f);
					t.bold ? t.bold = false : t.bold = true;
					txt.setTextFormat(t, s, f);
				}
			}
			
			/**
			function replace_with(format:String):void {
				var dumb_prepend:String = "<p align=\"LEFT\"><font face=\"Times New Roman\" size=\"12\" color=\"#000000\" letterspacing=\"0\" kerning=\"0\">";
				var dumb_append:String = "</font></p>";
				currentText = txt.htmlText.substr(dumb_prepend.length, txt.htmlText.length - dumb_prepend.length - dumb_append.length);
				var positions:Array = get_tag_lengths(currentText);
				trace(currentText.substr(positions[txt.selectionBeginIndex - 1] + 1, 3));
				if (currentText.substr(positions[txt.selectionBeginIndex - 1] + 1, 3) == "<" + String(format).toLowerCase() + ">" && currentText.substr(positions[txt.selectionEndIndex - 1] + 1, 4) == "</" + format + ">")	{
					trace("we're removing <u> and </u> from <u>...</u>");
					currentSelect = currentText.substring(positions[txt.selectionBeginIndex], positions[txt.selectionEndIndex]);
					beforeSelect = currentText.substring(0, positions[txt.selectionBeginIndex]);
					afterSelect = currentText.substring(positions[txt.selectionEndIndex]);
					initial_val = beforeSelect + currentSelect + afterSelect;
				} else {
					//we're adding <u>...</u>
					currentSelect = currentText.substring(positions[txt.selectionBeginIndex], positions[txt.selectionEndIndex]);
					beforeSelect = currentText.substring(0, positions[txt.selectionBeginIndex]);
					afterSelect = currentText.substring(positions[txt.selectionEndIndex]);
					initial_val = beforeSelect + "<" + format + ">" + currentSelect + "</" + String(format).toLowerCase() + ">" + afterSelect;
				}
				ui = null;
				draw(label_width, input_w, padding);
			}
			
			function get_tag_lengths(xstr:String):Array {
				var Arr:Array = new Array();
				for (var current_pos:int = 0; current_pos < xstr.length; current_pos++) {
					if (xstr.substr(current_pos, 1) === "<") {
						if (xstr.substr(current_pos, 1) === "</") {
							current_pos += 4;
						} else {
							current_pos += 3;
						}
					} else {
						Arr.push(current_pos);
					}
				}
				return Arr;
			}
			*/
			super.draw(label_width, input_w, padding);
		
		}
		
		override public function get_value():* {
			var dumb_prepend:String = '<P ALIGN="LEFT"><FONT FACE="_sans" SIZE="16" COLOR="#000000" LETTERSPACING="0" KERNING="0">';
			var dumb_append:String = "</font></p>";
			return textbox.htmlText.substr(dumb_prepend.length, textbox.htmlText.length - dumb_prepend.length - dumb_append.length);
			
		}
		
		override public function set_value(e:*):void {
			var dumb_prepend:String = '<P ALIGN="LEFT"><FONT FACE="_sans" SIZE="16" COLOR="#000000" LETTERSPACING="0" KERNING="0">';
			var dumb_append:String = "</font></p>";
			txt.htmlText = dumb_prepend + String(e) + dumb_append;
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
		
		override public function get_height():Number 
		{
			return 240;
		}
	}
}
