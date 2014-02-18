package imree.display_helpers 
{
	import fl.core.UIComponent;
	import flash.display.Sprite;
	import imree.data_helpers.data_value_pair;
	import imree.text;
	import imree.textFont;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class f_element extends Sprite
	{
		public var type:String;
		public var data_column_name:String;
		public var label:String;
		public var label_textFont:textFont;
		public var input_element_fontSize:int;
		public var value:*;
		public var options:Vector.<data_value_pair>;
		public var ui:Sprite;
		public var component:UIComponent;
		private var t:f_element;
		
		public function f_element() {
			label_textFont = new textFont();
			input_element_fontSize = 16;
		}
		
		public function draw(label_width:int = 100, input_w:int = 200, padding:int = 10):void {
			addChild(ui);
		}
		public function get_value():* {
			return value;
		}
		public function get_height():Number {
			return height;
		}
	}

}