package imree.modules 
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import fl.containers.ScrollPane;
	import fl.events.ScrollEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.NativeDragEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import imree.display_helpers.scrollPaneFancy;
	import imree.Main;
	import imree.pages.exhibit_display;
	import imree.shortcuts.box;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class module_narrative extends module 
	{
		public var feature_item:module;
		public var caption:String;
		public var description:String;
		public var filename:String;
		public var scroller:scrollPaneFancy;
		public function module_narrative( _main:Main, _Exhibit:exhibit_display, _items:Vector.<module>=null)
		{
			super(_main, _Exhibit, _items);
		}
		
		override public function draw_feature(_w:int, _h:int):void {
			var position:int = main.Imree.Device.box_size /2 ;
			var wrapper:Sprite = new Sprite();
			var slidder:Sprite = new Sprite();
			var wrapper_handle:Sprite = new Sprite();
			slidder.addChild(wrapper_handle);
			for each(var i:module in items) {
				i.draw_feature(_w, _h);
				i.phase_feature = true;
				i.alpha = .8;
				slidder.addChild(i);
				
				if (main.Imree.Device.orientation == 'portrait') {
					i.y = position;
					position += i.height  + main.Imree.Device.box_size / 2;
					i.x = _w / 2 - i.width / 2;
				} else {
					i.x = position;
					position += i.width + main.Imree.Device.box_size / 2;
					i.y = _h / 2 - i.height / 2;
				}
				i.slide_out();
				
				
			}
			
			scroller = new scrollPaneFancy();
			scroller.setSize(_w, _h);
			scroller.source = wrapper;
			
			slidder.mouseChildren = true;
			wrapper.addChild(slidder);
			scroller.update();
			scroller.drag_enable();
			addChild(scroller);
			
			if (main.Imree.Device.orientation == "portrait") {
				slidder.y = main.stage.stageHeight;
				wrapper_handle.addChild(new box(main.stage.stageWidth - 30, wrapper.height + main.Imree.Device.box_size, 0xFF00FF, 0));
			} else {
				slidder.x = main.stage.stageWidth;
				wrapper_handle.addChild(new box(wrapper.width + main.Imree.Device.box_size, main.stage.stageHeight -30, 0xFF00FF, 0));
			}
			
			TweenLite.to(slidder, 2, { y:0, x:0, ease:Cubic.easeInOut, onComplete:Exhibit.background_defocus} );
			scroller.update();
			update_items_visible_in_scroller();
			
			scroller.addEventListener(MouseEvent.MOUSE_WHEEL, scrollwheel);
			
			scroller.addEventListener(ScrollEvent.SCROLL, dragging);
			function dragging(e:ScrollEvent):void {
				update_items_visible_in_scroller(e.position);
			}
			function update_items_visible_in_scroller(ex:int=0):void {
				for each(var j:module in items) {
					if (!j.module_is_visible) {
						if (j.x < ex + scroller.width + main.Imree.Device.box_size *1.5) {
							j.slide_in();
						}
					}
				}
			}
			phase_feature = true;
		}
		override public function focus_on_sub_module(mod:module, focused:Function = null):void {
			TweenLite.to(scroller, 1, {verticalScrollPosition:mod.y - main.Imree.Device.box_size*.5, horizontalScrollPosition :mod.x - main.Imree.Device.box_size*.5, onComplete:focused} );
		}
		private function scrollwheel(e:MouseEvent):void {
			if (main.Imree.Device.orientation == 'portrait') {
				scroller.verticalScrollPosition -= e.delta * 30;
			} else {
				scroller.horizontalScrollPosition -= e.delta * 15;
			}
		}
		override public function dump():void 
		{
			if (scroller !== null) {
				scroller.removeEventListener(MouseEvent.MOUSE_WHEEL, scrollwheel);
				scroller.drag_disable();
			}
			super.dump();
		}
	}

}