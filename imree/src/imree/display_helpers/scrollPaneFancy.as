package imree.display_helpers 
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import fl.containers.ScrollPane;
	import fl.controls.ScrollBar;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import imree.shortcuts.box;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class scrollPaneFancy extends ScrollPane
	{
		
		public function scrollPaneFancy() 
		{
			super()
		}
		
		private var is_drag_enabled:Boolean = false;
		private var current_drag_original_point:Point;
		public var drag_direction:String;
		private var current_velocity:int;
		private var drag_distance_threshold_met:Boolean = false;
		public function drag_enable(direction:String="left"):void {
			drag_direction = direction;
			if (!is_drag_enabled) {
				is_drag_enabled = true;
				drag_distance_threshold_met = false;
				addEventListener(MouseEvent.MOUSE_DOWN, drag_target_MouseDown);
				current_velocity = 0;
			}
		}
		private function drag_target_MouseDown(e:MouseEvent):void {
			current_drag_original_point = new Point(e.stageX, e.stageY);
			addEventListener(MouseEvent.MOUSE_MOVE, drag_target_MouseMove);
			addEventListener(TouchEvent.TOUCH_END, drag_target_MouseUp);
			addEventListener(MouseEvent.MOUSE_UP, drag_target_MouseUp);
			addEventListener(MouseEvent.MOUSE_OUT, drag_target_MouseUp);
		}
		private function drag_target_MouseMove(e:Event=null):void {
			if(drag_distance_threshold_met) {
				if(((e is MouseEvent && MouseEvent(e).buttonDown === true) || (e is TouchEvent && TouchEvent(e).isPrimaryTouchPoint)) && (e.target is ScrollBar) === false) {
					mouseChildren = false;
					if (drag_direction === 'left') {
						current_velocity = ((this.mouseX - current_drag_original_point.x) + (current_velocity * 2)) / 3
						horizontalScrollPosition -= this.mouseX - current_drag_original_point.x;						
					} else {
						current_velocity = ((this.mouseY - current_drag_original_point.y ) + (current_velocity * 2)) / 3;
						verticalScrollPosition -= this.mouseY - current_drag_original_point.y;
					}
					current_drag_original_point = new Point(this.mouseX, this.mouseY);
				} else {
					drag_target_end(e);
				}
			} else {
				if (Math.abs(current_drag_original_point.x - this.mouseX) + Math.abs(current_drag_original_point.y - this.mouseY) > 20) {
					drag_distance_threshold_met = true;
					drag_target_MouseMove(e);
				}
			}
			
		}
		private function drag_target_MouseUp(e:Event):void {
			if(hitTestPoint(this.mouseX, this.mouseY) === false) {
				drag_target_end(e);
			}
		}
		private function drag_target_end(e:Event=null):void {
			mouseChildren = true;
			drag_distance_threshold_met = false;
			removeEventListener(MouseEvent.MOUSE_MOVE, drag_target_MouseMove);
			removeEventListener(MouseEvent.MOUSE_UP, drag_target_MouseUp);
			removeEventListener(TouchEvent.TOUCH_END, drag_target_MouseUp);
			removeEventListener(MouseEvent.MOUSE_OUT, drag_target_MouseUp);
			if (e !== null) {
				if (drag_direction === "left") {
					current_velocity = ((this.mouseX - current_drag_original_point.x) + (current_velocity * 2)) / 3
				} else {
					current_velocity = ((this.mouseY - current_drag_original_point.y ) + (current_velocity * 2)) / 3;
				}
			}
			if (current_velocity > 10) {
				if(drag_direction === "left") {
					//TweenLite.to(this, .4, { ease:Cubic.easeOut, horizontalScrollPosition:horizontalScrollPosition - current_velocity } );
				} else {
					//TweenLite.to(this, .4, { ease:Cubic.easeOut, verticalScrollPosition:verticalScrollPosition - current_velocity } );
				}
			} 
		}
		public function drag_disable():void {
			if (is_drag_enabled) {
				is_drag_enabled = false;
			}
			drag_target_end();
		}
	}

}