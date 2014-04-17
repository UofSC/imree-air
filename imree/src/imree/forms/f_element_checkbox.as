package imree.forms 
{
	/**
	 * ...
	 * @author Jason Steelman
	 */
	
	import fl.controls.CheckBox;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
	import flash.text.TextFieldAutoSize;
	import imree.forms.f_element;
	import imree.shortcuts.box;
	import imree.text;

	
	public class f_element_checkbox extends f_element
	{
		private var special_height:Number;
		public function f_element_checkbox(_label:String, _data_column_name:String, _value:Boolean=false) {
			this.label = _label;
			this.value = value;
			this.data_column_name = _data_column_name;
			this.initial_val = _value;
			super();
		}
		
		override public function draw(label_width:int = 100, input_w:int = 200, padding:int = 10 ):void {
			ui = new Sprite();
			
			var label_display:text = new text(this.label, label_width, this.label_textFont);
			label_display.y += 5;
			ui.addChild(label_display)
			special_height = label_display.height;
			var chk:CheckBox = new CheckBox();
			component = chk;
			chk.x = label_width + padding;
			chk.label = "";
			if (value) {
				chk.selected = true;
			} else {
				chk.selected = false;
			}
			
			ui.addChild(chk);
			super.draw();
		}
		override public function get_value():* {
			return CheckBox(component).selected;
		}
		override public function get_height():Number {
			return Math.max(special_height, 20);
		}
	}

}