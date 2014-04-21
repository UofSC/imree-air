package imree.pages 
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.layout.ScaleMode;
	import com.greensock.plugins.DropShadowFilterPlugin;
	import fl.containers.ScrollPane;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import imree.data_helpers.position_data;
	import imree.data_helpers.Theme;
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
		
			
			var midstrip:Sprite = new Sprite;
			midstrip.graphics.lineStyle(2, 0x00FF00);
			midstrip.graphics.beginFill(0x0000FF, 1);
			midstrip.graphics.drawRect (0,stage.stageHeight * .15, stage.stageWidth, stage.stageHeight * .70);
			midstrip.graphics.endFill();
			
			addChild(midstrip);
			
			addChild(new text ("University of South Carolina Libraries", stage.stageWidth * 1, Theme.font_style_title));
			
			//Need a Symbol instead of TextFont/Field, etc. 
			
			
			var scroller:ScrollPane = new ScrollPane();
				
				scroller.x = stage.stageWidth * .06;
				scroller.y = stage.stageHeight * .2;
				scroller.setSize(stage.stageWidth * .9, stage.stageHeight * .6);
				scroller.scrollDrag = true;	
				scroller.opaqueBackground = 0xFF0000;
				scroller.useHandCursor = true;
				
				
				addChild(scroller);
				
			
			
				
			var wrapper:Sprite = new Sprite();
			scroller.source = wrapper;
			
			
			var current_x:int = 0;
			for each(var item:XML in xml.result.children()) {
				
				var exhibit_cover_wrapper:box = new box(stage.stageWidth * .45, stage.stageHeight * .45, 0x000000,.5, 1, 0x000000);
				exhibit_cover_wrapper.data = item.exhibit_id;
				exhibit_cover_wrapper.mouseChildren = false;
				exhibit_cover_wrapper.addEventListener(MouseEvent.CLICK, exhibit_selected);
				
				exhibit_cover_wrapper.x = current_x + 15;
				current_x += exhibit_cover_wrapper.width +15;
				exhibit_cover_wrapper.y = 50;
				wrapper.addChild(exhibit_cover_wrapper);
				
				var img_loader_vars:ImageLoaderVars = main.img_loader_vars(exhibit_cover_wrapper);
				
				
				if (main.image_is_resizeable(item.exhibit_cover_image_url)) {
					item.exhibit_cover_image_url += "?size=" + String(exhibit_cover_wrapper.height);
				}
				new ImageLoader(item.exhibit_cover_image_url, img_loader_vars).load();
				
				var txtBox:Sprite = new Sprite;
				txtBox.graphics.beginFill(0x00FFFF, 1);
				txtBox.graphics.drawRect(0, 0, stage.stageWidth * .3, stage.stageHeight * .2);
				txtBox.graphics.endFill();
				exhibit_cover_wrapper.addChild(txtBox);
				
				txtBox.addChild(new text (item.exhibit_name, exhibit_cover_wrapper.width * .6,Theme.font_style_h1));
				
				
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