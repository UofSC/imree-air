package imree.modules 
{
			
	
	import com.adobe.images.JPGEncoder;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	//import com.demonsters.debugger.MonsterDebugger;
	import com.greensock.loading.*;
	import com.greensock.loading.data.VideoLoaderVars;
	import com.greensock.loading.display.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.core.LoaderItem;
	import com.greensock.*;
	import com.greensock.TweenLite;	
	import fl.controls.Button;
	import fl.video.FLVPlayback;
	import fl.video.flvplayback_internal;
	import fl.video.SkinErrorEvent;
	import fl.video.VideoEvent;
	import fl.video.VideoPlayer;
	import fl.video.VideoScaleMode;
	import flash.display.BitmapData;
	import flash.net.NetStream;
	import flash.system.Capabilities;
	import flash.system.TouchscreenType;
	import flash.utils.ByteArray;
	import imree.data_helpers.Theme;
	import imree.display_helpers.modal;
	import imree.forms.f_data;
	import imree.forms.f_element;
			
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
	import imree.pages.exhibit_display;
	import imree.shortcuts.box;
	import imree.Main;
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
			
			var video_thumb_icon_wrapper:box = new box(thumb_wrapper.width, thumb_wrapper.height, 0xFFFFFF, .2);
			var video_thumb_icon:button_video = new button_video();
			video_thumb_icon_wrapper.x = 0;
			video_thumb_icon_wrapper.y = 0;
			
			video_thumb_icon.width = thumb_wrapper.width * .25;
			video_thumb_icon.height = thumb_wrapper.height * .25;
			video_thumb_icon.x = thumb_wrapper.width - video_thumb_icon.width;
			video_thumb_icon.y = 0;
			video_thumb_icon_wrapper.addChild(video_thumb_icon);
			thumb_wrapper.addChild(video_thumb_icon_wrapper);
			
			var url_request:URLRequest;
			if (asset_specific_thumb_url !== null && asset_specific_thumb_url.length > 0) {
				url_request = new URLRequest(main.image_url_resized(asset_specific_thumb_url, String(_h)));
				var imgvars:ImageLoaderVars = new ImageLoaderVars();
				imgvars.crop(true);
				imgvars.width(_w);
				imgvars.height(_h);
				//imgvars.noCache(true);
				imgvars.alternateURL(main.image_url_resized(asset_specific_thumb_url, String(_h)));
				imgvars.scaleMode(ScaleMode.PROPORTIONAL_OUTSIDE);
				imgvars.container(result);
				new ImageLoader(url_request, imgvars).load();
			} else {
				
				var vid_thumb:button_video = new button_video();
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
		
		public var player:FLVPlayback;
		public var editor_player:FLVPlayback;
		override public function draw_feature(_w:int, _h:int):void {
			main.log('Loading module.module_asset_image [id:' + module_id + '] [name: ' + module_name + '] ' + asset_url);
			prepare_asset_window(_w, _h);
			
			asset_content_wrapper.removeChild(asset_content_wrapper.mask);
			asset_content_wrapper.mask = null;
			
			var a_transparent_object:box = new box(100, 100);
			asset_content_wrapper.addChild(a_transparent_object);
			
			player = new FLVPlayback();
			player.addEventListener(VideoEvent.SKIN_LOADED, add_player);
			player.addEventListener(SkinErrorEvent.SKIN_ERROR, skin_error);
			player.skin = "SkinOverAllNoFullscreen.swf";
			
			asset_content_wrapper.removeChild(loading_indicator);
			loading_indicator = null;
			
			var timer:Timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, do_visibility_check);
			timer.start();
			function do_visibility_check(te:TimerEvent):void {
				if (player.stage === null) {
					player_is_removed(null);
				}
			}
			
			asset_content_wrapper.addEventListener(Event.REMOVED_FROM_STAGE, player_is_removed);
			function player_is_removed(asdf:Event):void {
				player.getVideoPlayer(0).netStream.close();
				player.getVideoPlayer(0).clear();
				player.stop();
				player.load(null);
				if (timer !== null) {
					timer.removeEventListener(TimerEvent.TIMER, do_visibility_check);
					timer.stop();
					timer = null;
				}
				
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
		
		
		override public function draw_edit_UI(e:* = null, animate:Boolean = true, start_at_position:int = 0):void {
			player.stop();
			
			var elements:Vector.<f_element> = prepare_edit_form_elements();
			var form:f_data = prepare_edit_form(elements);
			
			var edit_ui:Sprite = new Sprite();
			edit_ui.addChild(form);
			
			if (editor_player !== null) {
				editor_player = null;
			}
			editor_player = new FLVPlayback();
			editor_player.addEventListener(SkinErrorEvent.SKIN_ERROR, skin_error);
			editor_player.skin = "SkinOverAllNoFullscreen.swf";
			editor_player.skinBackgroundColor = Theme.background_color_secondary;
			editor_player.load(asset_url); 
			editor_player.setSize(400, 400);
			editor_player.x = edit_ui.width - 140;
			edit_ui.addChild(editor_player);
			
			var button_ui:Button = new Button();
			button_ui.setSize(150, 20);
			button_ui.label = "Take new snapshot";
			button_ui.addEventListener(MouseEvent.CLICK, takeSnapshot);
			button_ui.x = editor_player.x;
			button_ui.y = editor_player.height - 35;
			edit_ui.addChild(button_ui);
			
			function takeSnapshot():void {
				var nsObj:VideoPlayer = editor_player.getVideoPlayer(0);
				var target_time:Number = nsObj.playheadTime;
				if (target_time < 1) {
					target_time = 6;
				}
				var data:Object = { 'module_asset_id':module_asset_id, 'seconds':target_time};
				
				main.connection.server_command("generate_screen_grab", data, capture_ready, true);
			}
			function capture_ready(e2:*= null):void {
				main.toast("Screen capture ready");
			}
			
			function add_player(e:*=null):void {
				editor_player.removeEventListener(VideoEvent.SKIN_LOADED, add_player);
				editor_player.removeEventListener(SkinErrorEvent.SKIN_ERROR, skin_error);
				
				editor_player.skinBackgroundColor = Theme.background_color_secondary;
				if(Capabilities.touchscreenType === TouchscreenType.NONE) {
					editor_player.skinAutoHide = true; //only mouse input
				}
				
				editor_player.load(asset_url);
				editor_player.scaleMode = VideoScaleMode.MAINTAIN_ASPECT_RATIO;
				editor_player.setSize(asset_content_wrapper.width, asset_content_wrapper.height);
				editor_player.width = asset_content_wrapper.width;
				editor_player.height = asset_content_wrapper.height;
				editor_player.x = 0;
				editor_player.y = 0;
				editor_player.playWhenEnoughDownloaded();
				
				asset_content_wrapper.addChild(editor_player);
				
			}
			
			asset_editor = new modal(main.Imree.staging_area.width, main.Imree.staging_area.height, null, edit_ui);
			main.Imree.Exhibit.overlay_add(asset_editor);
			
			function skin_error(e:SkinErrorEvent):void {
				main.toast("Skin Error");
				//add_player();
			}
		}
	}

}