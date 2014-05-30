package imree.forms 
{
	/**
	 * ...
	 * @author Jason Steelman, Tabitha Samuel
	 */
	
	import fl.controls.NumericStepper;
	import flash.display.DisplayObject;
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
		
		private var special_height:int;
		override public function draw(label_width:int = 100, input_w:int = 200, padding:int = 50 ):void {
			ui = new Sprite();
			addChild(ui);
			

			var label_display:text = new text(label, label_width);
			
			label_display.y += 5;
			ui.addChild(label_display);
			
			var internal_padding:int = Math.round(padding / 2);
			var stepper_width:int = 80;
			var stepper_height:int = 40;
			
			special_height = stepper_height + 30;
			
			var txtyr_lab:text = new text("Year");
			txtyr = new NumericStepper();
			txtyr.minimum = -9999;
			txtyr.maximum = 9999;
			txtyr.value = 1883;
				
			var txtmo_lab:text = new text("Month");
			txtmo= new NumericStepper();
			txtmo.minimum = 1;
			txtmo.maximum = 12;
			txtmo.value = 1;
			
			var txtdate_lab:text = new text("Day");
			txtdate = new NumericStepper();
			txtdate.minimum = 1;
			txtdate.maximum = 31;
			txtdate.value = 1;
			
			var txthr_lab:text = new text("Hour(s)");
			txthr = new NumericStepper();
			txthr.minimum = 1;
			txthr.maximum = 24;
			txthr.value = 1;
			
			var txtmin_lab:text = new text("Minute(s)");
			txtmin = new NumericStepper();
			txtmin.minimum = 0;
			txtmin.maximum = 59;
			txtmin.value = 0;
			
			var txtsec_lab:text = new text("Second(s)");
			txtsec = new NumericStepper();
			txtsec.minimum = 0;
			txtsec.maximum = 59;
			txtsec.value = 0;
			
			var labels:Vector.<DisplayObject> = new Vector.<DisplayObject>();
			labels.push(txtyr_lab, txtmo_lab, txtdate_lab, txthr_lab, txtmin_lab, txtsec_lab);
			var inputs:Vector.<NumericStepper> = new Vector.<NumericStepper>();
			inputs.push(txtyr, txtmo, txtdate, txthr, txtmin, txtsec);
			
			for (var i:int = 0; i < inputs.length; i++) {
				inputs[i].setSize(stepper_width, stepper_height);
				ui.addChild(labels[i]);
				ui.addChild(inputs[i]);
				labels[i].x = label_width + (i * (stepper_width + 10));
				inputs[i].x = label_width + (i * (stepper_width + 10));
				inputs[i].y = labels[i].height;
			}
			
			super.draw(label_width, input_w, padding);
		}
		
		override public function get_height():Number 
		{
			return special_height;
			
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
			if(txtyr !== null) {
				txtyr.enabled = false;
				txtmo.enabled = false;
				txtdate.enabled = false;
				txthr.enabled = false;
				txtmin.enabled = false;
				txtsec.enabled = false;		
			}			
			//set each numberic stepper to: stepper:NumericStepper().enabled = false;
			//stepper_year.enabled = false;
		}
		override public function set_enabled():void {
			//stepper_year.enabled = true;
			if(txtyr !== null) {
				txtyr.enabled = true;
				txtmo.enabled = true;
				txtdate.enabled = true;
				txthr.enabled = true;
				txtmin.enabled = true;
				txtsec.enabled = true;
			}
		}
	}

}