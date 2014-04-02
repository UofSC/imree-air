package imree.modules 
{
	import com.greensock.easing.Cubic;
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import fl.controls.Button;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import imree.Main;
	import imree.pages.exhibit_display;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class module extends Sprite
	{
		public var items:Vector.<module>;
		public var module_id:String;
		public var module_name:String;
		public var module_sub_name:String;
		public var module_type:String;
		public var module_order:int;
		public var main:Main;
		public var parent_module:module;
		public var Exhibit:exhibit_display;
		public var thumb_display_columns:int;
		public var thumb_display_rows:int;
		public var module_is_visible:Boolean;
		public var onSelect:Function;
		public var draw_feature_on_object:DisplayObjectContainer;
		public var t:module;
		public var user_can_use:Boolean;
		public var user_can_edit:Boolean;
		public var user_can_admin:Boolean;
		public var onUserPermissionsUpdated:Function;
		public var module_supports_reordering:Boolean = false;
		public var edit_button:Sprite;
		public var edit_background:Sprite;
		public var edit_wrapper:Sprite;
		public var phase_feature:Boolean;
		public function module(_main:Main, _Exhibit:exhibit_display, _items:Vector.<module>=null)
		{
			items = _items;
			main = _main;
			Exhibit = _Exhibit;
			phase_feature = false;
			module_is_visible = true;
			addEventListener(Event.REMOVED_FROM_STAGE, dump);
		}
		public function draw_thumb(_w:int = 200, _h:int = 200):void {
			
		}
		public function draw_feature(_w:int, _h:int):void {
			phase_feature = true;
			for each (var i:module in items) {
				i.draw_thumb();
			}
		}
		public function slide_out():void {
			if (module_is_visible) {
				module_is_visible = false;
				phase_feature = false;
				if (main.Imree.Device.orientation == 'portrait') {
					y += main.Imree.Device.box_size * 2;
				} else {
					x += main.Imree.Device.box_size * 2;
				}
			}
		}
		public function slide_in():void {
			if (!module_is_visible) {
				module_is_visible = true;
				if (main.Imree.Device.orientation == 'portrait') {
					TweenLite.to(this, .5, { y:this.y - main.Imree.Device.box_size * 2, ease:Cubic.easeOut } );
				} else {
					TweenLite.to(this, .5, { x:x - main.Imree.Device.box_size * 2, ease:Cubic.easeOut } );
				}
			}
		}
		public function trace_heirarchy(mod:module, tab:int=0):String{
			
			var tabs:Array = ["", "\t", "\t\t", "\t\t\t", "\t\t\t\t", "\t\t\t\t\t", "\t\t\t\t\t\t", "\t\t\t\t\t\t\t", "\t\t\t\t\t\t\t\t", "\t\t\t\t\t\t\t\t\t", "\t\t\t\t\t\t\t\t\t\t", "\t\t\t\t\t\t\t\t\t\t\t", "\t\t\t\t\t\t\t\t\t\t\t\t", "\t\t\t\t\t\t\t\t\t\t\t\t"];
			var str:String = "";
			for each(var i:module in mod.items) {
				if (i.items !== null && i.items.length > 0) {
					str += "\n" + tabs[tab] + i.module_name + " [" + i.module_type + "]" + " { " + trace_heirarchy(i, tab + 1) + " \n" + tabs[tab] + "}";
				} else {
					str += "\n" + tabs[tab] + i.module_name + " [" + i.module_type + "]";
				}
			}
			return str;
		}
		public function dump(e:*=null):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, dump);
			for each(var i:module in items) {
				i.dump();
				i = null;
			}
			while (numChildren) {
				if (getChildAt(0) is DisplayObjectContainer) {
					dump_recursive(DisplayObjectContainer(getChildAt(0)));
				}
				removeChildAt(0);
			}
			if (t !== null && t.parent !== null) {
				t.parent.removeChild(t);
			}
			items = null;
		}
		public function dump_recursive(obj:DisplayObjectContainer):void {
			while (obj.numChildren) {
				if (obj.getChildAt(0) is DisplayObjectContainer) {
					dump_recursive(DisplayObjectContainer(obj.getChildAt(0)));
				}
				obj.removeChildAt(0);
			}
		}
		
		public function draw_edit_button():void {
			if (phase_feature) {
				if (edit_button === null) {
					edit_button = new Sprite();
					var simple:Button = new Button();
					simple.label = "Edit";
					edit_button.addChild(simple);
				}
				if (!contains(edit_button)) {
					addChild(edit_button);
				}
			}
		}
		
		public function draw_edit_UI(e:*=null, animate:Boolean = true):void {
			trace("This module has no edit UI");
		}
		
		public function focus_on_sub_module(mod:module, focused:Function = null):void {
			//by default, this is already centered and ready, should be overriden for grids and narratives
			if (focused !== null) {
				focused();
			}
		}
		
		public function update_user_privileges(user:Boolean=true, edit:Boolean=false, admin:Boolean=false):void {
			if (String(user) + String(edit) + String(admin) !== String(user_can_use) + String(user_can_edit) + String(user_can_admin)) {
				user_can_use = user;
				user_can_edit = edit;
				user_can_admin = admin;
				for each(var i:module in items) {
					i.update_user_privileges(user, edit, admin);
				}
				if (onUserPermissionsUpdated !== null) {
					onUserPermissionsUpdated();
				}
				if (user_can_edit) {
					draw_edit_button();
				}
			}
			
		}
		
		public function change_mod_order(mod:module, new_index:int):void {
			items.splice(items.indexOf(mod), 1);
			items.splice(new_index, 0, mod);
		}
		
		override public function toString():String {
			return module_name + " " + module_type;
		}
	}

}