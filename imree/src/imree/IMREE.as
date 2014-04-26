package imree 
{
	import com.greensock.data.TweenLiteVars;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.XMLLoader;
	import com.greensock.TweenLite;
	import com.sbhave.nativeExtensions.zbar.Scanner;
	import fl.controls.Button;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.LoaderInfo;
	import flash.events.TimerEvent;
	import flash.net.navigateToURL;
	import flash.system.System;
	import flash.utils.Timer;
	import imree.data_helpers.Theme;
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
		public var theme:Theme;
		public var page_admin_exhibit:modal;
		public var pages:Vector.<DisplayObject>;
		public var menu_items:Vector.<DisplayObject>;
		public var current_page:DisplayObject;
		public var staging_area:box;
		public function IMREE(_main:Main, start_at_exhibit:int = -1, start_at_module:int = 0, start_at_sub_module:int = 0) 
		{
			main = _main;
			Device = new device(main);
			UI_width = Device.box_size / 3;
			
			var menu_can_hide:Boolean = true;
			var context_vars:Object = LoaderInfo(main.root.loaderInfo).parameters;
			if (context_vars.start_at !== null && int(context_vars.start_at) > 0 && start_at_exhibit === -1) {
				start_at_exhibit = int(context_vars.start_at);
			}
			if (context_vars.web !== null && context_vars.web == "web") {
				staging_area = new box(main.stage.stageWidth, main.stage.stageHeight - UI_width);
				staging_area.y = UI_width;
				Device.is_web_player = true;
			} else {
				Device.is_web_player = false;
				//staging_area = new box(main.stage.stageWidth, main.stage.stageHeight);
				
				staging_area = new box(main.stage.stageWidth, main.stage.stageHeight - UI_width);
				staging_area.y = UI_width;
				web_bar(UI_width);
				menu_can_hide = false;
				
			}
			
			theme = new Theme();
			theme.get_theme(1);
			
			Home = new home(staging_area.width, staging_area.height, main);
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
			Menu = new menu(menu_items,main,this,menu_can_hide);
			addChild(Menu);
			Menu.y = 0 - staging_area.y;
			
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
				Device.supports_qr = false;
			}
			if (scanner_exists) {
				try {
					new Scanner();
					Device.supports_qr = true;
				} catch (e:*) {
					Device.supports_qr = false;
				}	
			}
			
			/**
			 * Complete Imree definitions
			 */
			if (start_at_exhibit > -1) {
				load_exhibit(start_at_exhibit, start_at_module, start_at_sub_module);
			}
			
			addEventListener(Event.RESIZE, stage_resized);
		}
		
		public function location_aware():void {
			main.toast("Location Aware");
			var timer:Timer = new Timer(2000,0);
			timer.addEventListener(TimerEvent.TIMER, update_device_location);
			timer.start();
			
			function update_device_location(e:TimerEvent):void {
				main.connection.server_command("device_is_at_location", "", new_location);
				timer.stop();
			}
			function new_location(e:LoaderEvent):void {
				var location:XML = XML(XMLLoader(e.target).content);
				if (location.success == 'true') {
					if (current_page !== null && current_page is exhibit_display && exhibit_display(current_page).id == location.result.exhibit_id && exhibit_display(current_page).current_module() !== null) {
						var start_at:int = 0;
						var start_at_index:int = 0;
						var sub_module_index:int = 0;
						var sub_module:module;
						for each(var mod:module in exhibit_display(current_page).modules) {
							if (mod.module_id == location.result.start_at) {
								start_at = int(location.result.start_at);
								start_at_index = exhibit_display(current_page).modules.indexOf(mod);
							}
						}
						if (location.result.sub_module != 0) {
							for each(var mod2:module in exhibit_display(current_page).modules[start_at_index].items) {
								main.log_to_server("mod_id:" + mod2.module_id + " VS target:" + location.result.sub_module + " with index: " + exhibit_display(current_page).modules[start_at_index].items.indexOf(mod2));
								if (location.result.sub_module != mod2.module_id) {
									sub_module = mod2;
									sub_module_index = exhibit_display(current_page).modules[start_at_index].items.indexOf(mod2);
								}
							}
						}
						
						
						
						if (exhibit_display(current_page).current_module().module_id == String(start_at)) {
							if (sub_module_index != 0) {
								main.toast("Focusing on " + start_at + "." + sub_module_index);
								exhibit_display(current_page).current_module().focus_on_sub_module(sub_module);
							} else {
								main.toast("Already at target " + start_at + "." + sub_module_index);
							}
							
						} else {
							main.toast("Loading Page " + start_at + "." + sub_module_index);
							exhibit_display(current_page).load(start_at,sub_module_index);
						}
					}
				} else {
					main.toast("Location Failed");
				}
				
				timer.reset();
				timer.start();
				
			}
			
		}
		
		public static var UI_width:int;
		public function UI_size(obj:DisplayObject):Number {
			var new_width:Number = UI_width;
			var new_height:Number = (obj.height / obj.width) * new_width;
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
		
		private var super_admin_instance:super_admin;
		public function show_super_admin():void {
			var buttons:Vector.<smart_button> = new Vector.<smart_button>();
			var close_button:Button = new Button();
				close_button.label = "Close";
				buttons.push(new smart_button(close_button, close_super_admin));
			super_admin_instance = new super_admin(staging_area.width, staging_area.height, main);
			var mod:modal = new modal(staging_area.width, staging_area.height, null, super_admin_instance,null,0xFFFFFF);
			addChild(mod);
			main.animator.on_stage(mod);
			
			var start_tracker_button_ui:Button = new Button();
			start_tracker_button_ui.label = "Start Device Tracking";
			var start_tracker_button:smart_button = new smart_button(start_tracker_button_ui, start_tracker_click);
			
			var stop_tracker_button_ui:Button = new Button();
			stop_tracker_button_ui.label = "Stop Device Tracking";
			var stop_tracker_button:smart_button = new smart_button(stop_tracker_button_ui, stop_tracker_click);
			
			main.connection.server_command("device_is_tracking", '', response_device_is_tracking);
			function response_device_is_tracking(e:LoaderEvent):void {
				if (XML(XMLLoader(e.target).content).result == '1') {
					mod.add_button(stop_tracker_button);
				} else {
					mod.add_button(start_tracker_button);
				}
			}
			function start_tracker_click(e:*= null):void {
				var values:Object = { 'device_mode':'tablet', 'device_name':'unnamed' };
				main.connection.server_command("device_tracking_start", values, start_tracker_response,true);
			}
			function start_tracker_response(e:LoaderEvent):void {
				mod.remove_button(start_tracker_button);
				mod.add_button(stop_tracker_button);
			}
			function stop_tracker_click(e:*= null):void {
				main.connection.server_command("device_tracking_start", "", stop_tracker_reponse, true);
			}
			function stop_tracker_reponse(e:LoaderEvent):void {
				mod.remove_button(stop_tracker_button);
				mod.add_button(start_tracker_button);
			}
			
			function close_super_admin(e:*=null):void {
				main.animator.off_stage(mod);
			}
		}
		
		public function show_exhibit_admin(id:int):void {
			var pg:admin_exhibit = new admin_exhibit(staging_area.width, staging_area.height, main);
			pg.draw();
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
			Exhibit = new exhibit_display(int(exhibit_id), staging_area.width, staging_area.height, main);
			Exhibit.load(start_at, focus_on_sub_module);
			pages.push(Exhibit);
			
			if (freeze_obj !== null) {
				addChild(freeze_obj);
				TweenLite.to(freeze_obj, 1, { alpha:0, delay:1 } );
			}
			addChild(Exhibit);
			web_bar()
			addChildAt(Menu, numChildren);
			current_page = Exhibit;
		}
		
		private var web_bar_wrapper:box;
		static private var web_bar_height:int;
		public function web_bar(bar_height:int = 0):void {
			if (web_bar_wrapper !== null) {
				if (contains(web_bar_wrapper)) {
					removeChild(web_bar_wrapper);
				}
				web_bar_wrapper = null;
			}
			if (bar_height > 0) {
				web_bar_height = bar_height;
			}
			web_bar_wrapper = new box(main.stage.stageWidth, web_bar_height, 0x73000a, 1);
			addChild(web_bar_wrapper);
			web_bar_wrapper.y = 0 - web_bar_height;
			var sample_button:button_menu = new button_menu();
			UI_size(sample_button);
			var institute:text = new text("University of South Carolina", main.stage.stageWidth - sample_button.width - 10, new textFont("AbrahamLincoln", 24));
			institute.y = web_bar_height / 2 - institute.height / 2;
			web_bar_wrapper.addChild(institute);
			institute.x = sample_button.width + 20;
			this.y = web_bar_height;
		}
		private function stage_resized(e:Event):void {
			web_bar();
			Menu.update();
			addChildAt(Menu, numChildren);
		}
		
		
	}

}