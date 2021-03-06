package imree.forms 
{
	/**
	 * ...
	 * @author Jason Steelman
	 */
	
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import flash.display.Sprite;
	import flash.events.Event;
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
		
		public function f_element_select(_label:String, _data_column_name:String, _options:Vector.<data_value_pair> = null, _prompt:String = null, _value:*=null) {
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
			if (_options) {
				this.options = Vector.<data_value_pair>(_options);
			}
			super();
		}
		
		override public function draw(label_width:int = 100, input_w:int = 200, padding:int = 10 ):void {
			if (getChildByName("ui")) {
				removeChild(getChildByName("ui"));
			}
			ui = new Sprite();
			ui.name = "ui";

			var label_display:text = new text(this.label, label_width, this.label_textFont);
			label_display.y += 5;
			ui.addChild(label_display);
			
			var combo:ComboBox = new ComboBox();
			component = combo;
			combo.width = input_w;
			combo.x = label_width + padding;
			special_height = combo.height + 15; //height before items added
			
			if(options !== null) {
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
				if (value) {
					set_value(value);
				}
			} else {
				combo.prompt = "Loading...";
			}
			loader_x = combo.x + combo.width + 2;
			ui.addChild(combo);
			
			if (onChange !== null) {
				combo.addEventListener(Event.CHANGE, onChange);
			}
			
			super.draw();
		}
		
		override public function get_value():* {
			if (ComboBox(component).selectedItem === null) {
				return unselected_value;
			} else {
				return String(ComboBox(component).selectedItem.data);
			}
		}
		override public function get_height():Number {
			return special_height;
		}
		
		override public function set_value(e:*):void {
			for (var i:int = 0; i < ComboBox(component).dataProvider.length; i++ ) {
				if (String(e) == String(ComboBox(component).dataProvider.getItemAt(i).data)) {
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