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
			ui.addChild(label_display);
								
			private var txtyr:NumericStepper = new TextField();
			txtyr.width = 25;
			txtyr.height = 15;
			txtyr.backgroundColor = (0xd7ccbe);
			txtyr.y = 400;
			txtyr.x = 300;
			txtyr.stepSize = 1;
						
			private var txtmo:NumericStepper = new TextField();
			txtmo.width = 10;
			txtmo.height = 15;
			txtmo.backgroundColor = (0xd7ccbe);
			txtmo.y = 400;
			txtmo.x = (txtyr.x) + 5;
			txtmo.minimum = 1;
			txtmo.maximum = 12;
			txtmo.stepSize = 1;
			
			if (txtmo.value < 10) {
				
				txtmo = "0" + txtmo;
			}
			
			private var txtdate: NumericStepper = new TextField();
			txtdate.width = txtmo.width;
			txtdate.height = txtmo.height;
			txtdate.backgroundColor = (0xd7ccbe);
			txtdate.y = 400;
			txtdate.x = (txtyr.x + txtmo.x) + 5;
			txtdate.minimum = 1;
			txtdate.maxiumum = 31;
			txtdate.stepSize = 1;
			
			if (txtdate.value < 10) {
				
				txtdate = "0" + txtdate;
			}
				
			private var txthr:NumericStepper = new TextField();
			txthr.width = txtmo.width;
			txthr.height = txtmo.height;
			txthr.backgroundColor = (0xd7ccbe);
			txthr.y = 400;
			txthr.x = (txtdate.x) + 15;
			txthr.minium = 1;
			txthr.maximum = 24;
			txthr.stepSize = 1;
			
			if (txthr.value < 10 ) {
				
				txthr = "0" + txthr;
			}
			
			private var txtmin:NumericStepper = new TextField();
			txtmin.width = txtmo.width;
			txtmin.height = txtmo.height;
			txtmin.backgroundColor = (0xd7ccbe);
			txtmin.y = 400;
			txtmin.x = (txthr.x) + 5;
			txtmin.minimum = 0;
			txtmin.maximum = 59;
			txtmin.stepSize = 1;
			
			if (txtmin.value < 10) {
				
				txtmin = "0" + txtmin;
			}
			
			private var txtsec: NumericStepper = new TextField();
			txtsec.width = txtmo.width;
			txtsec.height = txtmo.height;
			txtsec.backgroundColor = (0xd7ccbe);
			txtsec.y = 400;
			txtsec.x = (txtmin.x) + 5;
			txtsec.minimum = 0;
			txtsec.maximum = 59;
			txtsec.stepSize = 1;
			
			if (txtsec.value < 10) {
				
				txtsec = "0" + txtsec;
			}
			
			stepper_year.addChild (txtyr);
			stepper_year.addEventListener("change", txtyr);
			
			stepper_month.addChild(txtmo);
			stepper_month.addEventListener("change", txtmo);
			
			stepper_day.addChild(txtdate);			
			stepper_day.addEventListener("change", txtday);
			
			stepper_hours.addChild(txthr);
			stepper_hours.addEventListener("change", txthr);
			
			stepper_minutes.addChild(txtmin);
			stepper_minutes.addEventListener("change", txtmin);
			
			stepper_seconds.addChild(txtsec);
			stepper_seconds.addEventListener("change", txtsec);
			
			ui.addchild = (stepper_year + stepper_month + stepper_day + stepper_hours + stepper_minutes + stepper_seconds);
			
			
			
			super.draw(label_width, input_w, padding);
		}
		
		
		override public function get_value():* {
			
			function steppervalue(event:Event) {
				return (stepper_year.value + "/" + stepper_month.value + "/" + stepperday.value + " " + stepper_hours.value + ":" + stepper_minutes.value + ":" + stepper_seconds.value);
			}
			
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