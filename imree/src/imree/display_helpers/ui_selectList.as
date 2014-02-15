package imree.display_helpers 
{
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import imree.data_helpers.data_value_pair;
	import imree.text;
	import imree.textFont;
	/**
	 * ...
	 * @author Jason Steelman - uscart@gmail.com
	 */
	public class ui_selectList extends Sprite
	{
		public var items:Vector.<data_value_pair>;
		public var onSelect:Function;
		public var w:int;
		public var h:int;
		public var padding:int;
		public var top_item:text;
		public var selected:data_value_pair;
		private var list:Sprite;
		private var is_open:Boolean;
		private var t:ui_selectList;
		public function ui_selectList(_items:Vector.<data_value_pair>, onSelect:Function = null, width:int=100, height:int=40) {
			this.items = _items;
			this.onSelect = onSelect;
			this.w = width;
			this.h = height;
			this.padding = 4;
			this.selected = this.items[0];
			this.is_open = false;
			t = this;
			
			var background:Sprite = new Sprite();
			background.graphics.beginFill(0xDEDEDE);
			background.graphics.lineStyle(1, 0x232323);
			background.graphics.drawRoundRect(0, 0, width, height, 5, 5);
			background.graphics.endFill();
			this.addChild(background);
			
			top_item = new text(this.selected.label, this.w - (this.padding * 2), new textFont(), this.w - (this.padding * 2));
			top_item.name = "top_item";
			top_item.x = this.padding;
			top_item.y = this.padding;
			this.addChild(top_item);
			
			this.list = new Sprite();
			for each(var i:data_value_pair in this.items) {
				var item_display:ui_selectList_item = new ui_selectList_item(i, this.w - (padding * 2), this.h - (padding * 2));
				item_display.y = list.height + padding;
				item_display.x = padding;
				list.addChild(item_display);
			}
			
			this.addEventListener(MouseEvent.CLICK, listener);
			
			function listener(evt:MouseEvent):void {
				if (is_open) {
					do_close();
				} else {
					do_open();
				}
				
				if (evt.target is ui_selectList_item) {
					t.removeChild(t.top_item);
					t.selected = new data_value_pair(ui_selectList_item(evt.target).label, ui_selectList_item(evt.target).value);
					t.top_item = new text(t.selected.label, t.w - (t.padding * 2), new textFont(), t.w - (t.padding * 2));
					top_item.name = "top_item";
					top_item.x = t.padding;
					top_item.y = t.padding;
					t.addChild(top_item);
					if (onSelect !== null) {
						onSelect(t.selected);
					}
				}
			}
 			
		}
		public function do_open():void {
			t.addChild(t.list);
			t.list.x = t.padding;
			t.list.y = t.h + t.padding;
			t.list.alpha = 0;
			t.list.scaleY = .8;
			TweenLite.to(t.list, .5, { alpha:1, scaleY:1, onComplete:complete } );
			function complete():void {
				t.is_open = true;
			}
		}
		public function do_close():void {
			TweenLite.to(t.list, .3, { alpha:0, scaleY:.8, onComplete:complete } );
			function complete():void {
				t.removeChild(t.list);
				t.is_open = false;
			}
		}
		
	}

}