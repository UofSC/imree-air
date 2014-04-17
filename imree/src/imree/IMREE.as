package imree 
{
	import com.greensock.data.TweenLiteVars;
	import com.greensock.loading.LoaderMax;
	import com.greensock.TweenLite;
	import com.sbhave.nativeExtensions.zbar.Scanner;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import imree.display_helpers.modal;
	import imree.forms.super_admin;
	import imree.modules.module;
	//import net.steelman.WifiInfoLibrary;
	import fl.controls.NumericStepper;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.InterfaceAddress;
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import imree.data_helpers.date_from_mysql;
	import imree.data_helpers.user_privilege;
	import imree.display_helpers.device;
	import imree.display_helpers.smart_button;
	import imree.forms.authentication;
	import imree.forms.exhibit_properties;
	import imree.forms.f_element_date;
	import imree.forms.f_element_WYSIWYG;
	import imree.modules.module_asset_video;
	import imree.pages.admin_exhibit;
	import imree.pages.home;
	import imree.pages.exhibit_display;
	import imree.shortcuts.box;
	/**
	 * ...
	 * @author Jason Steelman, Tonya Holladay, Tabitha Samuel
	 */
	public class IMREE extends Sprite
	{
		private var auth:authentication;
		private var main:Main;
		public var Device:device;
		public var Menu:menu
		public var Home:home;
		public var Exhibit:exhibit_display;
		public var page_admin_exhibit:modal;
		public var pages:Vector.<DisplayObject>;
		public var menu_items:Vector.<DisplayObject>;
		public var current_page:DisplayObject;
		public var staging_area:box;
		public var padding:int;
		public var sample_button:button_home;
		public function IMREE(_main:Main, start_at_exhibit:int = -1, start_at_module:int = 0, start_at_sub_module:int = 0) 
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
			
			/**
			//Turn off main IMREE display
			Home.visible = false;
			main.preloader.hide();
			*/
			
			
			Home = new home(main.stage.stageWidth, main.stage.stageHeight, main.connection, main);
			Home.onSelect = load_exhibit;
			pages = new Vector.<DisplayObject>();
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
			
			pages.push(Home);
			
			/**
			 * SECTION: test for QR code support. 
			 * Scanner.isSupported reports false negative. This is not coming from the src, but the compiled ane.
			 */
			var scanner_exists:Boolean;
			try {
				getDefinitionByName("com.sbhave.nativeExtensions.zbar.Scanner");
				scanner_exists = true;
			} catch (e:*) {
				scanner_exists = false;
			}
			if (scanner_exists) {
				try {
					new Scanner();
					Device.supports_qr = true;
				} catch (e:*) {
					Device.supports_qr = false;
				}	
			} else {
				Device.supports_qr = false;
			}
			
			if (start_at_exhibit > -1) {
				load_exhibit(start_at_exhibit, start_at_module, start_at_sub_module);
			}
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
				auth = new authentication(main.connection, loggedIn, main);
			}
			addChild(auth);
			main.animator.on_stage(auth);
			function loggedIn(xml:XML):void {
				main.User.user_is_logged_in = 		true;
				main.User.person_id = 				xml.result.user.person_id;
				main.User.person_name_last = 		xml.result.user.person_name_last;
				main.User.person_name_first = 		xml.result.user.person_name_first;
				main.User.person_title = 			xml.result.user.person_title;
				main.User.person_department_id = 		xml.result.user.person_department_id;
				main.User.person_group_id = 			xml.result.user.person_group_id;
				main.User.ul_user_id = 				xml.result.user.ul_user_id;
				
				for each(var xml:XML in xml.result.permissions.children()) {
					trace(xml);
					if (xml.name == "super_admin" && xml.value == "ADMIN") {
						main.User.user_is_superAdmin = true;
					}
					main.User.user_privileges.push(new user_privilege(xml.name, xml.value, xml.scope));
				}
				trace(main.User);
				main.animator.off_stage(auth);
				
				for each(var d:Object in Menu.contents) {
					if (d is smart_button) {
						if (smart_button(d).button is button_login) {
							Menu.contents.splice(Menu.contents.indexOf(d), 1);
						}
					}
				}
				
				Menu.update();
				for (var i:String in pages) {
					if (pages[i] is exhibit_display) {
						exhibit_display(pages[i]).update_user_privileges();
					}
					if (pages[i] is home) {
						home(pages[i]).update_user_privileges();
					}
				}
			}
		}
		
		public function show_home(e:*= null):void {
			show(Home);
			Menu.update();
		}
		
		public function show_super_admin():void {
			var mod:modal = new modal(main.stage.stageWidth, main.stage.stageHeight, null, new super_admin(main.stage.stageWidth, main.stage.stageHeight,main),null,0xFFFFFF);
			addChild(mod);
			main.animator.on_stage(mod);
		}
		
		public function show_exhibit_admin(id:int):void {
			var pg:admin_exhibit = new admin_exhibit(staging_area.width, staging_area.height, main);
			pg.draw(id);
			var mod:modal = new modal(main.stage.stageWidth, main.stage.stageHeight, null, pg);
			addChild(mod);
			main.animator.on_stage(mod);
		}
		
		public function show(page:DisplayObject):void {
			if(page !== current_page) {
				hide_all_except(page);
				main.animator.on_stage(page);
				current_page = page;
			}
		}
		
		public function hide_all_except(except:DisplayObject = null):void {
			for each(var i:DisplayObject in pages) {
				if (i !== except) {
					main.animator.off_stage(i, false, true);
				}
			}
		}
		public function load_exhibit(exhibit_id:*= null, start_at:int = 0, focus_on_sub_module:int = 0):void {
			var freeze_obj:Bitmap;
			if (Exhibit !== null) {
				if (Exhibit.parent !== null) {
					var freeze:BitmapData = new BitmapData(main.stage.stageWidth, main.stage.stageHeight,true, 0);
					freeze.draw(Exhibit);
					freeze_obj = new Bitmap(freeze, 'auto', true);
				}
				for each(var mod:module in Exhibit.modules) {
					mod.dump();
				}
				if (Exhibit.parent !== null) {
					Exhibit.parent.removeChild(Exhibit);
				}
				Exhibit = null;
			}
			Exhibit = new exhibit_display(int(exhibit_id), main.stage.stageWidth, main.stage.stageHeight, main);
			Exhibit.load(start_at, focus_on_sub_module);
			pages.push(Exhibit);
			
			if (freeze_obj !== null) {
				addChild(freeze_obj);
				TweenLite.to(freeze_obj, 1, { alpha:0, delay:1 } );
			}
			addChild(Exhibit);
			addChildAt(Menu, numChildren);
			current_page = Exhibit;
			
		}
		
		
	}

}