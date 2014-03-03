package imree 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import imree.data_helpers.date_from_mysql;
	import imree.display_helpers.device;
	import imree.display_helpers.smart_button;
	import imree.forms.authentication;
	import imree.pages.home;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class IMREE extends Sprite
	{
		private var auth:authentication;
		private var main:Main;
		public var Device:device;
		public var Menu:menu
		public var Home:home;
		public var pages:Vector.<DisplayObject>;
		public var menu_items:Vector.<DisplayObject>;
		public var current_page:DisplayObject;
		public function IMREE(_main:Main) 
		{
			main = _main;
			Device = new device(main);
			
			
			Home = new home(main.stage.stageWidth, main.stage.stageHeight, main.connection);
			addChild(Home);
			
			current_page = Home;
			
			//menu is added last so it is on top of display list
			menu_items = new Vector.<DisplayObject>();
			menu_items.push(new smart_button(new button_home(), show_home));
			if (!main.connection.password_is_set()) {
				menu_items.push(new smart_button(new button_login(), show_authentication));
			}
			Menu = new menu(menu_items,main,this);
			addChild(Menu);
			
			pages = new Vector.<DisplayObject>();
			pages.push(Home);
			
			//testing mysqlconverter:
			var asdf:date_from_mysql = new date_from_mysql();
			trace(asdf.make_date("2014-02-03 14:30:00"));
			
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
			show(Home);
		}
		
		public function show(page:DisplayObject):void {
			if(page !== current_page) {
				hide_all_except(page);
				main.animator.on_stage(page);
			}
		}
		
		public function hide_all_except(except:DisplayObject = null):void {
			for each(var i:DisplayObject in pages) {
				if (i !== except) {
					main.animator.off_stage(i, false, true);
				}
			}
		}
		
		
	}

}