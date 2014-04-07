package imree.modules 
{
			
	
	import com.greensock.loading.*;
	import com.greensock.loading.data.VideoLoaderVars;
	import com.greensock.loading.display.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.core.LoaderItem;
	import com.greensock.*;
	import com.greensock.TweenLite;	
	import flash.media.Video;
	import flash.net.URLLoader;
	import imree.images.loading_spinner_sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;	
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
			
			var vidvars:VideoLoaderVars = new VideoLoaderVars();
			vidvars.crop(true);
			vidvars.width(_w);
			vidvars.height(_h);
			vidvars.noCache(true);
			vidvars.scaleMode(ScaleMode.PROPORTIONAL_OUTSIDE);
			vidvars.container(result);
			new VideoLoader(asset_url + "?size=" + String(_h), vidvars).load();
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
					
		
			override public function draw_feature(_w:int, _h:int):void {
			if (draw_feature_on_object !== null) {
				main.log('Loading module.module_asset_image [id:' + module_id + '] [name: ' + module_name + '] ' + asset_url);
				var vars:VideoLoaderVars = main.vid_loader_vars(draw_feature_on_object);
				vars.noCache(true);
					vars.scaleMode(ScaleMode.PROPORTIONAL_INSIDE);
					vars.onComplete(vid_downloaded);
					vars.crop(false);
					vars.container(null);
				new VideoLoader(asset_url, vars).load();
				loading_indicator = new loading_spinner_sprite();
				loading_indicator.blendMode = BlendMode.SCREEN;
				draw_feature_on_object.addChild(loading_indicator);
				loading_indicator.x = _w/ 2 - 128/2;
				loading_indicator.y = _h/ 2 - 128/2;
			} else {
				main.log('you need to have set the draw_feature_on_object from outside the module before calling draw_feature()');
			}
			
			function video_downloaded(e:LoaderEvent):void {
				draw_feature_on_object.removeChild(loading_indicator);
				loading_indicator = null;
				var actual_video:ContentDisplay = VideoLoader(e.target).content;
				var video:Video = actual_video.rawContent;
				
				var original_width:int = draw_feature_on_object.width;
				var original_height:int = draw_feature_on_object.height;
				
				var wrapper:box = new box(draw_feature_on_object.width, draw_feature_on_object.height);
				draw_feature_on_object.addChild(wrapper);
				wrapper.addEventListener(MouseEvent.MOUSE_WHEEL, scroll_wheel_on_image);
				wrapper.addChild(video);
				//video.scaleX = Math.min(1, video.scaleX);
				//video.scaleY = Math.min(1, video.scaleY);
				video.x = 0 - video.width /2;
				video.y = 0 - video.height / 2;
				wrapper.x = (original_width/2) ;
				wrapper.y = (original_height/ 2);
				
				//var blitmask:BlitMask = new BlitMask(wrapper, 0, 0,original_width, original_height);
				//blitmask.bitmapMode //Mode = false;
				var max_scale:Number = Math.min(1 / bitmap.scaleX, 1 / bitmap.scaleY);
				
				function scroll_wheel_on_image(m:MouseEvent):void {
					var factor:Number = m.delta *.1;
					if (main.Imree.Device.orientation === 'portrait') {
						factor *= 5;
					}
					TweenLite.to(wrapper, .2, { 
						scaleX:Math.max(wrapper.scaleX + factor, .5),
						scaleY:Math.max(wrapper.scaleY + factor, .5),
						ease:Cubic.easeInOut,
						onComplete:check_resize
					} ); 
				}
				function check_resize(m:*= null):void {
					if(wrapper.scaleX > max_scale || wrapper.scaleY > max_scale) {
						TweenLite.to(wrapper, .6, { 
							scaleX:Math.max(Math.min(max_scale, wrapper.scaleX), .5),
							scaleY:Math.max(Math.min(max_scale, wrapper.scaleY), .5),
							ease:Elastic.easeOut
						} ); 
					}
				}
				
				wrapper.addEventListener(MouseEvent.MOUSE_DOWN, start_feature_drag);
				function start_feature_drag(m:MouseEvent):void {
					wrapper.startDrag();
					wrapper.addEventListener(MouseEvent.MOUSE_OUT, stop_feature_drag);
					wrapper.addEventListener(MouseEvent.MOUSE_UP, stop_feature_drag);
				}
				function stop_feature_drag(m:MouseEvent):void {
					wrapper.stopDrag();
					wrapper.removeEventListener(MouseEvent.MOUSE_OUT, stop_feature_drag);
					wrapper.removeEventListener(MouseEvent.MOUSE_UP, stop_feature_drag);
				}
			}
			phase_feature = true;
			
			/*var video:VideoLoader;
			video.load();
			
			
			var pauseButton:Button = new Button
			pauseButton.label = "Pause"
			pauseButton.setSize(100, 20);
			pauseButton.x = 5;
			pauseButton.y = 10;
			var vidPaused:smart_button = new smart_button(pauseButton, togglePause );
			
		function togglePause(event:MouseEvent):void {
				video.videoPaused = !video.vidPaused;
			}	
			
		var queue:LoaderMax = new LoaderMax( {name:"mainQueue", onProgress:progressHandler, onComplete:completeHandler, onError:errorHandler } );
		
						//moved to Main.as
							queue.append(video);
							queue.append(new DataLoader("asset_url"));
							queue.append(new ImageLoader("asset_url"))
							
							queue.load();
							
							queue.pause();
							
							queue.resume();
		
		function progressHandler(event:LoaderEvent):void {
			trace("progress: " + event.target.progress);
			}
			
			function completeHandler(event:LoaderEvent):void {
				video.playVideo();
				
				TweenLite.to(video, 2, { volume:1 } );
				}
			
				function errorHandler(event:LoaderEvent):void {
					trace("error occured with " + event.target + ": " + event.text);
					}*/
					
		}
		
		
	}

}
			
		


