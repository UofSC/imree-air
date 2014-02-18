package imree.display_helpers 
{
	/**
	 * ...
	 * @author Jason Steelman
	 */
	import fl.controls.Button;
	import fl.controls.BaseButton;
	import fl.events.ComponentEvent;
	import flash.display.Sprite;
	import imree.data_helpers.data_value_pair;
	import imree.display_helpers.f_element;
	import imree.shortcuts.box;
	
	public class f_data extends Sprite
	{
		public var elements:Vector.<f_element>;
		public var w:int;
		public var h:int;
		public var background_color:uint
		public var base_font_size:int;
		public var use_submit_btn:Boolean;
		public var onSubmit:Function;
		private var t:f_data;
		public function f_data(_elements:Vector.<f_element>, _onSubmit:Function=null, _base_font_size:int = 16, _width:int = 300, _height:int = 300) 
		{
			t = this;
			elements = _elements;
			w = _width;
			h = _height;
			background_color =  0xFFFFFF;;
			base_font_size = _base_font_size;
			use_submit_btn = true;
			onSubmit = _onSubmit;
		}
		public function draw():void {
			var j:int = 0;
			for each(var i:f_element in t.elements) {
				i.draw();
				i.x = 10;
				i.y = j;
				j += i.get_height() + 10;
				t.addChild(i);
			}
			if (use_submit_btn) {
				var btn:Button = new Button();
				btn.label = "Submit";
				btn.x = 10;
				btn.y = j;
				btn.addEventListener(ComponentEvent.BUTTON_DOWN, submit);
				t.addChild(btn);
			}
		}
		public function submit(e:*=null):void {
			if (onSubmit === null) {
				trace("Form Submitted without onSubmit listener");
				for each(var i:f_element in elements) {
					trace("\t" + i.label + ": " + i.get_value());
				}
			} else {
				var values:Object = new Object();
				for each (var j:f_element in elements) {
					values[j.data_column_name] = j.get_value();
				}
				onSubmit(values);
			}
		}
		
	}

}