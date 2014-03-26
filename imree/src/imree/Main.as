package imree
{
	
	//import air.update.logging.Logger;
	import com.greensock.data.TweenLiteVars;
	import com.greensock.easing.Cubic;
	import com.greensock.events.LoaderEvent;
	import com.greensock.layout.ScaleMode;
	import com.greensock.loading.core.LoaderCore;
	import com.greensock.loading.core.LoaderItem;
	import com.greensock.loading.data.ImageLoaderVars;
	import com.greensock.loading.data.LoaderMaxVars;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.ImageLoader;
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import imree.data_helpers.data_value_pair;
	import imree.data_helpers.position_data;
	import imree.data_helpers.user;
	import imree.display_helpers.*;
	import imree.forms.*;
	import imree.images.loading_flower_sprite;
	import imree.pages.Preloader;
	import imree.shortcuts.box;
	import imree.keycommander;
	import imree.signage.signage_stack;
	
	
	
	/**
	 * ...
	 * @author Jason Steelman <uscart@gmail.com>, Tonya Holladay, add yur name here as you work on this project/file
	 */
	public class Main extends Sprite 
	{
		public var connection:serverConnect;
		
		public var animator:animate;
		public var keyCommando:keycommander;
		public var Imree:IMREE;
		public var Logger:logger;
		public var Logger_IO:logger;
		public var User:user;
		public var image_loader_que:LoaderMax;
		public var preloader:Preloader;
		public function Main():void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			stage.addChild(this);
			
			preloader = new Preloader();
			addChild(preloader);
			
			animator = new animate(this);
			animator.off_direction = "up"; //should depend on theme + device_type
			
			keyCommando = new keycommander(this);
			addChild(keyCommando);
			
			Logger = new logger("General Log");
			Logger.hide();
			Logger.x = 100;
			Logger.y = 100;
			Logger_IO = new logger("IO Error/DATA Log");
			Logger_IO.hide();
			Logger_IO.x = 300;
			Logger_IO.y = 100;
			
			User = new user(this);
			
			var vars:LoaderMaxVars = new LoaderMaxVars();
				vars.maxConnections(2);
				vars.autoLoad(true);
				vars.auditSize(false);
			image_loader_que = new LoaderMax();
			LoaderMax.activate([ImageLoader]);
			image_loader_que.load();
			
			
			connection = new serverConnect("http://imree.tcl.sc.edu/imree-php/api/", this);
			connection.server_command("signage_mode", '', sign_mode_loader);
			function sign_mode_loader(evt:LoaderEvent):void {
				var xml:XML = XML(evt.currentTarget.content);
				if (xml.result.signage_mode == 'signage') {
					trace("Based on our IP, this device has been instructed to be digital signage");
					load_imree();
					preloader.hide();
				} else {
					trace("Based on our IP, this device has been instructed to be IMREE");
					load_imree();
				}
			}
			
			addChild(Logger);
			addChild(Logger_IO);
			
			removeChild(preloader);
			addChild(preloader); 
		}
		
		private function load_signage():void {
			var stack:signage_stack = new signage_stack(connection, this.stage.stageWidth, this.stage.stageHeight);
			//stage.addChild(stack);
			//var newsItemz:news_accordion_item = new news_accordion_item("Some headline", "Description Description Description Description Description Description Description Description Description Description Description Description ");
			//addChild(newsItemz);
			
			/**
			var news_accord:Vector.<news_accordion_item> = new Vector.<news_accordion_item>();
				news_accord.push(new news_accordion_item("HeadlineHeadlineHeadlineHeadlineHeadlineHeadline", "Description"));
				news_accord.push(new news_accordion_item("HeaHeadlineHeadlineHeadlineHeadlineHeadlineHeadlinedline", "Description"));
				news_accord.push(new news_accordion_item("HeaHeadlineHeadlineHeadlineHeadlinedline", "Description"));
				news_accord.push(new news_accordion_item("HeHeadlineHeadlineHeadlineHeadlineadline", "Description"));
				news_accord.push(new news_accordion_item("HeHeadlineHeadlineHeadlineadline", "Description"));
			var news_acc: news_accordion = new news_accordion(news_accord, 300, 500);
			//stage.addChild(news_acc);
			
			*/
			
			
			/*var accord:Vector.<accordion_item> = new Vector.<accordion_item>();
				accord.push(new accordion_item("Some headline", "Some Descrip"));
				accord.push(new accordion_item("Some headline", "Some Descrip"));
				accord.push(new accordion_item("Some headline", "Some Descrip"));
				accord.push(new accordion_item("Some headline", "Some Descrip"));
				accord.push(new accordion_item("Some headline", "Some Descrip"));
			var accordian:accordion = new accordion(accord, 300, 500);
			stage.addChild(accordian);
			*/


		}
		
		private function load_imree():void {
			Imree = new IMREE(this);
			addChild(Imree);
		}
		
		public function log(str:*, IO_data:String=null):void {
			if (IO_data !== null) {
				Logger_IO.add(String(str) + "\n"+ IO_data + "\n");
			}
			Logger.add(str + " SEE IO log for more");
			trace(str);
		}
		public function general_io_error(e:LoaderEvent):void {
			LoaderCore(e.target).load(true);
			log("IO ERROR: " + e.text);
		}
		public function general_loader_fail(str:*):void {
			log("IO general_loader_fail: " + str);
		}
		private function deactivate(e:Event):void 
		{
			// make sure the app behaves well (or exits) when in background
			//NativeApplication.nativeApplication.exit();
		}
		public function randomize ( a : *, b : * ) : int {
			return ( Math.random() > .5 ) ? 1 : -1;
		}
		public function empty_display_object_container(obj:DisplayObjectContainer):* {
			while (obj.numChildren) {
				obj.removeChildAt(0);
			}
			return;
		}
		public function clean_slate(obj:*):* {
			if (obj is Array) {
				for each(var i:* in obj) {
					clean_slate(i);
				}
				return;
			} else {
				var target:DisplayObjectContainer;
				if (obj !== null && obj is DisplayObjectContainer) {
					target = DisplayObjectContainer(obj);					
					if (target.parent !== null) {
						target.parent.removeChild(target);
					}
					empty_display_object_container(target);
					target = null;
				}
				return;
			}
		}
		
		
		public function img_loader_vars(container:DisplayObjectContainer):ImageLoaderVars {
			var vars:ImageLoaderVars = new ImageLoaderVars();
				vars.scaleMode(ScaleMode.PROPORTIONAL_OUTSIDE); 
				vars.container(container);
				vars.width(container.width);
				vars.height(container.height);
				vars.crop(true);
				//vars.noCache(true);
				vars.onIOError(general_io_error);
				vars.onFail(general_loader_fail);
				vars.estimatedBytes(10000);
				vars.allowMalformedURL(true);
			return vars;
		}
		
		
		public function que_image(e:LoaderCore):void {
			image_loader_que.append(e);
			image_loader_que.load();
		}
		
		public function image_is_resizeable(url:String):Boolean {
			return url.search(/\/file\/[0-9^\.]*$/gm) > -1;
		}
	}
	
}