package imree.modules 
{
			
	
	import com.demonsters.debugger.MonsterDebugger;
	import com.greensock.loading.*;
	import com.greensock.loading.data.VideoLoaderVars;
	import com.greensock.loading.display.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.core.LoaderItem;
	import com.greensock.*;
	import com.greensock.TweenLite;	
	import fl.video.FLVPlayback;
	import fl.video.flvplayback_internal;
	import fl.video.SkinErrorEvent;
	import fl.video.VideoEvent;
	import fl.video.VideoPlayer;
	import fl.video.VideoScaleMode;
	import flash.system.Capabilities;
	import flash.system.TouchscreenType;
	import imree.data_helpers.Theme;
			
	import com.greensock.BlitMask;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Elastic;
	import com.greensock.events.LoaderEvent;
	import com.greensock.layout.ScaleMode;
	import com.greensock.loading.data.ImageLoaderVars;
	import com.greensock.loading.display.ContentDisplay;
	import com.greensock.loading.ImageLoader;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import imree.images.loading_spinner_sprite;
	import imree.Main;
	import imree.pages.exhibit_display;
	import imree.shortcuts.box;
	
	import flash.media.Video;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.display.MovieClip;
	
	
		
	/**
	 * ...
	 * @author jasonsteelman / Tonya Holladay
	 */
	public class module_asset_video extends module_asset
	{
		public var thumbnail_url:String;
		
		
		public function module_asset_video(_main:Main, _Exhibit:exhibit_display,_items:Vector.<module>=null) 
		{
			this.asset_url;
			super(_main, _Exhibit, _items);
			module_supports_reordering = true;	
					
		}
		
	
		
		override public function draw_thumb(_w:int = 200, _h:int = 200, Return:Boolean = false):* {
			
			thumb_wrapper = new Sprite();
			var result:box = new box(_w, _h, 0xFFFFFF, .2);
			thumb_wrapper.addChild(result);
			
			var url_request:URLRequest;
			if (asset_specific_thumb_url !== null && asset_specific_thumb_url.length > 0) {
				url_request = new URLRequest(asset_specific_thumb_url);
				var imgvars:ImageLoaderVars = new ImageLoaderVars();
				imgvars.crop(true);
				imgvars.width(_w);
				imgvars.height(_h);
				imgvars.noCache(true);
				imgvars.scaleMode(ScaleMode.PROPORTIONAL_OUTSIDE);
				imgvars.container(result);
				new ImageLoader(url_request, imgvars).load();
			} else {
				
				var vid_thumb: genericVidIcon = new genericVidIcon();
				vid_thumb.width = result.width;
				vid_thumb.height = result.height;
				result.addChild(vid_thumb);
			}
			
			
			
			
			if (onSelect !== null && Return === false) {
				thumb_wrapper.addEventListener(MouseEvent.CLICK, thumb_clicked);
		}
			if (Return) {
				return thumb_wrapper;
			} else {
				addChild(thumb_wrapper);
				return null;
			}
		}
		private function thumb_clicked(e:MouseEvent):void {
			if (onSelect !== null) {
				onSelect(t);
			}
		}
		
		override public function drop_thumb():void {
			if (thumb_wrapper !== null) {
				thumb_wrapper.removeEventListener(MouseEvent.CLICK, thumb_clicked);
			}
			super.drop_thumb();
		}
		
		override public function draw_feature(_w:int, _h:int):void {
			main.log('Loading module.module_asset_image [id:' + module_id + '] [name: ' + module_name + '] ' + asset_url);
			prepare_asset_window(_w, _h);
			
			asset_content_wrapper.removeChild(asset_content_wrapper.mask);
			asset_content_wrapper.mask = null;
			
			var a_transparent_object:box = new box(100, 100);
			asset_content_wrapper.addChild(a_transparent_object);
			
			var player:FLVPlayback = new FLVPlayback();
			player.addEventListener(VideoEvent.SKIN_LOADED, add_player);
			player.addEventListener(SkinErrorEvent.SKIN_ERROR, skin_error);
			player.skin = "SkinOverAllNoFullscreen.swf";
			
			asset_content_wrapper.removeChild(loading_indicator);
			loading_indicator = null;
			
			asset_content_wrapper.addEventListener(Event.REMOVED_FROM_STAGE, player_is_removed);
			function player_is_removed(asdf:Event):void {
				player.stop();
				player.load(null);
				player.removeEventListener(VideoEvent.SKIN_LOADED, add_player);
				player.removeEventListener(SkinErrorEvent.SKIN_ERROR, skin_error);
			}
			
			function skin_error(e:SkinErrorEvent):void {
				main.toast("Skin Error");
				add_player();
			}
			function add_player(e:*=null):void {
				player.removeEventListener(VideoEvent.SKIN_LOADED, add_player);
				player.removeEventListener(SkinErrorEvent.SKIN_ERROR, skin_error);
				
				player.skinBackgroundColor = Theme.background_color_secondary;
				if(Capabilities.touchscreenType === TouchscreenType.NONE) {
					player.skinAutoHide = true; //only mouse input
				}
				
				player.load(asset_url);
				player.scaleMode = VideoScaleMode.MAINTAIN_ASPECT_RATIO;
				player.setSize(asset_content_wrapper.width, asset_content_wrapper.height);
				player.width = asset_content_wrapper.width;
				player.height = asset_content_wrapper.height;
				player.x = 0;
				player.y = 0;
				player.playWhenEnoughDownloaded();
				
				asset_content_wrapper.addChild(player);
				
			}
			phase_feature = true;
		
		}
		
		
	}

}