package imree.pages 
{
	import com.greensock.TweenLite;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import Garnet;
	import imree.Main;
	import UniversityLibrariesLogo;
	
	
	/**
	 * ...
	 * @author Tonya Holladay
	 */
	public class Preloader extends Sprite
	{
		
		public var wrapper:Sprite;
		private var main:Main;
		private var on_stage:Boolean = false;
		public function Preloader(_main:Main) 
		{
			main = _main;
			this.addEventListener(Event.ADDED_TO_STAGE, added2stage);
			
			function added2stage(e:*= null):void {
				removeEventListener(Event.ADDED_TO_STAGE, added2stage);
				wrapper = new Sprite();
				var garnet: Sprite = new Garnet();
				garnet.width = stage.stageWidth;
				garnet.height = stage.stageHeight;
				wrapper.addChild(garnet);
				
				var UniLogo:Sprite = new UniversityLibrariesLogo();
				wrapper.addChild(UniLogo);
				
				addChild(wrapper);
				TweenLite.from(wrapper, 2, { alpha:0 } );
				on_stage = true;
				stage.addEventListener(Event.ENTER_FRAME, show_on_top);
			}
			
		}
		private function show_on_top(e:Event):void {
			if (on_stage) {
				if(main.numChildren !== main.getChildIndex(main.preloader) +1) {
					main.removeChild(main.preloader);
					main.addChild(main.preloader);
				}
			}
		}
		public function hide():void {
			stage.removeEventListener(Event.ENTER_FRAME, show_on_top);
			on_stage = false;
			var tim:Timer = new Timer(2000);
			tim.addEventListener(TimerEvent.TIMER, tick);
			tim.start();
			function tick(e:*= null):void {
				tim.stop();
				tim.removeEventListener(TimerEvent.TIMER, tick);
				tim = null;
				TweenLite.to(wrapper, 2.5, { alpha:0, onComplete:removefromstage} );
				function removefromstage(e:*= null):void {
				removeChild(wrapper);
				wrapper = null;
			}
			}
			
		}
		
		
	}

}