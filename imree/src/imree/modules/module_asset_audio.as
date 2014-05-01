package imree.modules
{
	
	//import com.demonsters.debugger.MonsterDebugger;
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
	import com.greensock.loading.display.*;
	import com.greensock.plugins.*;
	
	
	import flash.events.Event;
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
	
	TweenPlugin.activate([VolumePlugin]);
	
	/**
	 * ...
	 * @author jasonsteelman / Tonya Holladay
	 */
	public class module_asset_audio extends module_asset
	{
		public var thumbnail_url:String;
		
		
		public function module_asset_audio(_main:Main, _Exhibit:exhibit_display, _items:Vector.<module> = null)
		{
			this.asset_url;
			
			module_supports_reordering = true;
			super(_main, _Exhibit, _items);
		}
		
		override public function draw_thumb(_w:int = 200, _h:int = 200, Return:Boolean = false):*
		{
			
			thumb_wrapper = new Sprite();
			var result:box = new box(_w, _h, 0xFFFFFF, .2);
			thumb_wrapper.addChild(result);
			
			var url_request:URLRequest;
			trace("IMAGE :" + asset_specific_thumb_url);
			if (asset_specific_thumb_url !== null && asset_specific_thumb_url.length > 0) {
				url_request = new URLRequest(asset_specific_thumb_url);
				var imgvars:ImageLoaderVars = new ImageLoaderVars();
					imgvars.crop(true);
					imgvars.width(_w);
					imgvars.height(_h);
					imgvars.noCache(true);
					imgvars.scaleMode(ScaleMode.PROPORTIONAL_OUTSIDE);
					imgvars.container(result);
					imgvars.allowMalformedURL(true);
					imgvars.alternateURL(asset_specific_thumb_url);
				new ImageLoader(url_request, imgvars).load();
			} else	{
				var audio_thumb:GenericAudio = new GenericAudio();
				audio_thumb.width = result.width;
				audio_thumb.height = result.height;
				result.addChild(audio_thumb);
			}
			
			
			if (onSelect !== null && Return === false)
			{
				thumb_wrapper.addEventListener(MouseEvent.CLICK, thumb_clicked);
			}
			if (Return)
			{
				return thumb_wrapper;
			}
			else
			{
				addChild(thumb_wrapper);
				return null;
			}
		}
		
		private function thumb_clicked(e:MouseEvent):void
		{
			if (onSelect !== null)
			{
				onSelect(t);
			}
		}
		
		override public function drop_thumb():void
		{
			if (thumb_wrapper !== null)
			{
				thumb_wrapper.removeEventListener(MouseEvent.CLICK, thumb_clicked);
			}
			super.drop_thumb();
		}
		
		private var sound:MP3Loader;
		
		override public function draw_feature(_w:int, _h:int):void {
			phase_feature = true;
			main.log('Loading module.module_asset_image [id:' + module_id + '] [name: ' + module_name + '] ' + asset_url);
			
			prepare_asset_window(_w, _h);
			
			sound = new MP3Loader(asset_url, {autoPlay:true, noCache:true});
			sound.load();
			asset_content_wrapper.removeChild(loading_indicator);
			loading_indicator = null;
			
			var play_button:button_play = new button_play();
			main.Imree.UI_size(play_button);
			play_button.x = text_backgound.width / 2 - play_button.width / 2;
			play_button.y = text_backgound.height - play_button.height -30;
			text_backgound.addChild(play_button);
			var pause_button:button_pause = new button_pause();
			main.Imree.UI_size(pause_button);
			pause_button.x = play_button.x;
			pause_button.y = play_button.y;
			text_backgound.addChild(pause_button);
			play_button.visible = false;
			
			TweenLite.from(pause_button, 1, { y:pause_button.y + pause_button.height * 2, x: pause_button.x - pause_button.width * .5, scaleX:2, scaleY:2, ease:Cubic.easeOut } );
			
			play_button.addEventListener(MouseEvent.CLICK, play_button_clicked);
			function play_button_clicked(a_variable_that_dont_matter:MouseEvent):void {
				TweenLite.to(sound, .5, {volume: 1, onComplete: onCompletePause});
				play_button.visible = false;
				pause_button.visible = true;
			}
			pause_button.addEventListener(MouseEvent.CLICK, pause_button_clicked);
			function pause_button_clicked(a_variable_that_dont_matter:MouseEvent):void {
				TweenLite.to(sound, .5, {volume: 0, onComplete: onCompletePause});
				play_button.visible = true;
				pause_button.visible = false;
			}
			function onCompletePause(e:* = null):void {
				sound.paused = !sound.paused;
			}
			
			asset_content_wrapper.addEventListener(Event.REMOVED_FROM_STAGE, stop_playing_the_damn_sound);
			function stop_playing_the_damn_sound(dummy_var:Event):void {
				sound.pause();
				sound.dispose();
			}
			
			
			
			if (asset_relations.length === 1) {
				var relation:module_asset = asset_relations[0];
				relation.asset_content_wrapper = asset_content_wrapper;
				if (relation is module_asset_image) {
					relation.loading_indicator = new loading_spinner_sprite();
					relation.x = relation.asset_content_wrapper.width / 2 - relation.loading_indicator.width / 2;
					relation.y = relation.asset_content_wrapper.height/ 2 - relation.loading_indicator.height / 2;
					relation.asset_content_wrapper.addChild(relation.loading_indicator);
					relation.draw_feature_content();
				}
			}
			
		}
	
	}
}
