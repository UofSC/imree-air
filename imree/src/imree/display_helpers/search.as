package imree.display_helpers {
	import com.greensock.events.LoaderEvent;
	import com.greensock.layout.ScaleMode;
	import com.greensock.loading.data.ImageLoaderVars;
	import com.greensock.loading.ImageLoader;
	import com.greensock.TweenLite;
	import fl.containers.ScrollPane;
	import fl.controls.Button;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import imree.data_helpers.data_value_pair;
	import imree.data_helpers.position_data;
	import imree.forms.f_element_text;
	import imree.images.loading_spinner_sprite;
	import imree.layout;
	import imree.Main;
	import imree.shortcuts.box;
	import imree.text;
	import imree.textFont;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class search extends Sprite {
		
		public var onComplete:Function;
		public var onDestroy:Function;
		private var w:int;
		private var h:int;
		private var wrapper:Sprite;
		private var search_ui_wrapper:Sprite;
		private var main:Main;
		private var search_box:f_element_text;
		private var search_submit:smart_button;
		private var spinner:loading_spinner_sprite;
		public var selections:Vector.<data_value_pair>;
		private var btn_confirm:smart_button;
		private var btn_cancel:smart_button;
		public function search(_onComplete:Function, _main:Main, _onDestroy:Function, _w:int = 300, _h:int = 300) {
			onComplete = _onComplete;
			main = _main;
			onDestroy = _onDestroy;
			w = _w;
			h = _h;
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
			var scroller:scrollPaneFancy = new scrollPaneFancy();
			wrapper.addChild(scroller);
			scroller.y = 100;
			var scroller_contents:Sprite = new Sprite();
			scroller.setSize(stage.stageWidth, stage.stageHeight - 95 - search_box.get_height() -20) ;
			scroller.source = scroller_contents;
			scroller.drag_enable("top");
			if (xml.result.children.children().length() == 0) {
				trace("no results"); //@todo add visual message to results pane
			}
			var proxies:Vector.<position_data> = new Vector.<position_data>();
			for each(var x:XML in xml.result.children.children()) {
				proxies.push(new position_data(main.Imree.Device.box_size, main.Imree.Device.box_size));
			}
			var lay:layout = new layout();
			var positions:Vector.<position_data> = lay.abstract_box_solver(proxies, stage.stageWidth, stage.stageHeight * 999);
			var boxes:Vector.<box> = new Vector.<box>();
			for (var i:String in proxies) {
				var bk:box = new box(main.Imree.Device.box_size, main.Imree.Device.box_size, 0xF0F0F0, .2, 1);
				bk.data = { repository:xml.result.children.children()[i].repository, id:xml.result.children.children()[i].id, collection:xml.result.children.children()[i].collection };
				
				var image_portion_of_bk:box = new box(bk.width, bk.height / 2);
				bk.addChild(image_portion_of_bk);
				var thumb_loader_vars:ImageLoaderVars = new ImageLoaderVars();
				thumb_loader_vars.container(image_portion_of_bk);
				thumb_loader_vars.crop(true);
				thumb_loader_vars.scaleMode(ScaleMode.PROPORTIONAL_INSIDE);
				thumb_loader_vars.width(image_portion_of_bk.width);
				thumb_loader_vars.height(image_portion_of_bk.height);
				new ImageLoader(String(xml.result.children.children()[i].thumbnail_url), thumb_loader_vars).load();
				
				var txt:text = new text(String(xml.result.children.children()[i].title), main.Imree.Device.box_size - 10, new textFont('_sans', 14));
				txt.y = bk.height / 2 + 5;
				txt.x = 5;
				bk.addChild(txt);
				bk.x = positions[i].x;
				bk.y = positions[i].y;
				scroller_contents.addChild(bk);
				scroller.update();
				bk.mouseChildren = false;
				bk.mouseEnabled = true;
				bk.addEventListener(MouseEvent.CLICK, item_selected);
				boxes.push(bk);
			}
			scroller_contents.x = main.stage.stageWidth / 2 - scroller_contents.width / 2 - 20;
			scroller.update();
			
			TweenLite.to(search_ui_wrapper, .25, { alpha:0 } );
			TweenLite.from(wrapper, .35, { alpha:0 } );
			
			function item_selected(evt:MouseEvent):void {
				var target:box = box(evt.currentTarget);
				var label:String = String(target.data.repository) + String(target.data.id) + String(target.data.collection);
				if (in_selections(label)) { 
					target.highlight_remove();
					selections.splice(selections_indexOf(label), 1);
				} else {
					selections.push(new data_value_pair(label, target.data));
					target.highlight();
				}
				
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
			var butt_wrapper:box = new box(200, 85);
			wrapper.addChild(butt_wrapper);
			butt_wrapper.x = main.stage.stageWidth - butt_wrapper.width - 5;
			butt_wrapper.y = 5;
			var btn_cancel_UI:Button = new Button();
				btn_cancel_UI.setSize(75, 75);
				btn_cancel_UI.label = "Cancel";
			var btn_confirm_UI:Button = new Button();
				btn_confirm_UI.setSize(75, 75);
				btn_confirm_UI.label = "Import";
			btn_cancel = new smart_button(btn_cancel_UI, cancel);
			btn_confirm = new smart_button(btn_confirm_UI, confirm);
			btn_confirm.disable();
			butt_wrapper.addChild(btn_cancel);
			butt_wrapper.addChild(btn_confirm);
			btn_confirm.x = 80;
			
			function cancel(me:*= null):void {
				for each (var bk:box in boxes) {
					bk.removeEventListener(MouseEvent.CLICK, item_selected);
				}
				onDestroy();
			}
			function confirm(me:*= null):void {
				var ingestion_count:int = 0;
				for each(var selection:data_value_pair in selections) {
					var data:Object = { asset_repository:selection.value.repository, asset_id:selection.value.id, asset_collection:selection.value.collection };
					ingestion_count++;
					main.connection.server_command('ingest', data, ingest_response);
				}
				var ingestions:Array = [];
				var fails:int = 0;
				function ingest_response(loaderevent:LoaderEvent):void  {
					ingestion_count--;
					var answer:XML = XML(LoaderEvent(loaderevent).target.content);
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