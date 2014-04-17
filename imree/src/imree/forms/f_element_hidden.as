package imree.forms 
{
	/**
	 * ...
	 * @author Jason Steelman
	 */
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
	import flash.text.TextFieldAutoSize;
	import imree.forms.f_element;
	import imree.shortcuts.box;
	
	public class f_element_hidden extends f_element
	{
		
		public function f_element_hidden(_label:String, _data_column_name:String, _value:String = "") {
			this.label = _label;
			this.value = value;
			this.data_column_name = _data_column_name;
			this.initial_val = _value;
			super();
		}
		
		override public function draw(label_width:int = 100, input_w:int = 200, padding:int = 10 ):void {
			ui = new Sprite();
			super.draw();
			this.visible = false;
		}
		override public function set_disable():void {}
		override public function set_enabled():void {}
	}

}