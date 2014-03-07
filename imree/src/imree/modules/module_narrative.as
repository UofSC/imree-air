package imree.modules 
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import fl.containers.ScrollPane;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
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
		public function module_narrative( _main:Main, _Exhibit:exhibit_display, _items:Vector.<module>=null)
		{
			super(_main, _Exhibit, _items);
		}
		
		override public function draw_feature(_w:int, _h:int):void {
			var position:int = 0;
			var wrapper:Sprite = new Sprite();
			var slidder:Sprite = new Sprite();
			var wrapper_handle:Sprite = new Sprite();
			slidder.addChild(wrapper_handle);
			for each(var i:module in items) {
				i.draw_feature(_w, _h);
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
			}
			
			var scroller:ScrollPane = new ScrollPane();
			scroller.setSize(_w, _h);
			scroller.source = wrapper;
			
			slidder.mouseChildren = true;
			wrapper.addChild(slidder);
			scroller.update();
			scroller.scrollDrag = true;
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
			
			scroller.addEventListener(MouseEvent.MOUSE_WHEEL, scrollwheel);
			function scrollwheel(e:MouseEvent):void {
				if (main.Imree.Device.orientation == 'portrait') {
					scroller.verticalScrollPosition += e.delta * 15;
				} else {
					scroller.horizontalScrollPosition -= e.delta * 15;
				}
			}
		}
		
	}

}