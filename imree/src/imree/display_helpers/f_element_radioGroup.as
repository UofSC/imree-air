package imree.display_helpers 
{
	/**
	 * ...
	 * @author Jason Steelman
	 */
	
	import fl.controls.ComboBox;
	import fl.controls.RadioButton;
	import fl.controls.RadioButtonGroup;
	import fl.data.DataProvider;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
	import flash.text.TextFieldAutoSize;
	import imree.data_helpers.data_value_pair;
	import imree.display_helpers.f_element;
	import imree.shortcuts.box;
	import imree.text;
	import imree.textFont;
	
	public class f_element_radioGroup extends f_element
	{
		private var group:RadioButtonGroup;
		private var special_height:int;
		public function f_element_radioGroup(_label:String, _data_column_name:String, _options:Vector.<data_value_pair>, unselected_value:*=null) {
			this.label = _label;
			this.data_column_name = _data_column_name;
			this.value = unselected_value;
			this.options = _options;
			super();
		}
		
		override public function draw(label_width:int = 100, input_w:int = 200, padding:int = 10 ):void {
			ui = new Sprite();
			
			var label_display:text = new text(this.label, label_width, this.label_textFont);
			label_display.y += 5;
			ui.addChild(label_display)
			
			group = new RadioButtonGroup('buttonGroup');
			var y1:int = 0;
			for each(var i:data_value_pair in options) {
				var butt:RadioButton = new RadioButton();
				butt.value = i.value;
				butt.label = i.label;
				butt.group = group;
				butt.x = label_width + padding;
				butt.y = y1;
				y1 += butt.height + padding / 2;
				ui.addChild(butt);
			}
			special_height = y1 + padding / 2;
			super.draw();
		}
		
		override public function get_value():* {
			return group.selectedData;
		}
		override public function get_height():Number {
			return special_height;
		}
		
		
		
	}

}