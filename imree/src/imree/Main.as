package imree
{
	
	import com.greensock.data.TweenLiteVars;
	import com.greensock.easing.Cubic;
	import com.greensock.events.LoaderEvent;
	import com.greensock.layout.ScaleMode;
	import com.greensock.loading.data.ImageLoaderVars;
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
	import imree.display_helpers.*;
	import imree.forms.*;
	import imree.images.loading_flower_sprite;
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
		private var Logger:logger;
		public function Main():void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			stage.addChild(this);
			
			animator = new animate(this);
			animator.off_direction = "up"; //should depend on theme + device_type
			
			keyCommando = new keycommander(this);
			addChild(keyCommando);
			
			Logger = new logger();
			addChild(Logger);
			
			
			
			connection = new serverConnect("http://imree.tcl.sc.edu/imree-php/api/");
			connection.server_command("signage_mode", '', sign_mode_loader);
			function sign_mode_loader(evt:LoaderEvent):void {
				var xml:XML = XML(evt.currentTarget.content);
				if (xml.result.signage_mode == 'signage') {
					trace("Based on our IP, this device has been instructed to be digital signage");
					load_imree();
				} else {
					trace("Based on our IP, this device has been instructed to be IMREE");
					load_imree();
				}
			}
			
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
		
		public function log(str:*):void {
			Logger.add(str);
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
		public function img_loader_vars(container:DisplayObjectContainer):ImageLoaderVars {
			var vars:ImageLoaderVars = new ImageLoaderVars();
				vars.scaleMode(ScaleMode.PROPORTIONAL_OUTSIDE); 
				vars.container(container);
				vars.width(container.width);
				vars.height(container.height);
				vars.crop(true);
			return vars;
		}
		
	}
	
}