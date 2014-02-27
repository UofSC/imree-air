package imree 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import imree.display_helpers.device;
	import imree.display_helpers.smart_button;
	import imree.forms.authentication;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class IMREE extends Sprite
	{
		private var auth:authentication;
		private var main:Main;
		private var Device:device;
		public var Menu:menu
		public var menu_items:Vector.<DisplayObject>;
		public function IMREE(_main:Main) 
		{
			main = _main;
			Device = new device();
			menu_items = new Vector.<DisplayObject>();
			menu_items.push(new smart_button(new button_home(), show_home));
			if (!main.connection.password_is_set()) {
				menu_items.push(new smart_button(new button_login(), show_authentication));
			}
			Menu = new menu(menu_items,main,this);
			addChild(Menu);
		}
		
		public var UI_min_size:Number = 32;
		public var UI_max_size:Number = 128;
		public var UI_linear_slop:Number = 1 / 16;
		public var UI_linear_offset:Number = 8;
		public function UI_size(obj:DisplayObject):Number {
			var o:Rectangle = new Rectangle(0, 0, main.stage.stageWidth, main.stage.stageHeight);
			var new_width:Number;
			var new_height:Number;
			if (o.width >= o.height) {
				new_width = Math.max(Math.min(o.width * UI_linear_slop + UI_linear_offset, UI_max_size), UI_min_size); //brains
				new_height = (new_width * obj.height) / obj.width;
			} else {
				new_height = Math.max(Math.min(o.height * UI_linear_slop + UI_linear_offset, UI_max_size), UI_min_size); //brains
				new_width = (obj.width / obj.height) * new_height
			}
			obj.scaleX = new_width / obj.width;
			obj.scaleY = new_height / obj.height;
			return new_width / obj.width; //the scale factor (e.g. 0.5 = shrunk the size of obj in half)
		}
		
		public function show_authentication(e:*=null):void {
			if (auth === null) {
				auth = new authentication(main.connection, loggedIn);
			}
			addChild(auth);
			main.animator.on_stage(auth);
			function loggedIn():void {
				main.animator.off_stage(auth);
			}
		}
		public function show_home(e:*= null):void {
			trace("Instead of tracing this message, the show_home function should draw a pretty picture in the background and show a list of available exhibits :-)");
		}
		
	}

}