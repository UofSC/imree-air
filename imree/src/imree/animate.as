package imree 
{
	import com.greensock.core.TweenCore;
	import com.greensock.data.TweenLiteVars;
	import com.greensock.easing.Cubic;
	import com.greensock.events.LoaderEvent;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class animate 
	{
		
		public var off_duration:Number;
		public var off_ease:Function;
		public var off_direction:String;
		
		public function animate() 
		{
			off_duration = .3;
			off_direction = "left";
			off_ease = Cubic.easeOut;
		}
		public function off_stage(obj:DisplayObject, destroy:Boolean = true):void {
			var vars:TweenLiteVars = new TweenLiteVars();
			if (off_direction === "left") {
				vars.x(0 - obj.width - 1);
			} else if (off_direction === "up") {
				vars.y(0 - obj.height - 1);
			}
			
			if (destroy) {
				vars.onComplete(function(e:*=null):void { obj.parent.removeChild(obj); obj = null; } );
			}
			TweenLite.to(obj, off_duration, vars); 
		}
		
	}

}