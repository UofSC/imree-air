package imree.signage 
{
	import com.greensock.layout.ScaleMode;
	import com.greensock.loading.data.ImageLoaderVars;
	import com.greensock.loading.ImageLoader;
	import flash.display.MovieClip;
	import imree.accordion;
	import imree.shortcuts.box;
	import imree.text;
	import imree.textFont;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class signage_feed_item_display extends MovieClip
	{
		public var item_data:signage_feed_item_data;
		public var target_w:int;
		public var target_h:int;
		public var background_color:uint;
		public var background_alpha:Number;
		public var border_width:int;
		public var border_color:uint;
		public var textFont_headline:textFont;
		public var textFont_body:textFont;
		public var padding:int;
		public var use_image:Boolean;
		private var t:signage_feed_item_display;
		public function signage_feed_item_display(data:signage_feed_item_data, w:int, h:int) {
			this.item_data = data;
			this.target_h = h;
			this.target_w = w;
			this.background_alpha = 0;
			this.background_color = 0xFFFFFF;
			this.border_width = 2;
			this.border_color = 0x999999;
			this.textFont_headline = new textFont('_sans',18);
			this.textFont_body = new textFont('_sans', 12);
			this.padding = 10;
			this.use_image = true;
			t = this;
		}
		public function draw():void {
			while (this.numChildren) {
				this.removeChildAt(0);
			}
			var bk:box = new box(this.target_w, this.target_h, this.background_color, this.background_alpha, this.border_width, this.border_color);
			bk.name = "background";
			this.addChild(bk);
			
			if (this.use_image && t.item_data.image_url !== null && t.item_data.image_url.length > 0) {
				var vars:ImageLoaderVars = new ImageLoaderVars();
					vars.container(bk);
					vars.crop(true);
					vars.noCache(true);
					vars.scaleMode(ScaleMode.PROPORTIONAL_OUTSIDE);
					vars.width(bk.width);
					vars.height(bk.height);
				var imgloader:ImageLoader = new ImageLoader(t.item_data.image_url, vars);
				imgloader.load();
			}
			
			var headline:text = new text(t.item_data.headline, this.target_w - (2 * this.padding), this.textFont_headline);
				headline.x += this.padding;
				headline.y += this.padding;
			this.addChild(headline);
			
			var body:text = new text(t.item_data.description, this.target_w - (2 * this.padding), this.textFont_body, target_h - headline.height);
				body.x += padding;
				body.y += headline.height + padding;
			this.addChild(body);
		}
	}

}