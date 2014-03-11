package imree.pages 
{
	import com.greensock.easing.Cubic;
	import com.greensock.events.LoaderEvent;
	import com.greensock.layout.ScaleMode;
	import com.greensock.loading.data.ImageLoaderVars;
	import com.greensock.loading.ImageLoader;
	import com.greensock.*; 
	import com.greensock.easing.*;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import imree.images.loading_spinner_sprite;
	import imree.Main;
	import imree.modules.module;
	import imree.modules.module_asset;
	import imree.modules.module_asset_image;
	import imree.modules.module_grid;
	import imree.modules.module_narrative;
	import imree.modules.module_next;
	import imree.modules.module_title;
	import imree.shortcuts.box;
	import imree.text;
	import imree.textFont;
	import flashx.textLayout.formats.TextAlign;
	
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class exhibit_display extends Sprite
	{
		public var id:int;
		public var w:int;
		public var h:int;
		public var modules:Vector.<module>;
		public var exhibit_name:String;
		public var exhibit_sub_name:String;
		public var exhibit_date_start:String;
		public var exhibit_date_end:String;
		public var exhibit_theme_id:String;
		public var exhibit_cover_image_url:String;
		private var main:Main;
		private var wrapper:Sprite;
		public var asset_wrapper:Sprite;
		private var spinner:loading_spinner_sprite;
		private var t:exhibit_display;
		public function exhibit_display(_id:int, _w:int, _h:int, _main:Main) 
		{
			id = _id;
			w = _w;
			h = _h;
			main = _main;
			t = this;
			wrapper = new Sprite();
			var bk:box = new box(w * 1.3, h * 1.3, 0x333333, 1);
			wrapper.addChild(bk);
			wrapper.x -= w * .15;
			wrapper.y -= h * .15;
			addChild(wrapper);
			main.animator.on_stage(this);
			spinner = new loading_spinner_sprite();
			wrapper.addChild(spinner);
			spinner.x = w / 2 - spinner.width / 2;
			spinner.y = h / 2 - spinner.height / 2;
		}
		
		public function load():void {
			main.connection.server_command("exhibit_data", id, data_loaded);
			function data_loaded(e:LoaderEvent):void {
				wrapper.removeChild(spinner);
				spinner = null;
				var xml:XML = XML(e.target.content);
				modules = new Vector.<module>();
				if (xml.result.modules !== undefined) {
					for (var i:int = 0; i < xml.result.modules.children().length(); i++ ) {
						modules.push(build_module(xml.result.modules.children()[i],  i+1 !==  xml.result.modules.children().length()));
					}
				} else {
					//@todo: prompt curator to add some modules
				}
				
				trace("\n\nEXHIBIT DATA XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
				for each(var j:module in modules) {
					trace(j.module_name +  " [" + j.module_type + "] " + "{" + j.trace_heirarchy(j, 1) + "\n}");
				}
				
				exhibit_cover_image_url = xml.result.exhibit_properties.exhibit_cover_image_url;
				exhibit_date_end = xml.result.exhibit_properties.exhibit_date_end;
				exhibit_date_start = xml.result.exhibit_properties.exhibit_date_start;
				exhibit_theme_id = xml.result.exhibit_properties.theme_id;
				exhibit_name = xml.result.exhibit_properties.exhibit_name;
				exhibit_sub_name = xml.result.exhibit_properties.exhibit_sub_name;
				draw_background(exhibit_cover_image_url);
				draw(0);
			}
			
			function build_module(xml:XML, has_next:Boolean):module {
				var result:Vector.<module> = new Vector.<module>();
				if (xml.child_modules !== undefined) {
					for each(var i:XML in xml.child_modules.children()) {
						result.push(build_module(i, false));
					}
				}
				if (xml.child_assets !== undefined) {
					for each(var j:XML in xml.child_assets.children()) {
						result.push(build_module(j, false));
					}
				}
				if (has_next) {
					var next_button_module:module_next = new module_next(main, t, null);
					result.push(next_button_module);
					next_button_module.onSelect = draw_next;
				}
				
				
				/**
				 * module, asset type switcher
				 */
				if (xml.asset == '1') {
					var asset:module_asset;
					var mime_parts:Array = String(xml.module_type).toLowerCase().split('/');
					if (mime_parts[0] == "image") {
						asset = new module_asset_image(main, t, result);
					} else {
						asset = new module_asset(main, t, result);
					}
					asset.module_name = xml.module_asset_title;
					asset.caption = xml.caption;
					asset.description = xml.description;
					asset.filename = xml.asset_data_name;
					asset.module_type = xml.module_type;
					asset.module_id = null; //redundant, but a reminder
					asset.asset_url = xml.asset_url;
					if (xml.asset_resizeable == '1') {
						asset.can_resize = true;
					}
					asset.thumb_display_columns = xml.thumb_display_columns;
					asset.thumb_display_rows = xml.thumb_display_rows;
					asset.onSelect = bring_asset_to_front;
					return asset;
					
				} else {
					var type:String = String(xml.module_type).toLowerCase();
					var mod:module;
					if(type == 'narrative') {
						mod = new module_narrative(main, t, result);
					} else if (type == 'grid') {
						mod = new module_grid(main, t, result);
					} else if ( type == 'title') {
						mod = new module_title(main, t, result);
					} else {
						mod = new module(main, t, result);
					}
					
					
					mod.module_name = (String(xml.module_name).length > 0 ? xml.module_name : "n/a - " + xml.module_type);
					mod.module_sub_name = xml.module_sub_name;
					mod.module_id = xml.module_id;
					mod.module_type = xml.module_type;
					mod.thumb_display_columns = xml.thumb_display_columns;
					mod.thumb_display_rows = xml.thumb_display_rows;
					return mod;
				}
				
			}
		}
		public function bring_asset_to_front(e:module_asset):void {
			asset_wrapper = new Sprite();
			
			var asset_underlay:box = new box(w, h, 0xDEDEDE, .5);
			asset_wrapper.addChild(asset_underlay);
			TweenLite.from(asset_underlay, 1, { alpha:0 } );
			asset_underlay.addEventListener(MouseEvent.CLICK, remove_asset_wrapper);
			
			addChild(asset_wrapper);
			var asset_background:box;
			var asset_description:text;
			var asset_feature_wrapper:box;
			if (main.Imree.Device.orientation == 'portrait') {
				asset_background = new box(w, h * .9, 0x959595, 1);
				asset_wrapper.addChild(asset_background);
				asset_background.y = h * .1;
				if (e.description !== null && e.description.length > 0) {
					asset_description = new text(e.description, asset_background.width - 20, new textFont(), asset_background.height * .3);
					asset_feature_wrapper = new box(asset_background.width, asset_background.height * .65);
					asset_description.x = 10;
					asset_description.y = asset_background.height * .68;
				} else {
					asset_feature_wrapper = new box(asset_background.width, asset_background.height);
				}
			} else {
				asset_background = new box(w * .9, h, 0x959595, 1);
				asset_wrapper.addChild(asset_background);
				asset_background.x = w * .1;
				if (e.description !== null && e.description.length > 0) {
					asset_description = new text(e.description, asset_background.width *.3, new textFont(), asset_background.height-20);
					asset_feature_wrapper = new box(asset_background.width * .65, asset_background.height, 0x00FF00,.5 );
					asset_description.x = asset_background.width * .68;
					asset_description.y = 10;
				} else {
					asset_feature_wrapper = new box(asset_background.width, asset_background.height);
				}
			}
			if (asset_description !== null) {
				asset_background.addChild(asset_description);
			}
			main.animator.on_stage(asset_background);
			
			asset_background.addChild(asset_feature_wrapper);
			e.draw_feature_on_object = asset_feature_wrapper;
			e.draw_feature(asset_feature_wrapper.width, asset_feature_wrapper.height);
		}
		public function remove_asset_wrapper(e:*= null):void {
			if (asset_wrapper !== null) {
				main.animator.off_stage(asset_wrapper);
			}
		}
		public function draw_background(url:String):void {
			new ImageLoader(url, main.img_loader_vars(wrapper)).load();
		}
		
		private var background_infocus:Boolean = true;
		public function background_defocus(e:*= null):void {
			if(background_infocus) {
				TweenMax.to(wrapper, 2, { blurFilter: { blurX:10, blurY:10, quality:1 }, scaleX:.9, scaleY:.9, x:wrapper.x + wrapper.width * .05, y:wrapper.y + wrapper.height * .05, ease:Cubic.easeInOut } );
				background_infocus = false;
			}
		}
		
		public var current_module_i:int = 0;
		public function draw_next(e:*=null):void {
			dump_module(current_module_i);
			if (current_module_i + 1 > modules.length) {
				current_module_i = 0;
			} else {
				current_module_i++;
			}
			draw(current_module_i);
		}
		public function draw(id:int):void {
			modules[id].draw_feature(stage.stageWidth, stage.stageHeight);
			addChild(modules[int(id)]);
		}
		
		public function dump_module(i:int):void {
			var freeze:BitmapData = new BitmapData(modules[i].width, modules[i].height);
			freeze.draw(modules[i]);
			var freeze_obj:Bitmap = new Bitmap(freeze, 'auto', true);
			freeze_obj.x = modules[i].x;
			freeze_obj.y = modules[i].y;
			addChild(freeze_obj);
			modules[i].dump();
			removeChild(modules[i]);
			main.animator.off_stage(freeze_obj);
		}
	}

}