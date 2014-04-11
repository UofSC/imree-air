package imree.modules 
{
	
	import com.greensock.BlitMask;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Elastic;
	import com.greensock.events.LoaderEvent;
	import com.greensock.layout.ScaleMode;
	import com.greensock.loading.data.ImageLoaderVars;
	import com.greensock.loading.data.MP3LoaderVars;
	import com.greensock.loading.display.ContentDisplay;
	import com.greensock.loading.ImageLoader;
	import com.greensock.TweenLite;
	import com.greensock.loading.*;
	import com.greensock.*;
	
	
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
	
	
	
	
	/**
	 * ...
	 * @author jasonsteelman / Tonya Holladay
	 */
	public class module_asset_audio extends module_asset
	{
			public var thumbnail_url:String;
		
		
		public var loading_indicator:loading_spinner_sprite;
		
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
			} else {
				
				var audio_thumb: GenericAudio = new GenericAudio(); 
				audio_thumb.width = result.width;
				audio_thumb.height = result.height;
				result.addChild(audio_thumb);			
				
				//url_request = new URLRequest("http://images3.alphacoders.com/377/3779.jpg"); //generic thumb
			}
			
			
			
			var imgvars:ImageLoaderVars = new ImageLoaderVars();
			imgvars.crop(true);
			imgvars.width(_w);
			imgvars.height(_h);
			imgvars.noCache(true);
			imgvars.scaleMode(ScaleMode.PROPORTIONAL_OUTSIDE);
			imgvars.container(result);
			new ImageLoader(url_request, imgvars).load();
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
			var wrapper:box = new box(draw_feature_on_object.width, draw_feature_on_object.height);
			if (draw_feature_on_object !== null) {
				main.log('Loading module.module_asset_image [id:' + module_id + '] [name: ' + module_name + '] ' + asset_url);
				
				
				var vars:MP3LoaderVars = main.aud_loader_vars(draw_feature_on_object);
				vars.noCache(true);
					vars.scaleMode(ScaleMode.PROPORTIONAL_INSIDE);
					vars.onComplete(aud_downloaded);
					vars.crop(false);
					vars.autoPlay(true);
				new MP3LoaderLoader(asset_url, vars).load();
				
				/*var player:FLVPlayback = new FLVPlayback();
				player.setSize(draw_feature_on_object.width, draw_feature_on_object.height);
				player.load(asset_url);
				player.skin = "SkinOverAllNoFullscreen.swf";
				player.skinBackgroundColor = 0x808080;
				player.skinAutoHide = true;
				player.autoPlay = true;
				draw_feature_on_object.addChild(player);*/
				
				loading_indicator = new loading_spinner_sprite();
				loading_indicator.blendMode = BlendMode.SCREEN;
				//draw_feature_on_object.addChild(loading_indicator);
				loading_indicator.x = _w/ 2 - 128/2;
				loading_indicator.y = _h/ 2 - 128/2;
			} else {
				main.log('you need to have set the draw_feature_on_object from outside the module before calling draw_feature()');
			}
			
			function aud_downloaded(e:LoaderEvent):void {
				draw_feature_on_object.removeChild(loading_indicator);
				loading_indicator = null;
				
				
				
				var original_width:int = draw_feature_on_object.width;
				var original_height:int = draw_feature_on_object.height;
				
				
				draw_feature_on_object.addChild(wrapper);
				
				
			}
			phase_feature = true;
			
		
		}
		
		
		
		
		
		
		
		
		
		}
		
	}

}