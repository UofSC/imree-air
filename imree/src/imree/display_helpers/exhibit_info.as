package imree.display_helpers {
	import fl.containers.ScrollPane;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import imree.data_helpers.Theme;
	import imree.Main;
	import imree.shortcuts.box;
	import imree.text;
	
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class exhibit_info extends Sprite {
		public var string:String
		public var main:Main;
		private var background:box;
		public function exhibit_info(_main:Main, str:String) {
			main = _main;
			string = str;
			var t:exhibit_info = this;
			
			background= new box(main.Imree.staging_area.width, main.Imree.staging_area.height, Theme.background_color_primary, .8);
			var foreground:box = new box(main.Imree.staging_area.width * .8, main.Imree.staging_area.height * .8, Theme.background_color_secondary, 1);
			var close_btn:button_back = new button_back();
			main.Imree.UI_size(close_btn);
			var window_title:text = new text(main.Imree.Exhibit.exhibit_name, foreground.width - 20 - close_btn.width, Theme.font_style_h3);
			var window_content:text = new text(string, foreground.width - 35, Theme.font_style_description);
			var window_scroller:ScrollPane = new ScrollPane();
			window_scroller.setSize(foreground.width, foreground.height - window_title.height - 15);
			window_scroller.source = window_content;
			window_scroller.update();
			
			addChild(background);
			addChild(foreground);
			foreground.addChild(window_title);
			foreground.addChild(close_btn);
			foreground.addChild(window_scroller);
			
			foreground.center(background);
			close_btn.x = foreground.width - close_btn.width;
			window_title.x = 10; 
			window_title.y = 10;
			window_content.x = 10;
			window_scroller.y = window_title.height + 15;
			
			close_btn.addEventListener(MouseEvent.CLICK, close);
			background.addEventListener(MouseEvent.CLICK, close);
			function close(e:MouseEvent):void {
				background.removeEventListener(MouseEvent.CLICK, close);
				close_btn.removeEventListener(MouseEvent.CLICK, close);
				main.Imree.Exhibit.overlay_remove();
			}
			main.Imree.Exhibit.overlay_add(this);
			
			
			
			
		}
		
	}

}