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
	import UniversityLibrariesLogo;
	
	
	/**
	 * ...
	 * @author Tonya Holladay
	 */
	public class Preloader extends Sprite
	{
		
		public var wrapper:Sprite;
		public function Preloader() 
		{
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
			}
			
		}
		
		public function hide():void {
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