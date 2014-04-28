package imree.modules 
{
	import fl.controls.Button;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import imree.data_helpers.data_value_pair;
	import imree.data_helpers.Theme;
	import imree.display_helpers.modal;
	import imree.display_helpers.window;
	import imree.forms.f_data;
	import imree.forms.f_element;
	import imree.forms.f_element_checkbox;
	import imree.forms.f_element_date;
	import imree.forms.f_element_select;
	import imree.forms.f_element_text;
	import imree.forms.f_element_WYSIWYG;
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
		public var description_textflow:String;
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
		
		public var asset_relations:Vector.<module_asset>;
		public var asset_relates_to_node_as:String;
		
		public var asset_window:window;
		public var asset_foreground:box;
		public var asset_content_wrapper:box;
		public var asset_text_wrapper:box;
		public var asset_text_description_wrapper:Sprite;
		
		
		public var loading_indicator:loading_spinner_sprite;
		public function module_asset( _main:Main, _Exhibit:exhibit_display, _items:Vector.<module>=null)
		{
			super(_main, _Exhibit, _items);
		}
		
		public function draw_feature_content():void {
			main.log('Loading [id:' + module_id + '] [name: ' + module_name + '] ' + asset_url);
			//for the particular asset, draw on the asset_content_wrapper after calling prepare_asset_window
		}
		
		override public function draw_edit_button():void {
			if (edit_button === null) {
				var simple:Button = new Button();
				simple.setSize(75, 75);
				simple.label = "Edit Meta";
				edit_button = new Sprite();
				edit_button.addChild(simple);
				edit_button.x = 5;
				edit_button.y = 5;
				if (!edit_button.hasEventListener(MouseEvent.CLICK)) {
					edit_button.addEventListener(MouseEvent.CLICK, draw_edit_UI);
				}
			} 
			//adding the asset is up to the specific asset type
		}
		
		public function prepare_asset_window(_w:int, _h:int):void {
			var asset_window:window = new window(_w, _h, main);
			asset_foreground = new box(asset_window.foreground.width, asset_window.foreground.height);
			asset_text_description_wrapper = new Sprite();
			
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
			if (description_textflow !== null && description_textflow.length > 0) {
				desc_string += description_textflow;
			}
			if (source_credit !== null && source_credit.length > 0) {
				desc_string += " " + source_credit;
			}
			
			var desc:text = new text(desc_string, asset_text_wrapper.width, Theme.font_style_description, asset_text_wrapper.height - title.height);
			asset_text_wrapper.addChild(title);
			asset_text_wrapper.addChild(asset_text_description_wrapper);
			asset_text_description_wrapper.addChild(desc);
			asset_text_description_wrapper.y = title.height + 10;
			
			loading_indicator = new loading_spinner_sprite();
			loading_indicator.blendMode = BlendMode.SCREEN;
			loading_indicator.x = asset_content_wrapper.width/ 2 - 128/2;
			loading_indicator.y = asset_content_wrapper.height/ 2 - 128/2;
			
			
			asset_foreground.addChild(asset_content_wrapper);
			asset_foreground.addChild(asset_text_wrapper);
			asset_content_wrapper.addChild(loading_indicator);
			asset_window.foreground_content_wrapper.addChild(asset_foreground);
			
			main.Imree.Exhibit.overlay_add(asset_window);
			
			if (edit_button !== null) {
				asset_window.addChild(edit_button);
			}
			
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
		
		public var asset_editor:modal;
		override public function draw_edit_UI(e:* = null, animate:Boolean = true, start_at_position:int = 0):void {
			var elements:Vector.<f_element> = prepare_edit_form_elements();
			var form:f_data = prepare_edit_form(elements);
			asset_editor = new modal(main.Imree.staging_area.width, main.Imree.staging_area.height, null, form);
			main.Imree.Exhibit.overlay_add(asset_editor);
		}
		
		public function prepare_edit_form(elements:Vector.<f_element>):f_data {
			var form:f_data;
			form = new f_data(elements);
			form.connect(main.connection, int(module_asset_id), 'module_assets', 'module_asset_id');
			form.data_get_row();
			form.onSubmit = save_row;
			form.draw();
			function save_row(evt:*= null):void {
				var obj:Object = { };
				for each(var item:f_element in form.elements) {
					obj[item.data_column_name] = item.get_value();
					item.indicate_waiting();
				}
				obj['module_asset_id'] = String(module_asset_id);
				main.connection.server_command("module_asset_update", obj, save_row_complete, true);
			}
			function save_row_complete(evt:*= null):void {
				main.toast("Asset metadata saved");
				for each(var item:f_element in form.elements) {
					item.indicate_ready();
				}
			}
			return form;
		}
		
		public function prepare_edit_form_elements():Vector.<f_element> {
			var elements:Vector.<f_element> = new Vector.<f_element>();
			var column_options:Vector.<data_value_pair> = new Vector.<data_value_pair> ();
			column_options.push(new data_value_pair('1', '1'), new data_value_pair('2', '2'));
			elements.push(new f_element_text("Title", 'module_asset_title'));
			elements.push(new f_element_text("Caption", 'caption'));
			elements.push(new f_element_WYSIWYG("Description", 'description'));
			elements.push(new f_element_date("Date Start", "module_asset_display_date_start"));
			elements.push(new f_element_date("Date End", "module_asset_display_date_end"));
			elements.push(new f_element_select('Thumbnail Columns', 'thumb_display_columns', column_options));
			elements.push(new f_element_select('Thumbnail Rows', 'thumb_display_rows', column_options));
			return elements;
		}
	}

}