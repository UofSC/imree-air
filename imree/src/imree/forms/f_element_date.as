package imree.forms 
{
	/**
	 * ...
	 * @author Jason Steelman
	 */
	
	import fl.controls.NumericStepper;
	import flash.display.Sprite;
	import flash.events.DRMCustomProperties;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
	import flash.text.TextFieldAutoSize;
	import imree.data_helpers.date_from_mysql;
	import imree.display_helpers.*;
	import imree.shortcuts.box;
	import imree.text;
	import imree.textFont;
	
	
	public class f_element_date extends f_element
	{
		public var txtyr:NumericStepper;
		public var txtmo:NumericStepper;
		public var txtdate:NumericStepper;
		public var txthr:NumericStepper;
		public var txtmin:NumericStepper;
		public var txtsec:NumericStepper;
		public function f_element_date(_label:String, _data_column_name:String, _value:String = "") {
			label = _label;
			value = _value;
			initial_val = _value;
			data_column_name = _data_column_name;
			super();
		
				
		}
		
		override public function draw(label_width:int = 100, input_w:int = 200, padding:int = 10 ):void {
			ui = new Sprite();
			addChild(ui);
			
			//This is a simple way to make text
			var special_font:textFont = new textFont('_sans', 12);
			var label_display:text = new text(this.label, label_width, this.special_font);
			
			label_display.y += 5;
			ui.addChild(label_display);
			
			var internal_padding:int = Math.round(padding / 2);
			var stepper_width:int = input_w / 3 - internal_padding;
			var stepper_height:int = 20;
			
			txtyr = new NumericStepper();
			txtyr.setSize(stepper_width, stepper_height);
			txtyr.x = label_width + padding;
			txtyr.stepSize = 1;
			txtyr.minimum = -9999;
			txtyr.maximum = 9999;
			txtyr.value = 1883;
			ui.addChild(txtyr);
			
			txtmo= new NumericStepper();
			txtmo.setSize(stepper_width, stepper_height);
			txtmo.x = txtyr.x + stepper_width + internal_padding;
			txtmo.minimum = 1;
			txtmo.maximum = 12;
			txtmo.stepSize = 1;
			ui.addChild(txtmo);
			
			
			txtdate = new NumericStepper();
			txtdate.setSize(stepper_width, stepper_height);
			txtdate.x = txtmo.x + stepper_width + internal_padding;
			txtdate.minimum = 1;
			txtdate.maximum = 31;
			txtdate.stepSize = 1;
			ui.addChild(txtdate);
			
			
			txthr = new NumericStepper();
			txthr.setSize(stepper_width, stepper_height);
			txthr.x = label_width + padding;
			txthr.y = stepper_height + internal_padding;
			txthr.minimum = 1;
			txthr.maximum = 23;
			txthr.stepSize = 1;
			ui.addChild(txthr);
			
			
			txtmin = new NumericStepper();
			txtmin.setSize(stepper_width, stepper_height);
			txtmin.x = txthr.x + stepper_width + internal_padding;
			txtmin.y = stepper_height + internal_padding;
			txtmin.minimum = 0;
			txtmin.maximum = 59;
			txtmin.stepSize = 1;
			ui.addChild(txtmin);
			
			
			txtsec = new NumericStepper();
			txtsec.setSize(stepper_width, stepper_height);
			txtsec.x = txtmin.x + stepper_width + internal_padding;
			txtsec.y = stepper_height + internal_padding;
			txtsec.minimum = 0;
			txtsec.maximum = 59;
			txtsec.stepSize = 1;
			ui.addChild(txtsec);
			
			
			/**
			stepper_year.addChild (txtyr);
			//stepper_year.addEventListener("change", txtyr);
			
			stepper_month.addChild(txtmo);
			//stepper_month.addEventListener("change", txtmo);
			
			stepper_day.addChild(txtdate);			
			//stepper_day.addEventListener("change", txtday);
			
			stepper_hours.addChild(txthr);
			//stepper_hours.addEventListener("change", txthr);
			
			stepper_minutes.addChild(txtmin);
			//stepper_minutes.addEventListener("change", txtmin);
			
			stepper_seconds.addChild(txtsec);
			//stepper_seconds.addEventListener("change", txtsec);
			
			ui.addchild = (stepper_year + stepper_month + stepper_day + stepper_hours + stepper_minutes + stepper_seconds);
			*/
			
			
			super.draw(label_width, input_w, padding);
		}
		
		
		override public function get_value():* {
			
			
				//return (stepper_year.value + "/" + stepper_month.value + "/" + stepperday.value + " " + stepper_hours.value + ":" + stepper_minutes.value + ":" + stepper_seconds.value);
			
			return null;
		}
		override public function set_value(e:*):void {
			var date_parser:date_from_mysql = new date_from_mysql();
			var new_date:Date = date_parser.string_to_date(String(e));
			trace(new_date);
			txtyr.value = new_date.fullYear;
			
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