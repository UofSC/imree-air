package imree.display_helpers {
	import com.greensock.events.LoaderEvent;
	import com.greensock.TweenLite;
	import fl.containers.ScrollPane;
	import fl.controls.Button;
	import flash.display.Sprite;
	import imree.data_helpers.position_data;
	import imree.forms.f_element_text;
	import imree.images.loading_spinner_sprite;
	import imree.layout;
	import imree.Main;
	import imree.shortcuts.box;
	import imree.text;
	import imree.textFont;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class search extends Sprite {
		
		public var onSelect:Function;
		private var w:int;
		private var h:int;
		private var wrapper:Sprite;
		private var search_ui_wrapper:Sprite;
		private var main:Main;
		private var search_box:f_element_text;
		private var search_submit:smart_button;
		private var spinner:loading_spinner_sprite;
		public function search(_onSelect:Function, _main:Main, _w:int = 300, _h:int = 300) {
			onSelect = _onSelect;
			main = _main;
			w = _w;
			h = _h;
		}
		public function draw_search_box():void {
			main.clean_slate([wrapper, search_box, search_submit, search_ui_wrapper]);
			wrapper = new Sprite();
			search_ui_wrapper = new Sprite();
			addChild(wrapper);
			wrapper.addChild(new box(w, h, 0x0000ff, .8));
			wrapper.addChild(search_ui_wrapper);
			search_box = new f_element_text("Search", 'some_search_val');
			search_ui_wrapper.addChild(search_box);
			search_box.draw();
			
			search_ui_wrapper.y = h / 2;
			search_ui_wrapper.x = main.stage.stageWidth / 2 - search_box.width / 2;
			
			var search_submit_button:Button = new Button();
			search_submit_button.setSize(100, 40);
			search_submit_button.label = "Submit Search";
			search_submit = new smart_button(search_submit_button, submit);
			search_ui_wrapper.addChild(search_submit);
			search_submit.x = search_box.width + 10;
		}
		
		public function submit(e:*=null):void {
			trace("Query Started with " + search_box.get_value());
			if (spinner === null ) {
				spinner = new loading_spinner_sprite(60);
				search_ui_wrapper.addChild(spinner);
				search_submit.visible = false;
				spinner.x = search_submit.x;
			}
			
			main.connection.server_command("search", search_box.get_value(), results, true);
		}
		
		private function results(e:LoaderEvent):void {
			if (spinner !== null) {
				search_ui_wrapper.removeChild(spinner);
				spinner = null;
				search_submit.visible = true;
			}
			TweenLite.to(search_ui_wrapper, 1, { y:10 } );
			var xml:XML = XML(e.target.content);
			var scroller:ScrollPane = new ScrollPane();
			wrapper.addChild(scroller);
			var scroller_contents:Sprite = new Sprite();
			scroller.setSize (stage.stageWidth, stage.stageHeight - 95 - search_box.get_height()) - 20;
			scroller.source = scroller_contents;
			if (xml.result.children.children().length() == 0) {
				trace("no results");
			}
			var proxies:Vector.<position_data> = new Vector.<position_data>();
			for each(var x:XML in xml.result.children.children()) {
				proxies.push(new position_data(main.Imree.Device.box_size, main.Imree.Device.box_size));
			}
			var lay:layout = new layout();
			var positions:Vector.<position_data> = lay.abstract_box_solver(proxies, stage.stageWidth, stage.stageHeight * 999);
			for (var i:String in proxies) {
				var bk:box = new box(main.Imree.Device.box_size, main.Imree.Device.box_size, 0xF0F0F0, .2, 1);
				bk.addChild(new text(String(xml.result.children.children()[i].Title), main.Imree.Device.box_size));
				bk.x = positions[i].x;
				bk.y = positions[i].y;
				scroller_contents.addChild(bk);
			}
			scroller_contents.x = main.stage.stageWidth / 2 - scroller_contents.width / 2 - 20;
			scroller.update();
			scroller.x = search_box.get_height() + 20;
			
			
		}
		
	}

}