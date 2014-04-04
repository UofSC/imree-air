package imree.modules 
{
	import flash.display.*;
	import flash.events.*;
	import flash.media.Video;
		
	import com.greensock.BlitMask;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Elastic;
	import com.greensock.events.LoaderEvent;
	import com.greensock.layout.ScaleMode;
	import com.greensock.loading.display.ContentDisplay;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import imree.images.loading_spinner_sprite;
	import imree.Main;
	import imree.pages.exhibit_display;
	import imree.shortcuts.box;
	
	
	
	
	/**
	 * ...
	 * @author jasonsteelman / Tonya Holladay
	 */
	public class module_asset_video extends module_asset
	{
		public var thumbnail_url:String;
		
		private var videoURL:String = "Video.flv";
		
		
		public function module_asset_video(_main:Main, Exhibit:exhibit_display,_items:Vector.<module>=null) 
		{
			this.asset_url;
			super(_main, _Exhibit, _items);
			module_supports_reordering = true;
		}
		
		override public function draw_thumb(_w:int = 200, _h:int = 200, Return:Boolean = false):* {
			thumb_wrapper = new Sprite();
			
			var result:box = new box(_w, _h, 0xFFFFFF, .2);
			thumb_wrapper.addChild(result);
			
			var url_request:URLRequest = new URLRequest(asset_url);
			var url_data:URLVariables = new URLVariables();
			if (can_resize) {
				url_data.size = String(_h);
			}
			
			url_request.data = url_data;
			url_request.method = URLRequestMethod.GET;
			
		
			var videoContainer:box = new box(500, 500, 0x808080, 1, 1, 0x000000);
			addChild(videoContainer);
		
		}
		
	}

}