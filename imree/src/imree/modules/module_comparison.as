package imree.modules 
{
	import com.greensock.layout.ScaleMode;
	import com.greensock.loading.data.ImageLoaderVars;
	import com.greensock.loading.ImageLoader;
	import com.greensock.events.LoaderEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import com.greensock.TweenLite;
	
	import imree.modules.module;
	import imree.shortcuts.box;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.system.Capabilities;
	import com.greensock.BlitMask;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Elastic;
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.DisplayObjectContainer;	
	import com.greensock.layout.ScaleMode;
	import com.greensock.loading.data.ImageLoaderVars;
	import com.greensock.loading.display.ContentDisplay;
	import imree.data_helpers.Theme;
	import imree.IMREE;
	import imree.pages.exhibit_display;
	import imree.text;
	
	import imree.display_helpers.modal;
	import imree.display_helpers.window;
	import imree.forms.f_data;
	import imree.forms.f_element;
	import imree.images.loading_spinner_sprite;
	import imree.Main;
	import imree.pages.exhibit_display;
	import fl.controls.Button;
	
	/**
	 * The comparison module is almost identical in function to module_asset_image, except it gets most of its data from items[0]
	 * @author Jason Steelman
	 */
	public class module_comparison extends module
	{
		public var thumbnail_url:String;
		private var feature_wrapper:box;
		private var first_child:module_asset;
		private var seconds_child:module_asset;
		public function module_comparison(_main:Main, _Exhibit:exhibit_display, _items:Vector.<module>=null) 
		{
			t = this;
			super(_main, Exhibit, _items);
			
		}
		
		override public function draw_thumb(_w:int = 200, _h:int = 200, Return:Boolean = false):* 
		{
			
			
			first_child = module_asset(items[0]);
			seconds_child = module_asset(items[1]);
			
			var thumb_wrapper:Sprite = first_child.draw_thumb(_w, _h, true);
			
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
				onSelect(t);  //never defined in any function, this probably should be removed from the whole system b/c its confusing as f$#k
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
			trace("drawing feature content for comparison viewer");
			first_child.prepare_asset_window(_w, _h);			
			first_child.draw_feature_content();
			phase_feature = true;
	
			///You're working here.
				
				
		
		}
		override public function draw_edit_button():void
		{
			
			super.draw_edit_button();
		}
		
		
		}
			
		
		}

