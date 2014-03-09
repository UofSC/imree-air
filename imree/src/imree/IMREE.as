package imree 
{
	import com.greensock.loading.LoaderMax;
	import fl.controls.NumericStepper;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import imree.data_helpers.date_from_mysql;
	import imree.display_helpers.device;
	import imree.display_helpers.smart_button;
	import imree.forms.authentication;
	import imree.forms.exhibit_properties;
	import imree.pages.admin_exhibits;
	import imree.pages.home;
	import imree.pages.exhibit_display;
	import imree.shortcuts.box;
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
		public var Exhibit:exhibit_display;
		public var page_admin_exhibits:admin_exhibits;
		public var pages:Vector.<DisplayObject>;
		public var menu_items:Vector.<DisplayObject>;
		public var current_page:DisplayObject;
		public var staging_area:box;
		public var padding:int;
		public var sample_button:button_home;
		public function IMREE(_main:Main) 
		{
			main = _main;
			Device = new device(main);
			padding = 10;
			
			sample_button = new button_home();
			UI_size(sample_button);
			if (main.stage.stageWidth > main.stage.stageHeight) {
				staging_area = new box(main.stage.stageWidth - sample_button.width - padding,main.stage.stageHeight);
				staging_area.x = sample_button.width + padding;
			} else {
				staging_area = new box(main.stage.stageWidth, main.stage.stageHeight - sample_button.height - padding);
				staging_area.y = sample_button.height + padding;
			}
			
			Home = new home(main.stage.stageWidth, main.stage.stageHeight, main.connection, main);
			Home.onSelect = load_exhibit;
			addChild(Home);
			
			page_admin_exhibits = new admin_exhibits(staging_area.width, staging_area.height, main);
			page_admin_exhibits.x = staging_area.x;
			page_admin_exhibits.y = staging_area.y;
			addChild(page_admin_exhibits);
			
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
			pages.push(page_admin_exhibits);
			
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
				show_exhibit_admin();
			}
		}
		
		public function show_home(e:*= null):void {
			show(Home);
		}
		
		public function show_exhibit_admin(e:*= null):void {
			page_admin_exhibits.draw();
			show(page_admin_exhibits);
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
		public function load_exhibit(exhibit_id:*= null):void {
			if (Exhibit !== null) {
				if (Exhibit.parent !== null) {
					Exhibit.parent.removeChild(Exhibit);
				}
				Exhibit = null;
			}
			Exhibit = new exhibit_display(int(exhibit_id), main.stage.stageWidth, main.stage.stageHeight, main);
			Exhibit.load();
			pages.push(Exhibit);
			addChild(Exhibit);
			addChildAt(Menu, numChildren);
			current_page = Exhibit;
		}
		
		
	}

}