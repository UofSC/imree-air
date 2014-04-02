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
	import imree.forms.*;
	import imree.shortcuts.box;
	import imree.text;
	import imree.textFont;
	
	public class f_element_password extends f_element_text
	{
		public function f_element_password(_label:String, _data_column_name:String, _value:String = "") {
			is_password = true;
			super(_label, _data_column_name, _value);
		}
		
	}

}