package imree.display_helpers 
{
	/**
	 * ...
	 * @author Jason Steelman
	 */
	
	import fl.controls.ComboBox;
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
	
	public class f_element_select extends f_element
	{
		private var special_height:Number;
		private var prompt:String;
		private var unselected_value:*;
		public function f_element_select(_label:String, _data_column_name:String, _options:Vector.<data_value_pair>, _prompt:String = null, _unselected_value:*=null) {
			this.label = _label;
			data_column_name = _data_column_name;
			prompt = _prompt;
			this.unselected_value = _unselected_value;
			if (prompt === null) {
				this.value = _options[0].value;
			} else {
				this.value = _unselected_value;
			}
			this.options = _options;
			super();
		}
		
		override public function draw(label_width:int = 100, input_w:int = 200, padding:int = 10 ):void {
			ui = new Sprite();
			
			var label_display:text = new text(this.label, label_width, this.label_textFont);
			label_display.y += 5;
			ui.addChild(label_display);
			
			var dat:Array = [];
			for each(var i:data_value_pair in options) {
				dat.push( {label:i.label.toString(), data:i.value } );
			}
			
			var combo:ComboBox = new ComboBox();
			component = combo;
			combo.width = input_w;
			combo.x = label_width + padding;
			special_height = combo.height; //height before items added
			if (prompt === null) {
				combo.selectedIndex = 0;
			} else {
				combo.prompt = prompt;
			}
			combo.dataProvider = new DataProvider(dat);
			
			ui.addChild(combo);
			super.draw();
		}
		
		override public function get_value():* {
			if (ComboBox(component).selectedItem === null) {
				return unselected_value;
			} else {
				return ComboBox(component).selectedItem.data;
			}
		}
		override public function get_height():Number {
			return special_height;
		}
		
	}

}