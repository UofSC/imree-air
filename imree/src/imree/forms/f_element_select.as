package imree.forms 
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
	import flash.utils.getQualifiedClassName;
	import imree.data_helpers.data_value_pair;
	
	import imree.forms.*;
	import imree.shortcuts.box;
	import imree.text;
	import imree.textFont;
	
	public class f_element_select extends f_element
	{
		private var special_height:Number;
		private var prompt:String;
		private var unselected_value:*;
		private var dynamic_options:f_element_DynamicOptions;
		public function f_element_select(_label:String, _data_column_name:String, _options:Object, _prompt:String = null, _value:*=null) {
			this.label = _label;
			data_column_name = _data_column_name;
			prompt = _prompt;
			this.unselected_value = _value;
			this.initial_val = _value;
			if (prompt === null) {
				this.value = _options[0].value;
			} else {
				this.value = _value;
			}
			trace(getQualifiedClassName(_options));
			if (getQualifiedClassName(_options) == "imree.forms::f_element_select_DynamicOptions") {
				this.dynamic_options = f_element_DynamicOptions(_options);
			} else {
				this.options = Vector.<data_value_pair>(_options);
			}
			super();
		}
		
		override public function draw(label_width:int = 100, input_w:int = 200, padding:int = 10 ):void {
			ui = new Sprite();
			
			var label_display:text = new text(this.label, label_width, this.label_textFont);
			label_display.y += 5;
			ui.addChild(label_display);
			
			var combo:ComboBox = new ComboBox();
			component = combo;
			combo.width = input_w;
			combo.x = label_width + padding;
			special_height = combo.height; //height before items added
			
			
			var dat:Array = [];
			for each(var i:data_value_pair in options) {
				dat.push( {label:i.label.toString(), data:i.value } );
			}
			if (prompt === null) {
				combo.selectedIndex = 0;
			} else {
				combo.prompt = prompt;
			}
			
			
			combo.dataProvider = new DataProvider(dat);
			loader_x = combo.x + combo.width + 2;
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
		
		override public function set_value(e:*):void {
			for (var i:int = 0; i < ComboBox(component).dataProvider.length; i++ ) {
				if (e == ComboBox(component).dataProvider.getItemAt(i).data) {
					ComboBox(component).selectedIndex = i;
				}
			}
			super.set_value(e);
		}
		override public function element_ready():Boolean {
			return dynamic_options == null || dynamic_options.is_ready;
		}
		
	}

}