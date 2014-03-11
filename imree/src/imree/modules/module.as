package imree.modules 
{
	import com.greensock.easing.Cubic;
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
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
		public var main:Main;
		public var parent_module:module;
		public var Exhibit:exhibit_display;
		public var thumb_display_columns:int;
		public var thumb_display_rows:int;
		public var module_is_visible:Boolean;
		public var onSelect:Function;
		public var draw_feature_on_object:DisplayObjectContainer;
		public var t:module;
		public function module(_main:Main, _Exhibit:exhibit_display, _items:Vector.<module>=null)
		{
			items = _items;
			main = _main;
			Exhibit = _Exhibit;
			module_is_visible = true;
		}
		public function draw_thumb(_w:int = 200, _h:int = 200):void {
			
		}
		public function draw_feature(_w:int, _h:int):void {
			for each (var i:module in items) {
				i.draw_thumb();
			}
		}
		public function slide_out():void {
			if (module_is_visible) {
				module_is_visible = false;
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
		public function dump():void {
			for each(var i:module in items) {
				i.dump();
			}
			while (numChildren) {
				removeChildAt(0);
			}
		}
	}

}