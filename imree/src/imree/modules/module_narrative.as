package imree.modules 
{
	import com.greensock.easing.Cubic;
	import com.greensock.loading.ImageLoader;
	import com.greensock.TweenLite;
	import fl.containers.BaseScrollPane;
	import fl.containers.ScrollPane;
	import fl.controls.Button;
	import fl.events.ScrollEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeDragEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import imree.data_helpers.data_value_pair;
	import imree.data_helpers.position_data;
	import imree.data_helpers.Theme;
	import imree.display_helpers.modal;
	import imree.display_helpers.scrollPaneFancy;
	import imree.display_helpers.smart_button;
	import imree.forms.f_data;
	import imree.forms.f_element;
	import imree.forms.f_element_select;
	import imree.forms.f_element_text;
	import imree.layout;
	import imree.Main;
	import imree.pages.exhibit_display;
	import imree.shortcuts.box;
	import imree.text;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class module_narrative extends module 
	{
		public var feature_item:module;
		public var caption:String;
		public var description:String;
		public var filename:String;
		public var scroller:scrollPaneFancy;
		public var wrapper:Sprite;
		public var slidder:Sprite;
		public var wrapper_handle:Sprite;
		public function module_narrative( _main:Main, _Exhibit:exhibit_display, _items:Vector.<module>=null)
		{
			t = this;
			super(_main, _Exhibit, _items);
		}
		
		override public function draw_thumb(_w:int = 200, _h:int = 200, Return:Boolean = false):* {
			thumb_wrapper = new Sprite();
			var thumb_back:box = new box(_w-5, _h-15, Theme.background_color_primary,1);
			thumb_wrapper.addChild(thumb_back);
			var block:position_data = new position_data(Math.floor((_w-5) / 3) - 5, Math.floor((_h-15) / 3) - 5);
			var original_positions:Vector.<position_data> = new Vector.<position_data>();
			original_positions.push(block, block, block, block, block, block, block, block, block);
			var positions:Vector.<position_data> = new layout().abstract_box_solver(original_positions, _w-5, _h-15);
			var thumbs:Sprite = new Sprite();
			for (var i:int = 0; i < items.length && i < 9; i++) {
				if (items[i] is module_asset_image) {
					var img:module_asset_image = module_asset_image(items[i]);
					var bk:box = new box(positions[i].width, positions[i].height);
					var url:String = img.asset_url;
					if (img.can_resize) {
						url = main.image_url_resized(url,String(positions[i].height));
					}
					new ImageLoader(url, main.img_loader_vars(bk)).load();
					thumbs.addChild(bk);
					bk.x = positions[i].x;
					bk.y = positions[i].y;
				}
			}
			if (items.length === 0) {
				thumbs.addChild(new box(_w, _h, Theme.background_color_secondary, 1));
				thumbs.addChild(new text("Empty Narrative", _w, Theme.font_style_description));
			}
			thumb_wrapper.addChild(thumbs);
			thumbs.x = (_w-5) / 2 - thumbs.width / 2;
			thumbs.y = (_h-15) / 2 - thumbs.height / 2;
			var icon:Icon_book_background = new Icon_book_background();
			icon.width = _w;
			icon.height = _h;
			thumb_wrapper.addChild(icon);
			thumb_wrapper.addEventListener(MouseEvent.CLICK, overlay_focus);
			function overlay_focus(m:MouseEvent):void {
				var module_as_focus:Sprite = new Sprite();
				module_as_focus.addChild(new text("Narratives inside Narratives are not supported at this time :-( ", 400));
				main.Imree.Exhibit.overlay_add(module_as_focus);
				module_as_focus.addEventListener(MouseEvent.CLICK, remove_module_as_focus);
				function remove_module_as_focus(asdf:MouseEvent):void {
					module_as_focus.removeEventListener(MouseEvent.CLICK, remove_module_as_focus);
					main.Imree.Exhibit.overlay_remove();
				}
			}
			if (Return) {
				return thumb_wrapper;
			} else {
				addChild(thumb_wrapper);
				return null;
			}
		}
		
		override public function draw_feature(_w:int, _h:int):void {
			var position:int = main.Imree.Device.box_size /2 ;
			wrapper = new Sprite();
			slidder = new Sprite();
			wrapper_handle = new Sprite();
			slidder.addChild(wrapper_handle);
			for each(var i:module in items) {
				if (i is module_narrative || i is module_pager) {
					i.draw_thumb();
				} else {
					i.draw_feature(_w - 30, _h - 30);
				}
				i.phase_feature = true;
				i.alpha = .8;
				slidder.addChild(i);
				
				if (main.Imree.Device.orientation == 'portrait') {
					i.y = position;
					position += i.height  + main.Imree.Device.box_size / 2;
				} else {
					i.x = position;
					position += i.width + main.Imree.Device.box_size / 2;
				}
				
				i.slide_out();
			}
			
			scroller = new scrollPaneFancy();
			scroller.setSize(_w, _h);
			scroller.source = wrapper;
			
			slidder.mouseChildren = true;
			wrapper.addChild(slidder);
			scroller.update();
			scroller.drag_enable();
			addChild(scroller);
			
			if (main.Imree.Device.orientation == "portrait") {
				slidder.y = main.stage.stageHeight;
				wrapper_handle.addChild(new box(main.Imree.staging_area.width - 30, wrapper.height + main.Imree.Device.box_size));
				scroller.drag_direction = "top";
			} else {
				slidder.x = main.stage.stageWidth;
				wrapper_handle.addChild(new box(wrapper.width + main.Imree.Device.box_size, main.Imree.staging_area.height -30));
				scroller.drag_direction = "left";
			}
			
			TweenLite.to(slidder, 2, { y:0, x:0, ease:Cubic.easeInOut} );
			scroller.update();
			update_items_visible_in_scroller();
			
			scroller.addEventListener(MouseEvent.MOUSE_WHEEL, scrollwheel);
			function scrollwheel(e:MouseEvent):void {
				if (main.Imree.Device.orientation == 'portrait') {
					scroller.verticalScrollPosition -= e.delta * 30;
				} else {
					scroller.horizontalScrollPosition -= e.delta * 20;
				}
				update_items_visible_in_scroller();
				scroller.update();
			}
			
			scroller.addEventListener(ScrollEvent.SCROLL, dragging);
			function dragging(e:ScrollEvent):void {
				update_items_visible_in_scroller();
				scroller.update();
			}
			
			function update_items_visible_in_scroller():void {
				for each(var j:module in items) {
					if (!j.module_is_visible) {
						if (j.x < Math.abs(scroller.horizontalScrollPosition) + scroller.width + main.Imree.Device.box_size *1.5 && main.Imree.Device.orientation === "landscape") {
							j.slide_in();
						}
						if (j.x < Math.abs(scroller.verticalScrollPosition) + scroller.width + main.Imree.Device.box_size * 1.5 && main.Imree.Device.orientation === "portrait") {
							j.slide_in();
						}
					}
				}
			}
			
			addEventListener(Event.REMOVED_FROM_STAGE, remove_scroller_listeners);
			function remove_scroller_listeners(d:*= null):void {
				if (scroller !== null) {
					scroller.removeEventListener(ScrollEvent.SCROLL, dragging);					
					scroller.removeEventListener(MouseEvent.MOUSE_WHEEL, scrollwheel);
					scroller.drag_disable();
					scroller = null;
				}
			}
			phase_feature = true;
		}
		
		override public function draw_edit_button():void {
			trace('add_here');
		}
		
		override public function draw_edit_UI(e:* = null, animate:Boolean = true, start_at_position:int =0):void {
			standard_edit_UI(e, animate, start_at_position);
		}
		
		override public function focus_on_sub_module(mod:module, focused:Function = null):void {
			TweenLite.to(scroller, 1, {verticalScrollPosition:mod.y - main.Imree.Device.box_size*.5, horizontalScrollPosition :mod.x - main.Imree.Device.box_size*.5, onComplete:focused} );
		}
		
		override public function dump(e:*=null):void 
		{
			
			feature_item = null;
			wrapper_handle = null;
			wrapper = null;
			slidder = null;
			super.dump();
		}
	}

}