package imree.pages 
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.layout.ScaleMode;
	import com.greensock.plugins.DropShadowFilterPlugin;
	import fl.containers.ScrollPane;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
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
		public function home(_w:int, _h:int, _conn:serverConnect) 
		{
			conn = _conn;
			conn.server_command("exhibits", "", exhibits_data_receieved);
			
			
		}
		
		
		
		public function exhibits_data_receieved(e:LoaderEvent):void {
			xml = XML(e.target.content);
			
			
				var midstrip:Sprite = new Sprite;
				midstrip.graphics.lineStyle(2, 0x000000);
				midstrip.graphics.beginFill(0xFFFFFF, 1);
				midstrip.graphics.drawRect (0,stage.stageHeight * .15, stage.stageWidth, stage.stageHeight * .70);
				midstrip.graphics.endFill();
				
				addChild(midstrip);
				
						
				/*var UniBox:Sprite = new Sprite;
				UniBox.graphics.lineStyle(0, 0x000000);
				UniBox.graphics.beginFill(0x000000, 0);
				UniBox.graphics.drawRect(stage.stageWidth * .4,0, stage.stageWidth * .5, stage.stageHeight * .1);
				UniBox.graphics.endFill();				
				addChild(UniBox);*/
				
				var Uni_format:textFont = new textFont();
				Uni_format.color = 0xFFFFFF;
				Uni_format.padding = 10;
				Uni_format.size = 50;
				Uni_format.align = "center";
				addChild(new text ("University of South Carolina Libraries", stage.stageWidth * 1, Uni_format));
				
				//Need a Symbol instead of TextFont/Field, etc. 
				
									
				
				
			
			var scroller:ScrollPane = new ScrollPane();
				
				scroller.x = stage.stageWidth * .06;
				scroller.y = stage.stageHeight * .2;
				scroller.setSize(stage.stageWidth * .9, stage.stageHeight * .6);
				scroller.scrollDrag = true;	
				scroller.opaqueBackground = 0xFFFFFF;
				scroller.useHandCursor = true;
				
				
				addChild(scroller);
				
			
			
				
			var wrapper:Sprite = new Sprite();
			scroller.source = wrapper;
			
			
			var current_x:int = 0;
			for each(var item:XML in xml.result.children()) {
				trace(item);
				
				var exhibit_cover_wrapper:box = new box(stage.stageWidth * .45, stage.stageHeight * .45, 0x000000,.5, 1, 0x000000);
				exhibit_cover_wrapper.data = item.exhibit_id;
				exhibit_cover_wrapper.mouseChildren = false;
				exhibit_cover_wrapper.addEventListener(MouseEvent.CLICK, exhibit_selected);
				
				var shadow:DropShadowFilter = new DropShadowFilter();
				shadow.distance = 10;
				shadow.angle = 45;
				shadow.strength = .5;
				
				exhibit_cover_wrapper.filters = [shadow];
				
				exhibit_cover_wrapper.x = current_x + 15;
				current_x += exhibit_cover_wrapper.width +15;
				exhibit_cover_wrapper.y = 50;
				wrapper.addChild(exhibit_cover_wrapper);	
				
				
				
				
				
				var img_loader_vars:ImageLoaderVars = new ImageLoaderVars();
				img_loader_vars.container(exhibit_cover_wrapper);
				img_loader_vars.scaleMode(ScaleMode.PROPORTIONAL_OUTSIDE);
				img_loader_vars.crop(true);
				img_loader_vars.width(stage.stageWidth * .45);
				img_loader_vars.height(stage.stageHeight * .45);
				var img_loader:ImageLoader = new ImageLoader(item.exhibit_cover_image_url, img_loader_vars);
				
				
							
				img_loader.load();	
				
				var txtBox:Sprite = new Sprite;
				//txtBox.graphics.lineStyle(0, 0x000000);
				txtBox.graphics.beginFill(0x000000, 0);
				txtBox.graphics.drawRect(0, 0, stage.stageWidth * .3, stage.stageHeight * .2);
				txtBox.graphics.endFill();
				exhibit_cover_wrapper.addChild(txtBox);
				
				var exhibit_txt_format:textFont = new textFont();
				exhibit_txt_format.color = 0x000000;
				exhibit_txt_format.padding = 10;
				exhibit_txt_format.size = 30;
				
				txtBox.addChild(new text ("Saying Important Stuff about this Exhibit", exhibit_cover_wrapper.width * .6,exhibit_txt_format));
				
				
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
	}
}