package imree.forms 
{
	/**
	 * ...
	 * @author Jason Steelman, Tabitha Samuel
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
	import imree.forms.f_element;
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
			t = f_element(this);
			super();
		
				
		}
		
		override public function draw(label_width:int = 100, input_w:int = 200, padding:int = 50 ):void {
			ui = new Sprite();
			addChild(ui);
			

			var label_display:text = new text(label, label_width);
			
			label_display.y += 5;
			ui.addChild(label_display);
			
			var internal_padding:int = Math.round(padding / 2);
			var stepper_width:int = 80;
			var stepper_height:int = 20;
			
			
			var txtyr_lab:text = new text("Year");
			ui.addChild(txtyr_lab);			
			txtyr_lab.x = label_width + 10;
			
			txtyr = new NumericStepper();
			txtyr.setSize(stepper_width, stepper_height);
			txtyr.x = txtyr_lab.x + txtyr_lab.width + 5;
			txtyr.minimum = -9999;
			txtyr.maximum = 9999;
			txtyr.value = 1883;
			ui.addChild(txtyr);			
			
			
			var txtmo_lab:text = new text("Month");
			ui.addChild(txtmo_lab);
			txtmo_lab.x = txtyr.x + txtyr_lab.width + 10;			
			
			txtmo= new NumericStepper();
			txtmo.setSize(stepper_width, stepper_height);
			txtmo.x = txtmo_lab.x + txtmo_lab.width + 5;
			txtmo.minimum = 1;
			txtmo.maximum = 12;
			ui.addChild(txtmo);		
			
			
			var txtdate_lab:text = new text("Day");
			txtdate_lab.x = txtmo.x +txtmo_lab.width + 10;
			ui.addChild(txtdate_lab);			
		
			txtdate = new NumericStepper();
			txtdate.setSize(stepper_width, stepper_height);
			txtdate.x = txtdate_lab.x + txtdate_lab.width + 5;
			txtdate.minimum = 1;
			txtdate.maximum = 31;
			ui.addChild(txtdate);
			
			
			var txthr_lab:text = new text("Hour(s)");
			ui.addChild(txthr_lab);
			txthr_lab.x = label_width + 10;			
			
			txthr = new NumericStepper();
			txthr.setSize(stepper_width, stepper_height);
			txthr.x = txthr_lab.x + txthr_lab.width + 5;
			txthr.y = stepper_height + internal_padding;
			txthr.minimum = 1;
			txthr.maximum = 24;
			ui.addChild(txthr);
			
			
			var txtmin_lab:text = new text("Minute(s)");
			ui.addChild(txtmin_lab);
			txtmin_lab.x = txthr.x + txthr_lab.width + 10;	
			
			txtmin = new NumericStepper();
			txtmin.setSize(stepper_width, stepper_height);
			txtmin.x = txtmin_lab.x + txtmin_lab.width + 5;
			txtmin.y = stepper_height + internal_padding;
			txtmin.minimum = 0;
			txtmin.maximum = 59;
			ui.addChild(txtmin);
			
			
			var txtsec_lab:text = new text("Second(s)");
			ui.addChild(txtsec_lab);
			txtsec_lab.x = txtmin.x +txtmin_lab.width + 10;
						
			txtsec = new NumericStepper();
			txtsec.setSize(stepper_width, stepper_height);
			txtsec.x = txtsec_lab.x + txtsec_lab.width + 5;
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
			
			ui.addChild = (stepper_year + stepper_month + stepper_day + stepper_hours + stepper_minutes + stepper_seconds);
			*/
			
			
			super.draw(label_width, input_w, padding);
		}
		
		
		override public function get_value():* {
			return (txtyr.value + "/" + txtmo.value + "/" + txtdate.value + " " + txthr.value + ":" + txtmin.value + ":" + txtsec.value);
			return null;
		}
		override public function set_value(e:*):void {
			var date_parser:date_from_mysql = new date_from_mysql();
			var new_date:Date = date_parser.string_to_date(String(e));
			trace(new_date);
			txtyr.value = new_date.fullYear;
			txtmo.value = new_date.month;
			txtdate.value = new_date.date;
			txthr.value = new_date.hours;
			txtmin.value = new_date.minutes;
			txtsec.value = new_date.seconds;
			
			super.set_value(e);
		}
		override public function set_disable():void {
			
			txtyr:NumericStepper().enabled = false;
			txtyr.enabled = false;
			
			txtmo:NumericStepper().enabled = false;
			txtmo.enabled = false;
			
			txtdate:NumericStepper().enabled = false;
			txtdate.enabled = false;
			
			txthr:NumericStepper().enabled = false;
			txthr.enabled = false;
			
			txtmin:NumericStepper().enabled = false;
			txtmin.enabled = false;
			
			txtsec:NumericStepper().enabled = false;
			txtsec.enabled = false;		
			
			//set each numberic stepper to: stepper:NumericStepper().enabled = false;
			//stepper_year.enabled = false;
		}
		override public function set_enabled():void {
			//stepper_year.enabled = true;
			
			txtyr.enabled = true;
			txtmo.enabled = true;
			txtdate.enabled = true;
			txthr.enabled = true;
			txtmin.enabled = true;
			txtsec.enabled = true;
		}
	}

}