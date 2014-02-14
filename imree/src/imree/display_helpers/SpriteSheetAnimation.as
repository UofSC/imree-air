package imree.display_helpers 
{
	import com.greensock.BlitMask;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import imree.shortcuts.box;
	/**
	 * ...
	 * @author Jason Steelman - uscart@gmail.com
	 */
	public class SpriteSheetAnimation extends Sprite
	{
		
		public function SpriteSheetAnimation(bitData:Bitmap, width:int, height:int, interval:int = 100, smooth:Boolean = true)
		{
			this.addChild(bitData);
			bitData.smoothing = true;
			var blitmask:BlitMask = new BlitMask(bitData, bitData.x, bitData.y, width, height);
			var timer:Timer = new Timer(interval);
			timer.addEventListener(TimerEvent.TIMER, tick);
			timer.start();
			
			function tick(e:TimerEvent):void {
				bitData.x -= width;
				if (bitData.x * -1 >= bitData.width) {
					bitData.x = 0;
					bitData.y -= height;
				}
				if (bitData.y * -1 >= bitData.height) {
					bitData.y = 0;
				}
				blitmask.update();
			}
			
		}
		
	}

}