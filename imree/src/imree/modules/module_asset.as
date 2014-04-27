package imree.modules 
{
	import flash.display.BlendMode;
	import flash.events.MouseEvent;
	import imree.data_helpers.Theme;
	import imree.display_helpers.window;
	import imree.images.loading_spinner_sprite;
	import imree.Main;
	import imree.pages.exhibit_display;
	import imree.shortcuts.box;
	import imree.text;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class module_asset extends module 
	{
		public var feature_item:module;
		public var caption:String;
		public var description:String;
		public var filename:String;
		public var asset_url:String;
		public var asset_specific_thumb_url:String;
		public var can_resize:Boolean;
		public var source_credit:String;
		public var source_common_name:String;
		public var source_url:String;
		public var module_asset_id:String;
		public var asset_next:module_asset;
		public var asset_previous:module_asset;
		
		public var asset_window:window;
		public var asset_foreground:box;
		public var asset_content_wrapper:box;
		public var asset_text_wrapper:box;
		
		public var loading_indicator:loading_spinner_sprite;
		public function module_asset( _main:Main, _Exhibit:exhibit_display, _items:Vector.<module>=null)
		{
			super(_main, _Exhibit, _items);
		}
		
		public function prepare_asset_window(_w:int, _h:int):void {
			var asset_window:window = new window(_w, _h, main);
			
			asset_foreground = new box(asset_window.foreground.width, asset_window.foreground.height);
			
			var next:button_right = new button_right();
			var back:button_left = new button_left();
			main.Imree.UI_size(next);
			main.Imree.UI_size(back);
			if(asset_next) {
				next.addEventListener(MouseEvent.CLICK, asset_next_click);
			} else {
				next.alpha = .3;
			}
			if (asset_previous) {
				back.addEventListener(MouseEvent.CLICK, asset_back_click);
			} else {
				back.alpha = .3;
			}
			asset_foreground.addChild(next);
			asset_foreground.addChild(back);
			
			if (main.Imree.Device.orientation === "portrait") {
				asset_content_wrapper = new box(asset_foreground.width, asset_foreground.height * .7);
				asset_text_wrapper = new box(asset_foreground.width - 20, asset_foreground.height * .3 - 20 - next.height);
				asset_text_wrapper.y = asset_foreground.height * .7 + 10;
				asset_text_wrapper.x = 10;
				next.x = asset_foreground.width - next.width;
				next.y = asset_foreground.height - next.height;
				back.y = asset_foreground.height - next.height;
			} else {
				asset_content_wrapper = new box(asset_foreground.width * .7, asset_foreground.height);
				asset_text_wrapper = new box(asset_foreground.width * .3 -20, asset_foreground.height - 20 - next.height);
				asset_text_wrapper.x = asset_foreground.width * .7 + 10;
				asset_text_wrapper.y = 10;
				next.x = asset_foreground.width - next.width;
				next.y = asset_foreground.height - next.height;
				back.x = asset_text_wrapper.x;
				back.y = asset_foreground.height - back.height;
			}
			
			var content_mask:box = new box(asset_content_wrapper.width, asset_content_wrapper.height);
			asset_content_wrapper.addChild(content_mask);
			asset_content_wrapper.mask = content_mask;
			
			var title:text = new text(module_name, asset_text_wrapper.width, Theme.font_style_h3, asset_text_wrapper.height);
			
			var desc_string:String = "";
			if (description !== null && description.length > 0) {
				desc_string += description;
			}
			if (source_credit !== null && source_credit.length > 0) {
				desc_string += " " + source_credit;
			}
			
			var desc:text = new text(desc_string, asset_text_wrapper.width, Theme.font_style_description, asset_text_wrapper.height - title.height);
			asset_text_wrapper.addChild(title);
			asset_text_wrapper.addChild(desc);
			desc.y = title.height + 10;
			
			loading_indicator = new loading_spinner_sprite();
			loading_indicator.blendMode = BlendMode.SCREEN;
			loading_indicator.x = asset_content_wrapper.width/ 2 - 128/2;
			loading_indicator.y = asset_content_wrapper.height/ 2 - 128/2;
			
			
			asset_foreground.addChild(asset_content_wrapper);
			asset_foreground.addChild(asset_text_wrapper);
			asset_content_wrapper.addChild(loading_indicator);
			asset_window.foreground_content_wrapper.addChild(asset_foreground);
			
			main.Imree.Exhibit.overlay_add(asset_window);
			
			
			function asset_back_click(e:MouseEvent):void {
				if(asset_previous !== null) {
					asset_previous.draw_feature(_w, _h);
				}
			}
			function asset_next_click(e:MouseEvent):void {
				if (asset_next !== null) {
					asset_next.draw_feature(_w, _h);
				}
			}
		}
	}

}