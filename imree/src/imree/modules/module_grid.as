package imree.modules 
{
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
	import flash.system.Worker;
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
						url += "?size=" + String(positions[i].height);
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
				var name_label:text = new text(module_name + module_sub_name, _w, Theme.font_style_h2);
				wrapper.addChild(name_label);
				y_offest = name_label.height;
			}
			
			var raw_positions:Vector.<position_data> = new Vector.<position_data>();
			for each(var i:module in items) {
				raw_positions.push(new position_data(main.Imree.Device.box_size * i.thumb_display_columns, main.Imree.Device.box_size * i.thumb_display_rows));
			}
			
			var positions:Vector.<position_data> = new layout().abstract_box_solver(raw_positions, _w, _h - y_offest, 5, overflow_from_direction, true);
			
			for (var j:int = 0; j < items.length; j++) {
				items[j].draw_thumb(positions[j].width, positions[j].height);
				wrapper.addChild(items[j]);
				items[j].x = positions[j].x;
				items[j].y = positions[j].y + y_offest;
				
				if (module_display_child_names && items[j].module_name.length > 0) {
					var child_label:text = new text(items[j].module_name, positions[j].width -10, Theme.font_style_description);
					var label_background:box = new box(positions[j].width, child_label.height + 10, Theme.background_color_secondary, .6);
					items[j].addChild(label_background);
					label_background.y = positions[j].height - label_background.height;
					label_background.addChild(child_label);
					child_label.x = 5;
					child_label.y = 5;
				}				
				items[j].addEventListener(MouseEvent.CLICK, item_selected);
			}
			addChild(wrapper);
			function item_selected(e:MouseEvent):void {
				if(e.currentTarget is module_asset) {
					Exhibit.bring_asset_to_front(module_asset(e.currentTarget));
				} else if (e.currentTarget is module_pager) {
					Exhibit.bring_pager_to_front(module_pager(e.currentTarget));
				}
			}
			if (items.length === 0) {
				wrapper.addChild(new text("Empty Block", 150, Theme.font_style_h1));
			}
			
		}
		
		override public function draw_edit_button():void {
			if(edit_button === null) {
				edit_button = new Sprite();
				var button:Button = new Button();
				button.setSize(main.Imree.Device.box_size / 4, main.Imree.Device.box_size / 4);
				button.label = "Edit Grid";
				edit_button.addChild(button);
				edit_button.y -= main.Imree.Device.box_size / 3;
			}
			phase_feature = grid_feature_drawn;
			super.draw_edit_button();
		}
		override public function draw_edit_UI(e:* = null, animate:Boolean = true, start_at_position:int =0):void {
			standard_edit_UI(e, animate, start_at_position);
		}
		
		
		
		
		
	}

}