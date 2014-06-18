package imree 
{
	import com.greensock.data.TweenLiteVars;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Ease;
	import com.greensock.events.LoaderEvent;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class animate 
	{
		
		public var off_duration:Number;
		public var off_ease:Ease;
		public var off_direction:String;
		
		public var on_duration:Number;
		public var on_ease:Ease;
		public var on_direction:String;
		
		private var main:Main;
		public function animate(_main:Main) 
		{
			main = _main;
			off_duration = .3;
			off_direction = "left";
			off_ease = Cubic.easeOut;
			
			on_duration = .4;
			on_direction = "right";
			on_ease = Cubic.easeOut;
		}
		public function off_stage(obj:DisplayObject, destroy:Boolean = true, hide:Boolean = false):void {
			var vars:TweenLiteVars = new TweenLiteVars();
			if (off_direction === "left") {
				vars.x(0 - obj.width - 1);
			} else if (off_direction === "up") {
				vars.y(0 - obj.height - 1);
			} else if (off_direction === "right") {
				vars.x(main.stage.stageWidth);
			} else if (off_direction === "down") {
				vars.y(main.stage.stageHeight);
			}
			
			if (destroy) {
				vars.onComplete(function(e:*=null):void { obj.parent.removeChild(obj); obj = null; } );
			}
			if (hide) {
				vars.onComplete(function(e:*=null):void { obj.visible=false; } );
			}
			if(obj.visible) {
				TweenLite.to(obj, off_duration, vars); 
			}
		}
		public function on_stage(obj:DisplayObject):void {
			var vars:TweenLiteVars = new TweenLiteVars();
			if (on_direction === "right") {
				vars.x(main.stage.stageWidth + 1);
			} else if (on_direction === "down") {
				vars.y(main.stage.stageHeight + 1);
			} else if (on_direction === "left") {
				vars.x(0 - obj.width - 1);
			} else if (on_direction === "up") {
				vars.y(0 - obj.height - 1);
			}
			obj.visible = true;
			TweenLite.from(obj, on_duration, vars); 
		}
		
	}

}