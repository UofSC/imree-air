package imree.modules {
	import com.greensock.loading.ImageLoader;
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
			
			var wraps:box = new box(_w , _h);
			if (main.Imree.Device.box_size * 4 < _w && items.length < 2) {
				pages_up = 1;
			} else {
				pages_up = 2;
			}
			
			var page0:box = new box(_w / pages_up - 10, _h) ;
			var page1:box = new box(_w / pages_up - 10, _h);
			var arrow_right:button_right = new button_right();
			var arrow_left:button_left = new button_left();
			var page_holder:box = new box(_w, _h);
			wraps.addChild(page_holder);
			main.Imree.UI_size(arrow_right);
			main.Imree.UI_size(arrow_left);
			page_holder.addChild(page0);
			wraps.addChild(arrow_left);
			wraps.addChild(arrow_right);
			arrow_right.x = _w - arrow_right.width;
			arrow_right.y = _h / 2 - arrow_right.height / 2;
			arrow_left.y = _h / 2 - arrow_left.height / 2;
			arrow_right.addEventListener(MouseEvent.CLICK, page_next);
			arrow_left.addEventListener(MouseEvent.CLICK, page_back);
			check_buttons();
			
			if (pages_up === 2 ) {
				page_holder.addChild(page1);
				page1.x = _w / 2 ;
			}
			
			var current_i:int = 0-pages_up;
			page_next();
			
			function page_next(e:MouseEvent=null):void {
				current_i += pages_up;
				image_on_page(items[current_i], page0);
				if (pages_up === 2) {
					if(current_i + 1 < items.length) {
						image_on_page(items[current_i +1], page1);
					} else {
						trace("HERE");
						page1.addChild(new box(page1.width, page1.height, 0xFFFFFF, 1));
					}
				}
				check_buttons();
			}
			function page_back(e:MouseEvent = null):void {
				current_i -= pages_up;
				if (pages_up === 2)  {
					image_on_page(items[current_i +1], page1);
				}
				if(current_i >  items.length) {
					image_on_page(items[current_i], page0);
				} else {
					if (page0.parent !== null) {
						page0.parent.removeChild(page0);
					}
				}
				check_buttons();
			}
			function image_on_page(m:module_asset_image, pg:box):void {
				trace("Drawing: " + m + " :: " + current_i + " of " + items.length);
				var new_pg:box = new box(pg.width, pg.height);
				new_pg.x = pg.x;
				new_pg.y = pg.y;
				if (pg.parent !== null) {
					pg.parent.removeChild(pg);
				}
				pg = new_pg;
				page_holder.addChild(pg);
				pg.addChild(new box(pg.width, pg.height, 0xFFFFFF, 1));
				var url:String = m.asset_url;
				if (m.can_resize) {
					url += "?size=" + pg.height;
				}
				new ImageLoader(url, main.img_loader_vars(pg)).load();
			}
			function check_buttons():void {
				if (current_i + pages_up > items.length) {
					arrow_right.alpha = .3;
					arrow_right.mouseEnabled = false;
					arrow_right.removeEventListener(MouseEvent.CLICK, page_next);
				} else {
					arrow_right.alpha = 1;
					arrow_right.mouseEnabled = true;
					arrow_right.addEventListener(MouseEvent.CLICK, page_next);
				}
				if (current_i - pages_up < 0) {
					arrow_left.alpha = .3;
					arrow_left.mouseEnabled = false;
					arrow_left.removeEventListener(MouseEvent.CLICK, page_back);
				} else {
					arrow_left.alpha = 1;
					arrow_left.mouseEnabled = true;
					arrow_left.addEventListener(MouseEvent.CLICK, page_back);
				}
			}
			draw_feature_on_object.addChild(wraps);
		}
		
	}

}