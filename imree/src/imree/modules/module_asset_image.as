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
	import com.greensock.loading.LoaderMax;
	import com.greensock.TweenLite;
	import fl.controls.Button;
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.*;
	
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.Capabilities;
	import imree.display_helpers.modal;
	import imree.display_helpers.window;
	import imree.forms.f_data;
	import imree.forms.f_element;
	import imree.images.loading_spinner_sprite;
	import imree.Main;
	import imree.pages.exhibit_display;
	import imree.shortcuts.box;
	import imree.text;
	import imree.data_helpers.Theme;
	
	import imree.display_helpers.smart_button;
	import flash.filesystem.*;
	import flash.net.FileReference; 
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLStream;
	import com.marston.utils.URLRequestWrapper;
	import imree.modules.module;
	import com.greensock.loading.data.MP3LoaderVars;
	import com.greensock.loading.*;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class module_asset_image extends module_asset
	{
		private var add_audio:smart_button;
		
		public function module_asset_image(_main:Main, _Exhibit:exhibit_display, _items:Vector.<module> = null)
		{
			t = this;
			super(_main, _Exhibit, _items);
			module_supports_reordering = true;
		
		}
		
		override public function draw_thumb(_w:int = 200, _h:int = 200, Return:Boolean = false):*
		{
			thumb_wrapper = new Sprite();
			
			var result:box = new box(_w, _h, 0xFFFFFF, .2);
			thumb_wrapper.addChild(result);
			
			var imgvars:ImageLoaderVars = new ImageLoaderVars();
			imgvars.crop(true);
			imgvars.width(_w);
			imgvars.height(_h);
			imgvars.scaleMode(ScaleMode.PROPORTIONAL_OUTSIDE);
			imgvars.container(result);
			imgvars.estimatedBytes(20000);
			
			var target_url:String = asset_url;
			if (can_resize)
			{
				target_url = main.image_url_resized(target_url, _h);
				imgvars.alternateURL(target_url);
			}
			
			new ImageLoader(target_url, imgvars).load();
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
		
		override public function draw_feature(_w:int, _h:int):void
		{
			prepare_asset_window(_w, _h);
			draw_feature_content();
			phase_feature = true;
		}
		
		override public function draw_edit_button():void
		{
			super.draw_edit_button();
		}
		
		override public function draw_edit_UI(e:* = null, animate:Boolean = true, start_at_position:int = 0):void
		{
			var elements:Vector.<f_element> = prepare_edit_form_elements();
			var form:f_data = prepare_edit_form(elements);
			var editor:Sprite = new Sprite();
			editor.addChild(form);
			var add_as_exhibit_background_ui:Button = new Button();
			add_as_exhibit_background_ui.setSize(175, 20);
			add_as_exhibit_background_ui.label = "Use as Exhibit Background";
			add_as_exhibit_background_ui.alpha = 1;
			add_as_exhibit_background_ui.addEventListener(MouseEvent.CLICK, add_as_exhibit_background_clicked);
			add_as_exhibit_background_ui.x = editor.width * 1.0;
			add_as_exhibit_background_ui.y = editor.height * .3;
			
			var ex_bkg_img:box = new box(175, 175, 0xfdfdfd, 1);
			ex_bkg_img.x = add_as_exhibit_background_ui.x;
			editor.addChild(ex_bkg_img);
			
			var imgvars_ex_tb:ImageLoaderVars = new ImageLoaderVars();
			imgvars_ex_tb.crop(true);
			imgvars_ex_tb.width(ex_bkg_img.width);
			imgvars_ex_tb.height(ex_bkg_img.height);
			imgvars_ex_tb.scaleMode(ScaleMode.PROPORTIONAL_OUTSIDE);
			imgvars_ex_tb.container(ex_bkg_img);
			imgvars_ex_tb.estimatedBytes(20000);
			
			var button_ui:Button = new Button();
			button_ui.setSize(150, 40);
			button_ui.label = "Attach an Audio file\nto this Image";
			//button_ui.addEventListener(MouseEvent.CLICK);
			button_ui.x = add_as_exhibit_background_ui.x;
			button_ui.y = add_as_exhibit_background_ui.y + 50;
			add_audio = new smart_button(button_ui, add_audio_to_image);
			editor.addChild(add_audio);
			
			var target_url:String = asset_url;
			if (can_resize)
			{
				target_url = main.image_url_resized(target_url, ex_bkg_img.height);
				imgvars_ex_tb.alternateURL(target_url);
			}
			new ImageLoader(target_url, imgvars_ex_tb).load();
			
			editor.addChild(add_as_exhibit_background_ui);
			
			asset_editor = new modal(main.Imree.staging_area.width, main.Imree.staging_area.height, null, editor);
			main.Imree.Exhibit.overlay_add(asset_editor);
		
		}
		
		//Add audio to image
		//private var f : File = new File; 
		private var fileRef : FileReference = new FileReference();
		private var loader:URLLoader;
		
		private function add_audio_to_image(me:*= null):void
		{
			fileRef.addEventListener(Event.SELECT, on_audio_selected);
			var ff:FileFilter = new FileFilter("Audio", "*.mp3");
			fileRef.browse([ff]);	
		}
		
		private function on_audio_selected(e:Event):void
		{
			fileRef.removeEventListener(Event.SELECT, on_audio_selected);
			fileRef.addEventListener(Event.COMPLETE, on_audio_loaded);
			fileRef.load();
		}
		
		private function on_audio_loaded(e:Event):void
		{
			fileRef.removeEventListener(Event.COMPLETE, on_audio_loaded);
			var bytes:ByteArray = fileRef.data;
			var urlwrapper:URLRequestWrapper = new URLRequestWrapper(bytes, "audio.mp3", null, {'command':'upload_bytes', 'module_asset_id':module_asset_id, 'change_thumbnail':false, 'module_id':0, 'username':main.connection.username, 'password':main.connection.password})
			urlwrapper.url = main.connection.uri;
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, on_audio_uploaded);
			loader.addEventListener(IOErrorEvent.IO_ERROR, camera_error);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, camera_error);
			loader.load(urlwrapper.request);
		}
		
		private function camera_error(e:*):void
		{
			main.toast(String(e));
		}
		
		private function on_audio_uploaded(e:Event):void 
		{
			loader.removeEventListener(Event.COMPLETE, on_audio_uploaded);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, camera_error);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, camera_error);
		}
		
		
		private function add_as_exhibit_background_clicked(e:MouseEvent):void
		{
			main.connection.server_command("module_asset_image_as_background_image", {'module_asset_id': module_asset_id}, add_as_exhibit_background_done, true);
			
			main.loading_indicator_add();
			
			function add_as_exhibit_background_done(f:LoaderEvent):void
			{
				main.loading_indicator_remove();
				main.toast("Added as background.");
				Exhibit.reload_current_page();
			
			}
		
		}
		
		public var image_bounding_box:box;
		private var sound:MP3Loader;
		
		override public function draw_feature_content(interactive:Boolean = true, onDownloaded:Function = null):void
		{
			
			var vars:ImageLoaderVars = main.img_loader_vars(asset_content_wrapper);
			vars.noCache(true);
			vars.onComplete(image_downloaded);
			vars.crop(false);
			vars.container(null);
			vars.scaleMode(ScaleMode.PROPORTIONAL_INSIDE);
			new ImageLoader(asset_url, vars).load();
			
			function image_downloaded(e:LoaderEvent):void
			{
				if (loading_indicator !== null && asset_content_wrapper.contains(loading_indicator))
				{
					asset_content_wrapper.removeChild(loading_indicator);
					loading_indicator = null;
				}
				var actual_image:ContentDisplay = ImageLoader(e.target).content;
				var bitmap:Bitmap = actual_image.rawContent;
				
				asset_content_wrapper.mouseChildren = false;
				asset_content_wrapper.mouseEnabled = true;
				
				/**
				 * Add bitmap and change scale
				 */
				var original_width:int = asset_content_wrapper.width;
				var original_height:int = asset_content_wrapper.height;
				var image_wrapper:box = new box(original_width, original_height);
				image_wrapper.mouseEnabled = false;
				asset_content_wrapper.addChild(image_wrapper);
				image_wrapper.addChild(bitmap);
				bitmap.scaleX = Math.min(1, bitmap.scaleX);
				bitmap.scaleY = Math.min(1, bitmap.scaleY);
				var max_scale:Number = Math.min(1 / bitmap.scaleX, 1 / bitmap.scaleY);
				
				/**
				 * Offset the registration point of bitmap to be visual center
				 */
				
				bitmap.x = 0 - bitmap.width / 2;
				bitmap.y = 0 - bitmap.height / 2;
				image_wrapper.x = (original_width / 2);
				image_wrapper.y = (original_height / 2);
				
				image_bounding_box = new box(bitmap.width, bitmap.height);
				image_bounding_box.x = bitmap.getBounds(asset_content_wrapper).x;
				image_bounding_box.y = bitmap.getBounds(asset_content_wrapper).y;
				
				
				/**
				 * Handle Mouse scroll wheel interactions
				 */
				if (interactive) {
					asset_content_wrapper.addEventListener(MouseEvent.MOUSE_WHEEL, scroll_wheel_on_image);
				}
				function scroll_wheel_on_image(m:MouseEvent):void
				{
					var factor:Number = m.delta * .1;
					if (main.Imree.Device.orientation === 'portrait')
					{
						factor *= 5;
					}
					TweenLite.to(image_wrapper, .2, {scaleX: Math.max(image_wrapper.scaleX + factor, .5), scaleY: Math.max(image_wrapper.scaleY + factor, .5), ease: Cubic.easeInOut, onComplete: check_resize});
				}
				function check_resize(m:* = null):void
				{
					if (image_wrapper.scaleX > max_scale || image_wrapper.scaleY > max_scale)
					{
						TweenLite.to(image_wrapper, .6, {scaleX: Math.max(Math.min(max_scale, image_wrapper.scaleX), .5), scaleY: Math.max(Math.min(max_scale, image_wrapper.scaleY), .5), ease: Elastic.easeOut});
					}
				}
				
				/**
				 * Handle mouse/finger drag interactions
				 */
				if (interactive) {
					asset_content_wrapper.addEventListener(MouseEvent.MOUSE_DOWN, start_feature_drag);
				}
				function start_feature_drag(m:MouseEvent):void
				{
					image_wrapper.startDrag();
					asset_content_wrapper.addEventListener(MouseEvent.MOUSE_OUT, stop_feature_drag);
					asset_content_wrapper.addEventListener(MouseEvent.MOUSE_UP, stop_feature_drag);
				}
				function stop_feature_drag(m:MouseEvent):void
				{
					image_wrapper.stopDrag();
					asset_content_wrapper.removeEventListener(MouseEvent.MOUSE_OUT, stop_feature_drag);
					asset_content_wrapper.removeEventListener(MouseEvent.MOUSE_UP, stop_feature_drag);
				}
				
				/**
				 * Handle pinch-zoom interactions
				 */
				if (Capabilities.touchscreenType != "none" && interactive)
				{
					asset_content_wrapper.addEventListener(TransformGestureEvent.GESTURE_ZOOM, gesture_zoom_start);
				}
				function gesture_zoom_start(fingers:TransformGestureEvent):void
				{
					var scale_factor:Number = Math.min(fingers.scaleX, fingers.scaleY);
					if ((fingers.scaleX + fingers.scaleY) / 2 > 0)
					{
						scale_factor = Math.max(fingers.scaleX, fingers.scaleY);
					}
					image_wrapper.scaleX *= scale_factor;
					image_wrapper.scaleY *= scale_factor;
					check_resize();
				}
				
				/**
				 * prepare for garbage collection
				 */
				addEventListener(Event.REMOVED_FROM_STAGE, clear_image_listeners);
				function clear_image_listeners(event:Event):void
				{
					image_wrapper.removeEventListener(MouseEvent.MOUSE_WHEEL, scroll_wheel_on_image);
					image_wrapper.removeEventListener(TransformGestureEvent.GESTURE_ZOOM, gesture_zoom_start);
					image_wrapper.removeEventListener(MouseEvent.MOUSE_DOWN, start_feature_drag);
				}
				
				if (onDownloaded !== null) {
					onDownloaded();
				}
			}
			if (asset_relations.length === 1) 
			{
				var relation:module_asset = asset_relations[0];
				relation.asset_content_wrapper = asset_content_wrapper;
				if (relation is module_asset_audio) 
				{
					sound = new MP3Loader(relation.asset_url, { autoPlay:true, noCache:true } );
					sound.load();
					
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
				}
			}
			
			super.draw_feature_content();
		}
	
		
	}
}