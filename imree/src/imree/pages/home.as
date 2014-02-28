package imree.pages 
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.layout.ScaleMode;
	import fl.containers.ScrollPane;
	import flash.display.Sprite;
	import imree.serverConnect;
	import flash.display.*;
	import imree.shortcuts.box;
	
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
		public function home(_w:int, _h:int, _conn:serverConnect) 
		{
			conn = _conn;
			conn.server_command("exhibits", "", exhibits_data_receieved);
		}
		
		
		public function exhibits_data_receieved(e:LoaderEvent):void {
			xml = XML(e.target.content);
			
			var scroller:ScrollPane = new ScrollPane();
				
				scroller.x = stage.stageWidth * .15;
				scroller.y = stage.stageHeight * .2;
				scroller.setSize(stage.stageWidth * .75, stage.stageHeight * .5);
				scroller.scrollDrag = true;
				scroller.alpha = 1;
				addChild(scroller);
				
				//wtf:
				//scroller.horizontalScrollBar;
				
			var wrapper:Sprite = new Sprite();
			scroller.source = wrapper;
			
			var current_x:int = 0;
			for each(var item:XML in xml.result.children()) {
				trace(item);
				
				var exhibit_cover_wrapper:Sprite = new Sprite;
				exhibit_cover_wrapper.graphics.lineStyle(20, 0xFFFFFF);
				exhibit_cover_wrapper.graphics.beginFill(0x000000, 1);
				exhibit_cover_wrapper.graphics.drawRect(0,0, stage.stageWidth * .45, stage.stageHeight * .45); 
				exhibit_cover_wrapper.graphics.endFill();
				
				exhibit_cover_wrapper.x = current_x;
				current_x += exhibit_cover_wrapper.width + 10;
				exhibit_cover_wrapper.y = 10;
				wrapper.addChild(exhibit_cover_wrapper);				
				
				
				
				var img_loader_vars:ImageLoaderVars = new ImageLoaderVars();
				img_loader_vars.container(exhibit_cover_wrapper);
				img_loader_vars.scaleMode(ScaleMode.PROPORTIONAL_OUTSIDE);
				img_loader_vars.crop(true);
				img_loader_vars.width(stage.stageWidth * .45);
				img_loader_vars.height(stage.stageHeight * .45);
				var img_loader:ImageLoader = new ImageLoader(item.exhibit_cover_image_url, img_loader_vars);
				
				
							
				img_loader.load();	
				
			}			
			scroller.update();
			
			
			var txt_wrapper:box = new box(100,100,0xFFFFFF,1);
								
				var exhibit_txt_format:textFont = new textFont('AbrahamLincoln', 25);
				exhibit_txt_format.color = 0xFFFFFF;
				exhibit_txt_format.padding = 15;
				txt_wrapper.addChild(new text ("Saying Important Stuff about this Exhibit"));
			
			
			
			}
		
		
	}
}