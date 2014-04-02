package imree.display_helpers 
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import fl.containers.ScrollPane;
	import fl.controls.ScrollBar;
	import flash.events.MouseEvent;
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
		private var drag_direction:String;
		private var current_velocity:int;
		private var drag_distance_threshold_met:Boolean = false;
		public function drag_enable(direction:String="left"):void {
			drag_direction = direction;
			if (!is_drag_enabled) {
				is_drag_enabled = true;
				addEventListener(MouseEvent.MOUSE_DOWN, drag_target_MouseDown);
			}
		}
		private function drag_target_MouseDown(e:MouseEvent):void {
			current_drag_original_point = new Point(e.stageX, e.stageY);
			addEventListener(MouseEvent.MOUSE_MOVE, drag_target_MouseMove);
			addEventListener(MouseEvent.MOUSE_UP, drag_target_MouseUp);
			addEventListener(MouseEvent.MOUSE_OUT, drag_target_MouseUp);
		}
		private function drag_target_MouseMove(e:MouseEvent):void {
			if(drag_distance_threshold_met) {
				if(e.buttonDown === true && (e.target is ScrollBar) === false) {
					mouseChildren = false;
					if (drag_direction === 'left') {
						current_velocity = ((e.stageX - current_drag_original_point.x) + (current_velocity * 2)) / 3
						horizontalScrollPosition -= e.stageX - current_drag_original_point.x;
						current_drag_original_point = new Point(e.stageX, e.stageY);
					} else {
						current_velocity = ((e.stageY - current_drag_original_point.y ) + (current_velocity * 2)) / 3;
						verticalScrollPosition -= e.stageY - current_drag_original_point.y;
						current_drag_original_point = new Point(e.stageX, e.stageY);
					}
				} else {
					drag_target_end(e);
				}
			} else {
				if (Math.abs(current_drag_original_point.x - e.stageX) + Math.abs(current_drag_original_point.y - e.stageY) > 20) {
					drag_distance_threshold_met = true;
					drag_target_MouseMove(e);
				}
			}
		}
		private function drag_target_MouseUp(e:MouseEvent):void {
			if(hitTestPoint(e.stageX, e.stageY) === false) {
				drag_target_end(e);
			}
		}
		private function drag_target_end(e:MouseEvent=null):void {
			mouseChildren = true;
			drag_distance_threshold_met = false;
			removeEventListener(MouseEvent.MOUSE_MOVE, drag_target_MouseMove);
			removeEventListener(MouseEvent.MOUSE_UP, drag_target_MouseUp);
			removeEventListener(MouseEvent.MOUSE_OUT, drag_target_MouseUp);
			if (e !== null) {
				if (drag_direction === "left") {
					current_velocity = ((e.stageX - current_drag_original_point.x) + (current_velocity * 3)) / 4
				} else {
					current_velocity = ((e.stageX - current_drag_original_point.x) + (current_velocity * 3)) / 4
				}
			}
			if (current_velocity > 10) {
				if(drag_direction === "left") {
					TweenLite.to(this, .4, { ease:Cubic.easeOut, horizontalScrollPosition:horizontalScrollPosition - current_velocity } );
				} else {
					TweenLite.to(this, .4, { ease:Cubic.easeOut, verticalScrollPosition:verticalScrollPosition - current_velocity } );
				}
			} 
			current_velocity = 0;
		}
		public function drag_disable():void {
			if (is_drag_enabled) {
				is_drag_enabled = false;
			}
			drag_target_end();
		}
	}

}