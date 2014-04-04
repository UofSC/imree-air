package imree.modules {
	import com.greensock.events.LoaderEvent;
	import com.greensock.layout.AlignMode;
	import com.greensock.layout.ScaleMode;
	import com.greensock.loading.data.ImageLoaderVars;
	import com.greensock.loading.display.ContentDisplay;
	import com.greensock.loading.ImageLoader;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
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
					if (content1 != null) {
						page1.removeChild(content1);
					}
					if(content2 != null) {
						page2.removeChild(content2);
					}
					content1 = null;
					content2 = null;
					var content1:box = new box(page1.width, page1.height, 0x009900, 0);
					var content2:box = new box(page2.width, page2.height, 0x000099, 0);
					content1.name = "one";
					content2.name = "two";
					page1.addChild(content1);
					page2.addChild(content2);
					if(e !== null) {
						if (e.currentTarget == arrow_right) {
							//page right
							if (page_num + 2 <= items.length) {
								load_image_on_page(items[page_num], content1);
								load_image_on_page(items[page_num++], content2);
								page_num++;
							} else if (page_num + 1 <= items.length) {
								load_image_on_page(items[page_num], content1);
								page_num++;
							}
						} else {
							//page left
							if (page_num >= 2) {
								page_num--;
								load_image_on_page(items[page_num--], content2);
								load_image_on_page(items[page_num--], content1);
							} else if (page_num === 1) {
								page_num--;
								load_image_on_page(items[page_num--], content2);
							}
						}
					} else {
						//first pages
						if (page_num < items.length) {
							load_image_on_page(items[page_num], content1);
							page_num++;
						} 
						
						if (page_num < items.length) {
							load_image_on_page(items[page_num], content2);
							page_num++;
						} 
						
					}
					trace(page_num + " VS " + items.length);
					if (page_num +1<= items.length) {
						arrow_right.visible = true;
					} else {
						arrow_right.visible = false;
					}
					if (page_num > 0) {
						arrow_left.visible = true;
					} else {
						arrow_left.visible = false;
					}
				}
				function load_image_on_page(img_mod:module_asset_image, page:box):void  {
					trace("Loading page index #" + page_num);
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
					var url:String = img_mod.asset_url;
					if (img_mod.can_resize) {
						url += "?size=" + page.height;
					}
					new ImageLoader(url, vars).load();
				}
				page_click();
				
			} else {
				pages_up = 1;
			}
			
			
			
			
			
			draw_feature_on_object.addChild(wraps);
		}
		
	}

}