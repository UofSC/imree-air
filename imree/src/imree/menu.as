package imree 
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.XMLLoader;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import imree.display_helpers.smart_button;
	import imree.shortcuts.box;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class menu extends Sprite
	{
		private var contents:Vector.<DisplayObject>;
		private var menu_toggle_button:button_menu;
		private var main:Main;
		private var Imree:IMREE;
		private var animator:animate;
		private var on:Boolean;
		private var body:Sprite;
		public var size_percentage:Number;
		private var back_btn:smart_button;
		public function menu(_contents:Vector.<DisplayObject>, _main:Main, _imree:IMREE) 
		{
			contents = _contents;
			main = _main;
			Imree = _imree;
			
			var sample_btn:button_home = new button_home();
			size_percentage = .3;
			menu_toggle_button = new button_menu();
			animator = new animate(main);
			back_btn = new smart_button(new button_back(), toggle);
			on = false;
			body = new Sprite();
			this.addChild(body);
			this.addChild(menu_toggle_button);
			menu_toggle_button.addEventListener(MouseEvent.CLICK, toggle);
			update();
			for each(var Obj:DisplayObject in contents) {
				Obj.addEventListener(MouseEvent.CLICK, hide);
			}
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
			main.empty_display_object_container(body);
			Imree.UI_size(menu_toggle_button);
			Imree.UI_size(back_btn);
			for each(var P:DisplayObject in contents) {
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
			menu_toggle_button.x = 0;
			menu_toggle_button.y = 0;
			animator.off_stage(body, false);
			animator.on_stage(menu_toggle_button);
			on = false;
		}
		public function toggle(e:*=null):void {
			if (on) {
				hide();
			} else {
				show();
			}
		}
		
	}

}