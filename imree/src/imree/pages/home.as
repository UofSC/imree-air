package imree.pages 
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.layout.ScaleMode;
	import com.greensock.plugins.DropShadowFilterPlugin;
	import fl.containers.ScrollPane;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import imree.data_helpers.position_data;
	import imree.data_helpers.Theme;
	import imree.display_helpers.scrollPaneFancy;
	import imree.serverConnect;
	import flash.display.*;
	import flash.filters.DropShadowFilter;
	import imree.shortcuts.box;
	
	import flash.text.*;
	import imree.text;
	import imree.textFont;	
	import imree.*;
	
	import com.greensock.loading.data.ImageLoaderVars;
	import com.greensock.loading.ImageLoader;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class home extends Sprite
	{
		private var conn:serverConnect;
		public var xml:XML;
		public var onSelect:Function;
		public var main:Main;
		public function home(_w:int, _h:int, _conn:serverConnect, _main:Main) 
		{
			conn = _conn;
			conn.server_command("exhibits", "", exhibits_data_receieved);
			main = _main;
			
		}
		
		
		
		public function exhibits_data_receieved(e:LoaderEvent):void {
			main.preloader.hide();
			main.Imree.Menu.hide();
			xml = XML(e.target.content);
			
			
			var header_font:textFont = new textFont("AbrahamLincoln", 48);
			header_font.align = TextFormatAlign.CENTER;
			var header:text = new text ("University of South Carolina Libraries", stage.stageWidth * 0.90, header_font);
			header.x = stage.stageWidth * .05;
			addChild(header);
			header.y = stage.stageHeight * .10 - header.height * .50;
			
			//Need a Symbol instead of TextFont/Field, etc. 
			
			var scroller:scrollPaneFancy = new scrollPaneFancy();
			scroller.setSize(stage.stageWidth, stage.stageHeight * .8);
			scroller.y = stage.stageHeight * .2;
			if (main.Imree.Device.orientation === "portrait") {
				scroller.drag_enable("top");
			} else {
				scroller.drag_enable("left");
			}
			addChild(scroller);
			
			var wrapper:Sprite = new Sprite();
			scroller.source = wrapper;
			
			var current_x:int = 0;
			for each(var item:XML in xml.result.children()) {
				
				
				var exhibit_cover_wrapper:box;
				if (main.Imree.Device.orientation === "portrait") {
					exhibit_cover_wrapper = new box(stage.stageWidth * .90, stage.stageHeight * .5, 0x000000,.5, 1);
					exhibit_cover_wrapper.x = stage.stageWidth * .05;
					exhibit_cover_wrapper.y = current_x + 15;
					current_x += exhibit_cover_wrapper.height +15;
				} else {
					exhibit_cover_wrapper = new box(stage.stageWidth * .5, stage.stageHeight * .7, 0x000000,.5, 1);
					exhibit_cover_wrapper.x = current_x + 15;
					current_x += exhibit_cover_wrapper.width +15;
				}
				exhibit_cover_wrapper.data = item.exhibit_id;
				exhibit_cover_wrapper.mouseChildren = false;
				exhibit_cover_wrapper.addEventListener(MouseEvent.CLICK, exhibit_selected);
				wrapper.addChild(exhibit_cover_wrapper);
				
				var img_loader_vars:ImageLoaderVars = main.img_loader_vars(exhibit_cover_wrapper);
				
				if (main.image_is_resizeable(item.exhibit_cover_image_url)) {
					item.exhibit_cover_image_url += "?size=" + String(exhibit_cover_wrapper.height);
				}
				new ImageLoader(item.exhibit_cover_image_url, img_loader_vars).load();
				
				var label_font:textFont = new textFont("AbrahamLincoln", 28);
				label_font.align = TextFormatAlign.CENTER;
				var label:text = new text (item.exhibit_name, exhibit_cover_wrapper.width * .8, label_font);
				label.x = exhibit_cover_wrapper.width * .10 + exhibit_cover_wrapper.x;
				label.y = exhibit_cover_wrapper.height * .10 + exhibit_cover_wrapper.y;
				wrapper.addChild(label);
				exhibit_cover_wrapper.transform.colorTransform = new ColorTransform(.33, .29, .10, 1, 50, 50, 60, 0);
				
			}			
			scroller.update();
			
			
		}
		private function exhibit_selected(e:MouseEvent):void {
			if (onSelect !== null) {
				onSelect(box(e.target).data);
			} else {
				trace("an exhibit has been selected, but no onselect function has been defined.");
			}
		}
		public function update_user_privileges():void {
			/**
			 * @todo
			 */
			trace("HOME ADMIN MENU not set");
		}
	}
}