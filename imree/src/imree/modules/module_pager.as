package imree.modules {
	import com.greensock.events.LoaderEvent;
	import com.greensock.layout.AlignMode;
	import com.greensock.layout.ScaleMode;
	import com.greensock.loading.data.ImageLoaderVars;
	import com.greensock.loading.display.ContentDisplay;
	import com.greensock.loading.ImageLoader;
	import com.greensock.TweenMax;
	import com.soulwire.display.PaperSprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.events.MouseEvent;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import imree.IMREE;
	import imree.Main;
	import imree.pages.exhibit_display;
	import imree.shortcuts.box;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class module_pager extends module {
		
		private var pages_up:int;
		public function module_pager(_main:Main, _Exhibit:exhibit_display, _items:Vector.<module>=null)
		{
			t = this;
			super(_main, _Exhibit, _items);
	
		}
		override public function draw_thumb(_w:int = 200, _h:int = 200, Return:Boolean = false):* {
			var bk:box = new box(_w-5, _h-15);
			if (items[0] is module_asset_image) {
				var url:String = module_asset_image(items[0]).asset_url;
				if (module_asset_image(items[0]).can_resize) {
					url += "?size=" + String(_h-15);
				}
				new ImageLoader(url, main.img_loader_vars(bk)).load();
			}
			var icon:Icon_book_background = new Icon_book_background();
			icon.width = _w;
			icon.height = _h;
			bk.addChild(icon);
			if (Return) {
				return bk;
			} else {
				addChild(bk);
			}
		}
		override public function draw_feature(_w:int, _h:int):void {
			if (draw_feature_on_object === null) {
				trace("Must set draw-feature-on-object-first");
			}
			
			var arrow_right:button_right = new button_right();
			var arrow_left:button_left = new button_left();
			var wraps:box = new box(_w , _h);
			var waiting_on:int = 0;
			main.Imree.UI_size(arrow_right);
			main.Imree.UI_size(arrow_left);
			
			if (main.Imree.Device.box_size * 4 < _w && items.length > 1) {
				var pages_holder:box = new box(_w, _h);
				wraps.addChild(pages_holder);
				var page1:box = new box(_w / 2 , _h, 0x123456, 0);
				var page2:box = new box(_w / 2, _h, 0x098765, 0);
				pages_holder.addChild(page1);
				pages_holder.addChild(page2);
				page2.x = page1.width;
				page1.data = page1.width;
				page2.data = page2.width;
				var loader1:ImageLoader;
				var loader2:ImageLoader;
				var flipper:PaperSprite;
				var pg1_cache:Sprite;
				var pg2_cache:Sprite;
				var direction:String = "right";
				
				var content1:box = new box(page1.width, page1.height, 0x009900, 0);
				var content2:box = new box(page2.width, page2.height, 0x000099, 0);
				page1.addChild(content1);
				page2.addChild(content2);
				content1.name = "one";
				content2.name = "two";
				var page_num:int = 0;
				
				
				wraps.addChild(arrow_right);
				wraps.addChild(arrow_left);
				arrow_right.x = _w - arrow_right.width+2;
				arrow_left.x = 0;
				arrow_right.y = _h / 2 - arrow_right.height / 2;
				arrow_left.y = _h / 2 - arrow_left.height / 2;
				arrow_right.addEventListener(MouseEvent.CLICK, page_click);
				arrow_left.addEventListener(MouseEvent.CLICK, page_click);
				function page_click(e:MouseEvent = null):void {
					
					var pg1_bits:BitmapData = new BitmapData(page1.width, page1.height);
					pg1_bits.draw(page1);
					var pg2_bits:BitmapData = new BitmapData(page2.width, page2.height);
					pg2_bits.draw(page2);
					
					pg1_cache = new Sprite();
					pg2_cache = new Sprite();
					
					flipper = new PaperSprite();
					wraps.addChild(flipper);
					flipper.pivot = new Point(0, .5);
					flipper.x = page2.x;
					flipper.y = page2.y + page2.height / 2;
					var pp:PerspectiveProjection = new PerspectiveProjection();
					pp.fieldOfView = 15;
					flipper.transform.perspectiveProjection = pp;
					
					while (content1.numChildren) { content1.removeChildAt(0); }
					while (content2.numChildren) { content2.removeChildAt(0); }
					while (page1.numChildren) { page1.removeChildAt(0); }
					while (page2.numChildren) { page2.removeChildAt(0); }
					
					
					if (loader1 !== null) {
						loader1.unload();
						loader1.dispose(true);
					}
					if (loader2 !== null ) {
						loader2.unload();
						loader2.dispose(true);
					}
					content1.name = "one";
					content2.name = "two";
					page1.addChild(content1);
					page2.addChild(content2);
					if(e === null || e.currentTarget == arrow_right) {
						//page right
						direction = "right";
						if (pg1_cache !== null && pages_holder.contains(pg1_cache)) {
							pages_holder.removeChild(pg1_cache);
						}
						
						pg1_cache.addChild(new Bitmap(pg1_bits));
						pages_holder.addChild(pg1_cache);
						pg1_cache.x = page1.x;
						pg1_cache.y = page1.y;
						
						flipper.front = new Bitmap(pg2_bits);
						page1.visible = false;
						if (page_num + 2 <= items.length) {
							load_image_on_page(items[page_num++], content1);
							load_image_on_page(items[page_num++], content2);
							//page_num++;
						} else if (page_num + 1 <= items.length) {
							load_image_on_page(items[page_num], content1);
							page_num++;
						}
					} else {
						//page left
						direction = "left";
						if (pg1_cache !== null && pages_holder.contains(pg1_cache)) {
							pages_holder.removeChild(pg1_cache);
						}
						pg2_cache.addChild(new Bitmap(pg2_bits));
						pages_holder.addChild(pg2_cache);
						pg2_cache.x = page2.x;
						pg2_cache.y = page2.y;
						flipper.back = new Bitmap(pg1_bits);
						flipper.rotationY = 180;
						page2.visible = false;
						
						
						if (page_num >3) {
							page_num -= 4;
							load_image_on_page(items[page_num++], content1);
							load_image_on_page(items[page_num++], content2);
						} else if (page_num === 1) {
							page_num=0;
							load_image_on_page(items[page_num++], content2);
						}
						
					}
					arrow_left.visible = false;
					arrow_right.visible = false;
				}
				function load_image_on_page(img_mod:module_asset_image, page:box):void  {
					var vars:ImageLoaderVars = new ImageLoaderVars();
					vars.width(int(box(page.parent).data));
					vars.height(page.height);
					vars.container(page);
					vars.crop(true);
					vars.noCache(true);
					if (page.name === "one") {
						vars.hAlign(AlignMode.RIGHT);
					} else {
						vars.hAlign(AlignMode.LEFT);
					}
					vars.scaleMode(ScaleMode.PROPORTIONAL_INSIDE);
					vars.allowMalformedURL(true);
					vars.onComplete(loaded_image);
					var url:String = img_mod.asset_url;
					if (img_mod.can_resize) {
						url += "?size=" + page.height;
					}
					waiting_on++;
					new ImageLoader(url, vars).load();
					
				}
				page_click();
				
				
				function loaded_image(e:LoaderEvent):void {
					waiting_on--;
					if (waiting_on === 0) {	
						if (direction === "right") {
							page1.visible = true;
							var pg1_bits:BitmapData = new BitmapData(page1.width, page1.height);
							pg1_bits.draw(page1);
							page1.visible = false;
							flipper.back = new Bitmap(pg1_bits);
							TweenMax.to(flipper, 1, { rotationY:180, onComplete:animation_finished});
						} else {
							page2.visible = true;
							var pg2_bits:BitmapData = new BitmapData(page2.width, page2.height);
							pg2_bits.draw(page2);
							page2.visible = false;
							flipper.front = new Bitmap(pg2_bits);
							TweenMax.to(flipper, 1, { rotationY:0, onComplete:animation_finished } );
						}
						
						
					}
					function animation_finished(e2:*= null):void {
						if (direction === "right") {
							flipper.parent.removeChild(flipper);
							page1.visible = true;
							pages_holder.removeChild(pg1_cache);
						} else {
							flipper.parent.removeChild(flipper);
							page2.visible = true;
							pages_holder.removeChild(pg2_cache);
						}
						if (page_num +1<= items.length) {
							arrow_right.visible = true;
						}
						if (page_num-2 > 0) {
							arrow_left.visible = true;
						} 
					}
				}
			} else {
				pages_up = 1;
			}
			
			
			
			
			
			draw_feature_on_object.addChild(wraps);
		}
		
	}

}