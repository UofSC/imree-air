package imree.pages 
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.layout.ScaleMode;
	import com.greensock.loading.data.ImageLoaderVars;
	import com.greensock.loading.ImageLoader;
	import flash.display.Sprite;
	import imree.images.loading_spinner_sprite;
	import imree.Main;
	import imree.modules.module;
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
			wrapper.addChild(new box(w, h, 0x333333, 1));
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
					for each(var i:XML in xml.result.modules.children()) {
						modules.push(build_module(i));
					}
				} else {
					//@todo: prompt curator to add some modules
				}
				for each(var j:module in modules) {
					trace(j.module_name + "[\n" + j.trace_heirarchy(j, 1) + "\n]");
				}
				
				exhibit_cover_image_url = xml.result.exhibit_properties.exhibit_cover_image_url;
				exhibit_date_end = xml.result.exhibit_properties.exhibit_date_end;
				exhibit_date_start = xml.result.exhibit_properties.exhibit_date_start;
				exhibit_theme_id = xml.result.exhibit_properties.theme_id;
				exhibit_name = xml.result.exhibit_properties.exhibit_name;
				exhibit_sub_name = xml.result.exhibit_properties.exhibit_sub_name;
				draw_background(exhibit_cover_image_url);
				draw();
			}
			
			function build_module(xml:XML):module {
				var result:Vector.<module> = new Vector.<module>();
				if (xml.child_modules !== undefined) {
					for each(var i:XML in xml.child_modules.children()) {
						result.push(build_module(i));
					}
				}
				if (xml.child_assets !== undefined) {
					for each(var j:XML in xml.child_assets.children()) {
						result.push(build_module(j));
					}
				}
				var mod:module = new module(main, t, result);
				mod.module_name = (String(xml.module_name).length > 0 ? xml.module_name : "n/a - " + xml.module_type);
				mod.module_id = xml.module_id;
				mod.module_type = xml.module_type;
				return mod;
			}
		}
		public function draw_background(url:String):void {
			var vars:ImageLoaderVars = new ImageLoaderVars();
				vars.scaleMode(ScaleMode.PROPORTIONAL_OUTSIDE);
				vars.container(wrapper);
				vars.width(w);
				vars.height(h);
				vars.crop(true);
			new ImageLoader(url, vars).load();
		}
		public function draw():void {
			var coverfont:textFont = new textFont('_sans', 28);
			coverfont.align = TextAlign.CENTER;
			var covertext:text = new text(exhibit_name, w * .8, coverfont, height * .5);
			covertext.x = w * .1;
			covertext.y = h / 2 - covertext.height / 2;
			addChild(covertext);
		}
		public function dump():void {
			//@todo: this function should dump all the exhibit's content. likely called when loading a new exhibit
		}
	}

}