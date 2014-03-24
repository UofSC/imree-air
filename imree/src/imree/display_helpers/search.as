package imree.display_helpers {
	import com.greensock.events.LoaderEvent;
	import fl.controls.Button;
	import flash.display.Sprite;
	import imree.forms.f_element_text;
	import imree.Main;
	import imree.shortcuts.box;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class search extends Sprite {
		
		public var onSelect:Function;
		private var w:int;
		private var h:int;
		private var wrapper:Sprite;
		private var main:Main;
		private var search_box:f_element_text;
		private var search_submit:smart_button;
		public function search(_onSelect:Function, _main:Main, _w:int = 300, _h:int = 300) {
			onSelect = _onSelect;
			main = _main;
			w = _w;
			h = _h;
		}
		public function draw_search_box():void {
			main.clean_slate([wrapper, search_box, search_submit]);
			wrapper = new Sprite();
			addChild(wrapper);
			wrapper.addChild(new box(w, h, 0xFF00FF, .5));
			
			search_box = new f_element_text("Search", 'some_search_val');
			wrapper.addChild(search_box);
			search_box.draw();
			search_box.x = 10; 
			search_box.y = 10;
			var search_submit_button:Button = new Button();
			search_submit_button.label = "Submit Search";
			search_submit = new smart_button(search_submit_button, submit);
			wrapper.addChild(search_submit);
			search_submit.x = 10;
			search_submit.y = search_box.height + 20;
		}
		
		public function submit(e:*=null):void {
			trace("Query Started with " + search_box.get_value());
			main.connection.server_command("search", search_box.get_value(), results, true);
		}
		
		private function results(e:LoaderEvent):void {
			var xml:XML = XML(e.target.content);
			trace(xml);
		}
		
	}

}