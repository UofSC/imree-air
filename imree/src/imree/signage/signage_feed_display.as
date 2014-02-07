package imree.signage 
{
	
	import flash.display.Sprite;
	import imree.layout;
	import imree.data_helpers.position_data;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class signage_feed_display extends Sprite
	{
		public var feeds:Vector.<signage_feed_item_data>;
		public var feed_data:signage_feed_data;
		public var blocks:Vector.<signage_feed_item_display>
		public var target_w:int;
		public var target_h:int;
		public var target_style:String;
		public var padding:int;
		public var margin:int;
		public var max_items:int;
		public var min_size:int;
		public var feed_background_color:uint;
		public var feed_background_alpha:Number;
		public var feed_border_width:int;
		public var feed_border_color:uint;
		public var item_background_color:uint;
		public var item_background_alpha:Number;
		public var item_border_width:int;
		public var item_border_color:uint;
		private var stack:signage_stack;
		private var t:signage_feed_display;
		public function signage_feed_display(this_feed_data:signage_feed_data, w:int, h:int, style:String = 'static_column') 
		{
			this.feed_data = this_feed_data;
			this.feeds = this_feed_data.items;
			this.target_w = w;
			this.target_h = h;
			this.target_style = style;
			this.stack = signage_stack(this.parent);
			this.t = this;
			
			//defaults:
			this.padding = 10;
			this.margin = 10;
			this.min_size = 200;
			this.max_items = Math.floor(this.target_w / this.min_size);
			this.feed_background_color = 0xFFFFFF;
			this.feed_background_alpha = 0;
			this.feed_border_width = 0;
			this.feed_border_color = 0x666666;
			this.item_background_color = 0xFFFFFF;
			this.item_background_alpha = 0;
		}
		public function draw():void {
			while (this.numChildren) {
				this.removeChildAt(0);
			}
			while (t.feeds.length > t.max_items) {
				t.feeds.pop();
			}
			
			var solver:Vector.<position_data> =  new layout().static_row_solver(t.feeds.length, t.target_w - padding, t.target_h, t.padding);
			
			this.blocks = new Vector.<signage_feed_item_display>();
			for (var i:int = 0; i < this.feeds.length; i++ ) {
				var block:signage_feed_item_display = new signage_feed_item_display(this.feeds[i], solver[i].width, solver[i].height);
				this.addChild(block);
				block.x = solver[i].x;
				block.y = solver[i].y;
				this.blocks.push(block);
				block.draw();
			}
		}
		public function card_next():void {
			//card_goto(i++);
		}
		public function card_goto(i:int):void {
			
		}
	}

}