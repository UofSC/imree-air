package imree.modules 
{
	import com.demonsters.debugger.MonsterDebugger;
	import com.greensock.data.TweenLiteVars;
	import com.greensock.easing.Cubic;
	import com.greensock.loading.ImageLoader;
	import com.greensock.TweenLite;
	import fl.containers.ScrollPane;
	import fl.controls.Button;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	//import flash.system.Worker;
	import flash.utils.Timer;
	import imree.data_helpers.data_value_pair;
	import imree.data_helpers.permission;
	import imree.data_helpers.position_data;
	import imree.data_helpers.Theme;
	import imree.display_helpers.modal;
	import imree.display_helpers.search;
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
	import imree.textFont;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class module_grid extends module
	{
		public var grid_feature_drawn:Boolean = false;
		public function module_grid(_main:Main, _Exhibit:exhibit_display, _items:Vector.<module>=null)
		{
			t = this;
			super(_main, _Exhibit, _items);
			
			var assets:Vector.<module_asset> = new Vector.<module_asset>();
			for (var i:int = 0; i < items.length; i++) {
				if (items[i] is module_asset) {
					assets.push(module_asset(items[i]));
				}
			}
			for (i = 0; i < assets.length; i++) {
				if (i > 0) {
					assets[i].asset_previous = assets[i - 1];
				}
				if (i + 1 < assets.length) {
					assets[i].asset_next = assets[i + 1];
				}
			}
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
						url = main.image_url_resized(url, String(positions[i].height));
					}
					new ImageLoader(url, main.img_loader_vars(bk)).load();
					thumbs.addChild(bk);
					bk.x = positions[i].x;
					bk.y = positions[i].y;
				}
			}
			thumb_wrapper.addChild(thumbs);
			thumbs.x = (_w-5) / 2 - thumbs.width / 2;
			thumbs.y = (_h-15) / 2 - thumbs.height / 2;
			var icon:Icon_book_background = new Icon_book_background();
			icon.width = _w;
			icon.height = _h;
			thumb_wrapper.addChild(icon);
			if (Return) {
				return thumb_wrapper;
			} else {
				addChild(thumb_wrapper);
				return null;
			}
		}
		override public function draw_feature(_w:int, _h:int):void {
			phase_feature = true;
			grid_feature_drawn = true;
			var overflow_from_direction:String;
			if (main.Imree.Device.orientation === 'portrait') {
				overflow_from_direction = "top";
			} else {
				overflow_from_direction = "left";
			}
			
			var wrapper:Sprite = new Sprite();
			
			var y_offest:Number = 0;
			if (module_display_name) {
				var name_label:text = new text(module_name + module_sub_name, _w, Theme.font_style_h1);
				wrapper.addChild(name_label);
				y_offest = name_label.height;
			}
			
			var raw_positions:Vector.<position_data> = new Vector.<position_data>();
			for each(var i:module in items) {
				raw_positions.push(new position_data(main.Imree.Device.box_size * i.thumb_display_columns, main.Imree.Device.box_size * i.thumb_display_rows));
			}
			
			var positions:Vector.<position_data> = new layout().abstract_box_solver(raw_positions, _w, _h - y_offest, 5, overflow_from_direction, true);
			var height_calculated:Number = 0;
			var width_calculated:Number = 0;
			for (var j:int = 0; j < items.length; j++) {
				items[j].draw_thumb(positions[j].width, positions[j].height);
				wrapper.addChild(items[j]);
				items[j].x = positions[j].x;
				items[j].y = positions[j].y + y_offest;
				items[j].addEventListener(MouseEvent.CLICK, item_selected);
				
				if (main.Imree.Device.orientation === 'portrait') {
					wrapper.x = _w / 2 - width_calculated / 2;
				} else {
					wrapper.y = _h / 2 - height_calculated / 2;
				}
				if (items[j] is module_asset && module_asset(items[j]).caption.length > 0) {
					var child_label:text = new text(module_asset(items[j]).caption, positions[j].width -10, Theme.font_style_description);
					var label_background:box = new box(positions[j].width, child_label.height + 10, Theme.background_color_secondary, .6);
					module_asset(items[j]).addChild(label_background);
					label_background.y = positions[j].height - label_background.height;
					label_background.addChild(child_label);
					child_label.x = 5;
					child_label.y = 10;
				}			
				
				height_calculated = Math.max(positions[j].height + positions[j].y + y_offest, height_calculated);
				width_calculated = Math.max(positions[j].width + positions[j].x + y_offest, width_calculated);
				
				items[j].addEventListener(MouseEvent.CLICK, item_selected);
			}
			if (main.Imree.Device.orientation === 'portrait') {
				wrapper.x = _w / 2 - width_calculated / 2;
			} else {
				wrapper.y = _h / 2 - height_calculated / 2;
			}
			addChild(wrapper);
			function item_selected(e:MouseEvent):void {
				if (e.currentTarget is module_asset) {
					module(e.currentTarget).draw_feature(main.Imree.staging_area.width, main.Imree.staging_area.height);
				} else if (e.currentTarget is module_pager) {
					module_pager(e.currentTarget).draw_feature(main.Imree.staging_area.width, main.Imree.staging_area.height);
				}else if (e.currentTarget is module_comparison) {
					module_comparison(e.currentTarget).draw_feature(main.Imree.staging_area.width, main.Imree.staging_area.height);
				} else {
					trace("item selected, but not recognized. Add a switch in module_grid for new module types. -Dummy");
				}
			}
			if (items.length === 0) {
				var empty_bl_bx:box = new box(135, 80, 0x4E4E4E, .4);
				wrapper.addChild(empty_bl_bx);
				empty_bl_bx.y = main.Imree.staging_area.height / 5;
				var empty_bl_tx:text = new text("Empty Block", 150, Theme.font_style_h1);
				empty_bl_tx.x = 2;
				empty_bl_tx.y = 2;
				empty_bl_bx.addChild(empty_bl_tx);		
				
				
			}
			
			wrapper.addEventListener(Event.REMOVED_FROM_STAGE, removed_from_stage);
			function removed_from_stage(e:Event):void {
				wrapper.removeEventListener(Event.REMOVED_FROM_STAGE, removed_from_stage);
				while (wrapper.numChildren) {
					wrapper.removeChildAt(0);
				}
			}
		}
		
		override public function draw_edit_button():void {
			if(edit_button === null) {
				edit_button = new Sprite();
				var butt:button_edit_module = new button_edit_module();
				main.Imree.UI_size(butt);
				edit_button.addChild(butt);
				edit_button.x -= 10;
				edit_button.transform.colorTransform = Theme.color_transform_page_buttons;
				trace(edit_button.getBounds(main.stage));
			}
			phase_feature = grid_feature_drawn;
			super.draw_edit_button();
		}
		override public function draw_edit_UI(e:* = null, animate:Boolean = true, start_at_position:int =0):void {
			standard_edit_UI(e, animate, start_at_position);
		}
		
		
		
		
		
	}

}