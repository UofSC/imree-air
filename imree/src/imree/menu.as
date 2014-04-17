package imree 
{
	import com.greensock.easing.Cubic;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.XMLLoader;
	import com.greensock.TweenLite;
	import fl.controls.Button;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import imree.data_helpers.user_privilege;
	import imree.display_helpers.smart_button;
	import imree.modules.module;
	import imree.pages.exhibit_display;
	import imree.shortcuts.box;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class menu extends Sprite
	{
		public var contents:Vector.<DisplayObject>;
		private var menu_toggle_button:button_menu;
		private var main:Main;
		private var Imree:IMREE;
		private var animator:animate;
		private var on:Boolean;
		private var body:Sprite;
		public var size_percentage:Number;
		private var back_btn:smart_button;
		private var edit_current_mod:Button;
		private var edit_current_exhibit:Button;
		private var super_admin:button_SuperAdmin;
		public function menu(_contents:Vector.<DisplayObject>, _main:Main, _imree:IMREE) 
		{
			contents = _contents;
			main = _main;
			Imree = _imree;
			on = false;
			size_percentage = .3;
			animator = new animate(main);
			update();
		}
		
		//not called at the moment
		public function get_privilges():void {
			if (main.connection.password_is_set()) {
				main.connection.server_command("user_rights", "", process_user_rights, true);
			}
			function process_user_rights(e:LoaderEvent):void {
				var xml:XML = XML(e.target.content);
				if (xml.results.item[0].right == "system_admin") {
					
				}
				update();
			}
		}
		
		public function update():void {
			if (menu_toggle_button !== null) {
				if (contains(menu_toggle_button)) {
					removeChild(menu_toggle_button);
				}
				menu_toggle_button.removeEventListener(MouseEvent.CLICK, toggle);
				menu_toggle_button = null;
			}
			menu_toggle_button = new button_menu();
			this.addChild(menu_toggle_button);
			menu_toggle_button.addEventListener(MouseEvent.CLICK, toggle);
			
			if (back_btn !== null) {
				back_btn.dump();
				back_btn = null;
			}
			back_btn = new smart_button(new button_back(), toggle);
			
			if (body !== null) {
				while (body.numChildren) {
					body.getChildAt(0).removeEventListener(MouseEvent.CLICK, hide);
					body.removeChildAt(0);
				}
				if (contains(body)) {
					removeChild(body);
				}
				body = null;
			}
			
			body = new Sprite();
			this.addChild(body);
			
			
			/**
			 * Setup edit buttons for the current "page" and the current exhibit
			 */
			if (edit_current_mod !== null) {
				edit_current_mod.removeEventListener(MouseEvent.CLICK, hide);
				edit_current_mod.removeEventListener(MouseEvent.CLICK, edit_current_mod_clicked);
				if (body.contains(edit_current_mod)) {
					body.removeChild(edit_current_mod);
				}
				if(contents.indexOf(edit_current_mod) !== false) {
					contents.splice(contents.indexOf(edit_current_mod), 1);
				}
				edit_current_mod = null;
			}
			if ( edit_current_exhibit !== null) {
				edit_current_exhibit.removeEventListener(MouseEvent.CLICK, hide);
				edit_current_exhibit.removeEventListener(MouseEvent.CLICK, edit_current_exhibit_clicked);
				if (body.contains(edit_current_exhibit)) {
					body.removeChild(edit_current_exhibit);
				}
				if(contents.indexOf(edit_current_exhibit) !== false) {
					contents.splice(contents.indexOf(edit_current_exhibit), 1);
				}
				edit_current_exhibit = null;
			}
			if (main.Imree !== null && main.Imree.current_page is exhibit_display) {
				var current_top_module:module = exhibit_display(main.Imree.current_page).current_module();
				if (current_top_module.user_can_edit) {
					edit_current_mod = new Button();
					edit_current_mod.setSize(128, 128);
					edit_current_mod.label = "Edit Module: \n" + current_top_module.module_name;
					edit_current_mod.addEventListener(MouseEvent.CLICK, edit_current_mod_clicked);
					contents.push(edit_current_mod);
				}
				if (exhibit_display(main.Imree.current_page).user_can_edit) {
					edit_current_exhibit = new Button();
					edit_current_exhibit.setSize(128, 128);
					edit_current_exhibit.label = "Edit Exhibit";
					edit_current_exhibit.addEventListener(MouseEvent.CLICK, edit_current_exhibit_clicked);
					contents.push(edit_current_exhibit);
				}
			}
			
			/**
			 * Setup super admin link
			 */
			if (super_admin !== null) {
				if (body.contains(super_admin)) {
					body.removeChild(super_admin);
				}
				contents.splice(contents.indexOf(super_admin), 1);
				super_admin.removeEventListener(MouseEvent.CLICK, super_admin_clicked);				
				super_admin = null;
			}
			if (main.User.can("exhibit", "ADMIN")) {
				super_admin = new button_SuperAdmin();
				super_admin.addEventListener(MouseEvent.CLICK, super_admin_clicked);
				contents.push(super_admin);
			}
			
			/**
			 * Process all the things
			 */
			for each(var Obj:DisplayObject in contents) {
				Obj.addEventListener(MouseEvent.CLICK, hide);
			}
			main.empty_display_object_container(body);
			Imree.UI_size(menu_toggle_button);
			Imree.UI_size(back_btn);
			for each(var P:DisplayObject in contents) {
				P.scaleX = 1;
				P.scaleY = 1;
				Imree.UI_size(P);
			}
			var placeKeeper:Number = 0;
			if (main.stage.stageWidth > main.stage.stageHeight) {
				size_percentage = (menu_toggle_button.width + 10) / main.stage.stageWidth;
				animator.on_direction = "left";
				animator.off_direction = "left";
				body.addChild(new box(main.stage.stageWidth * size_percentage, main.stage.stageHeight, 0xFFFF99, 1));
				body.addChild(back_btn);
				back_btn.x = 5;
				back_btn.y = 5;
				back_btn.rotation = 0;
				placeKeeper = back_btn.height + back_btn.y;
				for each(var j:DisplayObject in contents) {
					body.addChild(j);
					j.y = placeKeeper + 5;
					j.x = 5;
					placeKeeper += j.height +5;
				}
			} else {
				size_percentage = (menu_toggle_button.height + 10)/ main.stage.stageHeight;
				animator.on_direction = "up";
				animator.off_direction = "up";
				body.addChild(new box(main.stage.stageWidth, main.stage.stageHeight * size_percentage, 0xFFFF99, 1));
				body.addChild(back_btn);
				back_btn.rotation = 90;
				back_btn.x = back_btn.width + 5;
				back_btn.y = 5;
				placeKeeper = back_btn.width +5;
				for each(var i:DisplayObject in contents) {
					body.addChild(i);
					i.x = placeKeeper + 5;
					i.y = 5;
					placeKeeper += i.width +5;
				}
			}
			
			hide();
		}
		
		public function show(e:*=null):void {
			if (main.stage.stageWidth > main.stage.stageHeight) {
				menu_toggle_button.x = 0 - menu_toggle_button.width - 1;
			} else {
				menu_toggle_button.y = 0 - menu_toggle_button.height - 1;
			}
			body.x = 0;
			body.y = 0;
			animator.on_stage(body);
			animator.off_stage(menu_toggle_button, false);
			on = true;
		}
		public function hide(e:*=null):void {
			if (main.stage.stageWidth > main.stage.stageHeight) {
				body.x = 0 - body.width - 1;				
			} else {
				body.y = 0 - body.height - 1;
			}
			menu_toggle_button.y = 0;
			menu_toggle_button.x = 0;
			animator.off_stage(body, false);
			animator.on_stage(menu_toggle_button);
			on = false;
			var tim:Timer = new Timer(5500, 1);
			tim.addEventListener(TimerEvent.TIMER, tick);
			tim.start();
			function tick(te:TimerEvent):void {
				tim.removeEventListener(TimerEvent.TIMER, tick);
				tim = null;
				if (on === false) {
					if(main.stage.stageWidth > main.stage.stageHeight) {
						TweenLite.to(menu_toggle_button, 1, { ease:Cubic.easeInOut, x: 0 -  menu_toggle_button.width * .6 } );
					} else {
						TweenLite.to(menu_toggle_button, 1, { ease:Cubic.easeInOut, y: 0 -  menu_toggle_button.height * .6 } );
					}
				}
			}
		}
		public function toggle(e:*=null):void {
			if (on) {
				hide();
			} else {
				show();
			}
		}
		
		
		private function edit_current_mod_clicked(e:MouseEvent):void {
			if (main.Imree.current_page is exhibit_display) {
				var current_top_module:module = exhibit_display(main.Imree.current_page).current_module();
				current_top_module.draw_edit_UI(e);
			}
		}
		private function edit_current_exhibit_clicked(e:MouseEvent):void {
			if (main.Imree.current_page is exhibit_display) {
				var target:exhibit_display = exhibit_display(main.Imree.current_page);
				main.Imree.show_exhibit_admin(int(target.id));
			}
		}
		private function super_admin_clicked(e:MouseEvent):void {
			main.Imree.show_super_admin();
		}
	}

}