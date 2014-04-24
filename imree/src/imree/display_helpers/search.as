package imree.display_helpers {
	import com.adobe.serialization.json.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.layout.ScaleMode;
	import com.greensock.loading.data.ImageLoaderVars;
	import com.greensock.loading.ImageLoader;
	import com.greensock.TweenLite;
	import fl.containers.ScrollPane;
	import fl.controls.Button;
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import fl.events.ComponentEvent;
	import fl.events.DataChangeEvent;
	import fl.events.DataChangeType;
	import fl.events.ListEvent;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import imree.data_helpers.data_value_pair;
	import imree.data_helpers.position_data;
	import imree.forms.f_element_text;
	import imree.images.loading_spinner_sprite;
	import imree.layout;
	import imree.Main;
	import imree.modules.module;
	import imree.shortcuts.box;
	import imree.text;
	import imree.textFont;
	import Icon_book_background;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class search extends Sprite {
		
		public var onComplete:Function;
		public var onDestroy:Function;
		public var allow_modules:Boolean;
		private var w:int;
		private var h:int;
		private var wrapper:Sprite;
		private var search_ui_wrapper:Sprite;
		private var main:Main;
		private var Module:module;
		private var search_box:f_element_text;
		private var search_submit:smart_button;
		private var spinner:loading_spinner_sprite;
		public var selections:Vector.<data_value_pair>;
		private var btn_confirm:smart_button;
		private var btn_cancel:smart_button;
		public function search(_onComplete:Function, _main:Main, _Module:module, _onDestroy:Function, _w:int = 300, _h:int = 300) {
			onComplete = _onComplete;
			main = _main;
			Module = _Module;
			onDestroy = _onDestroy;
			w = _w;
			h = _h;
			allow_modules = false;
		}
		public function draw_search_box():void {
			main.clean_slate([wrapper, search_box, search_submit, search_ui_wrapper]);
			selections = new Vector.<data_value_pair>();
			wrapper = new Sprite();
			search_ui_wrapper = new Sprite();
			addChild(wrapper);
			wrapper.addChild(new box(w, h, 0x0000ff, .8));
			wrapper.addChild(search_ui_wrapper);
			search_box = new f_element_text("Search", 'some_search_val');
			search_ui_wrapper.addChild(search_box);
			search_box.draw();
			
			search_ui_wrapper.y = h / 2;
			search_ui_wrapper.x = main.stage.stageWidth / 2 - search_box.width / 2;
			
			var search_submit_button:Button = new Button();
			search_submit_button.setSize(100, 40);
			search_submit_button.label = "Submit Search";
			search_submit = new smart_button(search_submit_button, submit);
			search_ui_wrapper.addChild(search_submit);
			search_submit.x = search_box.width + 10;
			
			if (allow_modules) {
				var selector:ComboBox = new ComboBox();
				selector.prompt = "Add new module";
				var datas:Array = [{label:"Title", data:"title"}, {label:"Linear/Narrative",data:"narrative"}, {label:"Grid/Gallery",data:"grid"}];
				selector.dataProvider = new DataProvider(datas);
				selector.addEventListener(Event.CHANGE, add_module_by_name);
				search_ui_wrapper.addChild(selector);
				selector.x = search_ui_wrapper.width / 2 - selector.width / 2;
				selector.y = search_ui_wrapper.height;
			}
			function add_module_by_name(s:Event):void {
				var obj:Object = {'module_order':'9999','module_name':'new module','module_parent_id':String(Module.module_id),'module_type':String(selector.selectedItem.data)};
				main.connection.server_command("new_module", obj, add_module_by_name_done, true);
			}
			function add_module_by_name_done(s:Event):void {
				onDestroy();
			}
		}
		
		
		public function submit(e:*=null):void {
			trace("Query Started with " + search_box.get_value());
			if (spinner === null ) {
				spinner = new loading_spinner_sprite(60);
				search_ui_wrapper.addChild(spinner);
				search_submit.visible = false;
				spinner.x = search_submit.x;
			}
			main.connection.server_command("search", search_box.get_value(), results, true);
		}
		
		private function results(e:LoaderEvent):void {
			if (spinner !== null) {
				search_ui_wrapper.removeChild(spinner);
				spinner = null;
				search_submit.visible = true;
			}
			
			
			var xml:XML = XML(e.target.content);
			
			var scroller_contents:Sprite = new Sprite();
			if (xml.result.children.children().length() == 0) {
				trace("no results"); //@todo add visual message to results pane
			}
			
			var boxes:Vector.<DisplayObjectContainer> = new Vector.<DisplayObjectContainer>();
			for (var i:String in xml.result.children.children()) {
				var bk:box = new box(main.Imree.Device.box_size, main.Imree.Device.box_size, 0xF0F0F0, 1, 1);
				bk.data = { repository:xml.result.children.children()[i].repository, id:xml.result.children.children()[i].id, collection:xml.result.children.children()[i].collection };
				
				var image_portion_of_bk:box = new box(bk.width, bk.height * .75);
				image_portion_of_bk.y = 2;
				bk.addChild(image_portion_of_bk);
				var thumb_loader_vars:ImageLoaderVars = new ImageLoaderVars();
				thumb_loader_vars.container(image_portion_of_bk);
				thumb_loader_vars.crop(true);
				thumb_loader_vars.scaleMode(ScaleMode.PROPORTIONAL_INSIDE);
				thumb_loader_vars.width(image_portion_of_bk.width);
				thumb_loader_vars.height(image_portion_of_bk.height);
				new ImageLoader(String(xml.result.children.children()[i].thumbnail_url), thumb_loader_vars).load();
				
				var txt:text = new text(String(xml.result.children.children()[i].title), main.Imree.Device.box_size - 10, new textFont('_sans', 14));
				txt.y = image_portion_of_bk.height + 5;
				txt.x = 6;
				bk.addChild(txt);
				bk.mouseChildren = false;
				bk.mouseEnabled = true;
				boxes.push(bk);
			}
			
			TweenLite.to(search_ui_wrapper, .25, { alpha:0 } );
			TweenLite.from(wrapper, .35, { alpha:0 } );
			
			function item_selected(evt:MouseEvent):void {
				var target:box = box(evt.currentTarget);
				item_toggle_selected(target);
			}
			function item_toggle_selected(target:box):void {
				var label:String = String(target.data.repository) + String(target.data.id) + String(target.data.collection);
				if (in_selections(label)) { 
					item_select_remove(target);
				} else {
					item_select_add(target);
				}
				check_top_UI_buttons();
			}
			function item_select_remove(target:box):void {
				var label:String = String(target.data.repository) + String(target.data.id) + String(target.data.collection);
				if (in_selections(label)) { 
					target.highlight_remove();
					selections.splice(selections_indexOf(label), 1);
				}
			}
			function item_select_add(target:box):void {
				var label:String = String(target.data.repository) + String(target.data.id) + String(target.data.collection);
				if (!in_selections(label)) { 
					selections.push(new data_value_pair(label, target.data));
					target.highlight();
				}
			}
			function check_top_UI_buttons():void {
				if (selections.length > 0) {
					btn_confirm.enable();
					btn_confirm.highlight();
				} else {
					btn_confirm.disable();
					btn_confirm.highlight_remove();
				}
			}
			
			
			/**
			 * Top UI Buttons
			 */
			
			var btn_cancel_UI:Button = new Button();
				btn_cancel_UI.setSize(80, 70);
				btn_cancel_UI.label = "Cancel";
			var btn_confirm_UI:Button = new Button();
				btn_confirm_UI.setSize(80, 70);
				btn_confirm_UI.label = "Import";
			btn_cancel = new smart_button(btn_cancel_UI, cancel);
			btn_confirm = new smart_button(btn_confirm_UI, confirm);
			btn_confirm.disable();
			var top_buttons:Vector.<smart_button> = new Vector.<smart_button>();
			top_buttons.push(btn_cancel, btn_confirm);
			
			function cancel(me:*= null):void {
				for each (var bk:box in boxes) {
					bk.removeEventListener(MouseEvent.CLICK, item_selected);
				}
				onDestroy();
			}
			function confirm(me:*= null):void {
				var ingestion_count:int = 0;
				for each(var selection:data_value_pair in selections) {
					ingestion_count++;
					var data:Object = { asset_repository:String(selection.value.repository), asset_id:String(selection.value.id), asset_collection:String(selection.value.collection), module_id:String(Module.module_id) };
					main.connection.server_command('ingest', data, ingest_response, true);
				}
				var ingestions:Array = [];
				var fails:int = 0;
				function ingest_response(loaderevent:LoaderEvent):void  {
					ingestion_count--;
					var answer:XML = XML(LoaderEvent(loaderevent).target.content);
					trace(answer);
					if (answer.success == "true") {
						ingestions.push(answer.result.asset_id);
					} else {
						fails++;
					}
					if (ingestion_count === 0) {
						onComplete(ingestions, fails);
						main.log('ASSET INGEST COMPLETE');
						cancel();
					}
				}
			}
			
			var search_modal:modal = new modal(w, h, top_buttons);
			search_modal.add_displayObjects_as_grid(boxes, 20);
			addChild(search_modal);
			
			for (var b:int = 0; b < boxes.length; b++) {
				i = String(b);
				if (xml.result.children.children()[i].children.children().length() > 0) {
					box(boxes[i]).data.children_xml = xml.result.children.children()[i].children.children();
					boxes[i].addEventListener(MouseEvent.CLICK, complex_object_selected);
					var book_indicator:Icon_book_background = new Icon_book_background();
					book_indicator.width = bk.width + 5;
					book_indicator.height = bk.height + 15;
					boxes[i].addChild(book_indicator);
				} else {
					boxes[i].addEventListener(MouseEvent.CLICK, item_selected);
				}
			}
			
			function complex_object_selected(me:MouseEvent):void {
				var target:box = box(me.currentTarget);
				var c_xml:XMLList = XMLList(target.data.children_xml);
				
				var child_boxes:Vector.<DisplayObjectContainer> = new Vector.<DisplayObjectContainer>();
				for (var c:int = 0; c < c_xml.length(); c++ ) {
					var child:box = new box(main.Imree.Device.box_size, main.Imree.Device.box_size);
					child_boxes.push(child);
					child.data = { repository:c_xml[c].repository, id:c_xml[c].id, collection:c_xml[c].collection };
					child.addEventListener(MouseEvent.CLICK, item_selected);
					var c_thumb_loader_vars:ImageLoaderVars = new ImageLoaderVars();
					c_thumb_loader_vars.container(child);
					c_thumb_loader_vars.crop(true);
					c_thumb_loader_vars.scaleMode(ScaleMode.PROPORTIONAL_INSIDE);
					c_thumb_loader_vars.width(child.width);
					c_thumb_loader_vars.height(child.height);
					new ImageLoader(String(c_xml[c].thumbnail_url), c_thumb_loader_vars).load();
				}
				
				var c_butt_confirm_ui:Button = new Button();
				c_butt_confirm_ui.label = "Confirm";
				c_butt_confirm_ui.setSize(80, 40);
				var c_butt_confirm:smart_button = new smart_button(c_butt_confirm_ui, c_confirm);
				function c_confirm(c_evt:MouseEvent=null):void {
					c_clean();
				}
				
				var c_butt_close_ui:Button  = new Button();
				c_butt_close_ui.label = "Cancel";
				c_butt_close_ui.setSize(80, 40);
				var c_butt_close:smart_button = new smart_button(c_butt_close_ui, c_close);
				function c_close(c_evt:MouseEvent=null):void {
					for each(var ci:box in child_boxes) {
						item_select_remove(ci);
					}
					c_clean();
				}
				
				var c_butt_all_ui:Button = new Button();
				c_butt_all_ui.label = "Select All";
				c_butt_all_ui.setSize(80, 40);
				var c_butt_all:smart_button = new smart_button(c_butt_all_ui, c_all);
				function c_all(c_evt:MouseEvent=null):void {
					for each(var ci:box in child_boxes) {
						item_select_add(ci);
					}
				}
				
				function c_clean():int {
					var c_selected:int = 0;
					for each(var ci:box in child_boxes) {
						if (ci.is_highlighted()) {
							c_selected++;
						}
						ci.removeEventListener(MouseEvent.CLICK, item_selected);
						main.clean_slate(ci);
					}
					c_xml = null;
					main.clean_slate([c_modal]);
					return c_selected;
				}
				
				var  c_buttons:Vector.<smart_button> = new Vector.<smart_button>();
				c_buttons.push(c_butt_close, c_butt_confirm, c_butt_all);
				var c_modal:modal = new modal(w, h, c_buttons);
				c_modal.add_displayObjects_as_grid(child_boxes);
				addChild(c_modal);
			}
		}
		private function in_selections(label:String):Boolean {
			for each(var i:data_value_pair in selections) {
				if (label == i.label) {
					return true;
				}
			}
			return false;
		}
		public function selections_indexOf(label:String):* {
			for (var i:String in selections) {
				if (label == selections[i].label) {
					return selections.indexOf(selections[i]);
				}
			}
			return false;
		}
		
	}

}