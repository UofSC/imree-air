package imree.forms 
{
	import fl.core.UIComponent;
	import fl.events.ComponentEvent;
	import flash.display.Sprite;
	import imree.data_helpers.data_value_pair;
	import imree.images.loading_spinner_sprite;
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
		private var label_width:int;
		public var label:String;
		public var label_textFont:textFont;
		public var input_element_fontSize:int;
		public var value:*;
		public var options:Vector.<data_value_pair>;
		public var dynamic_options:f_element_DynamicOptions;
		public var ui:Sprite;
		public var component:UIComponent;
		public var initial_val:String;
		public var loader:loading_spinner_sprite;
		public var loader_x:int;
		public var enabled:Boolean;
		public var onChange:Function;
		public var t:f_element;
		
		public function f_element() {
			label_textFont = new textFont();
			input_element_fontSize = 16;
			enabled = true;
		}
		
		public function draw(_label_width:int = 100, input_w:int = 200, padding:int = 10):void {
			addChild(ui);
			label_width = _label_width;
			if (loader != null) {
				if (loader_x) {
					loader.x = loader_x;
				} else {
					loader.x = t.getBounds(t.parent).width + 2;
				}
			}
			
			if (loader != null) {
				addChildAt(loader, numChildren);
			}
			if (enabled) {
				set_enabled();
			} else {
				set_disable();
			}
			
		}
		public function get_value():* {
			return value;
		}
		public function get_height():Number {
			return height;
		}
		public function set_value(e:*):void {
			this.value = e;
		}
		public function indicate_waiting():void {
			loader = new loading_spinner_sprite(18);
			loader.x = label_width + 10;
			loader.y = 2;
			addChild(loader);
			set_disable();
		}
		public function indicate_ready():void {
			if (loader !== null) {
				loader.parent.removeChild(loader);
			}
			loader = null;
			set_enabled();
		}
		public function set_disable():void {
			enabled = false;
			if (component != null) {
				component.enabled = false;
			}
		}
		public function set_enabled():void {
			enabled = true;
			if (component != null) {
				component.enabled = true;
			}
		}
		public function element_ready():Boolean {
			return true;
		}
	}

}