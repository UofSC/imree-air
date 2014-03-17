package imree.forms 
{
	/**
	 * ...
	 * @author Jason Steelman
	 */
	
	import fl.controls.NumericStepper;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
	import flash.text.TextFieldAutoSize;
	import imree.display_helpers.*;
	import imree.shortcuts.box;
	import imree.text;
	import imree.textFont;
	
	public class f_element_date extends f_element
	{
		private var stepper_year:NumericStepper;
		private var stepper_month:NumericStepper;
		private var stepper_day:NumericStepper;
		private var stepper_hours:NumericStepper;
		private var stepper_minutes:NumericStepper;
		private var stepper_seconds:NumericStepper;
		public function f_element_date(_label:String, _data_column_name:String, _value:String = "") {
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
			
			//we need 6 textfields : year, month, day, hour, min, sec. 
			//probably should be NumbericStepper();
			
			super.draw(label_width, input_w, padding);
		}
		override public function get_value():* {
			//read the values of all 6 input fields; and convert that into a mysql date
			//stepper values come from .value like this.stepper_day.value;
		}
		override public function set_value(e:*):void {
			
			super.set_value(e);
		}
		override public function set_disable():void {
			//set each numberic stepper to: stepper:NumericStepper().enabled = false;
			//stepper_year.enabled = false;
		}
		override public function set_enabled():void {
			//stepper_year.enabled = true;
		}
	}

}