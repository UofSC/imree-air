package imree 
{
	import com.greensock.layout.ScaleMode;
	import com.greensock.loading.data.ImageLoaderVars;
	import com.greensock.loading.ImageLoader;
	import flash.display.Sprite;
	import flash.events.Event;
	import imree.shortcuts.box;
	/**
	 * ...
	 * @author Tonya Holladay
	 */
	public class news_accordion_item extends Sprite
	{
		public var headline:String;
		public var description:String;
		public var imgUrl:String;
		public var w:int;
		public var h:int;
		public function news_accordion_item(Headline:String, desc:String = "", _imgUrl:String = "", _w:int = 200, _h:int = 200 ) 
		{
			this.headline = Headline;
			this.description = desc;
			this.imgUrl = _imgUrl;
			this.w = _w;
			this.h = _h;
			this.addEventListener(Event.ADDED_TO_STAGE, added2stage);
		}
		private function added2stage (e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, added2stage);
			var wrapper:box = new box(w, h, 0xDDFFFF, 1, 1);
			addChild(wrapper);
			
			var img_wrapper:box = new box(.5 * w, h - 1 );
			wrapper.addChild(img_wrapper);
			img_wrapper.x = 1;
			img_wrapper.y = 1;
			
			var headline_format:textFont = new textFont( "_sans", 26);
			var headline_text:text = new text(headline, w - img_wrapper.width - 20, headline_format);
			wrapper.addChild(headline_text);
			headline_text.x = .5 * w + 10;
			headline_text.y = 10;
			
			var desc_format:textFont = new textFont( "_sans", 16);
			var desc_text:text = new text(description, w - img_wrapper.width - 20, desc_format);
			desc_text.x = headline_text.x;
			desc_text.y = headline_text.height + 20;
			wrapper.addChild(desc_text);
			
			var img_loader_vars:ImageLoaderVars = new ImageLoaderVars();
				img_loader_vars.container(img_wrapper);
				img_loader_vars.scaleMode(ScaleMode.PROPORTIONAL_OUTSIDE);
				img_loader_vars.crop(true);
				img_loader_vars.width(img_wrapper.width);
				img_loader_vars.height(img_wrapper.height);
				
			var img_loader:ImageLoader = new ImageLoader(imgUrl, img_loader_vars);
			img_loader.load();
				
				
			
		}
		
	}

}