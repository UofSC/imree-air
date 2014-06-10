package imree.modules 
{
	import com.greensock.core.TweenCore;
	import com.greensock.layout.ScaleMode;
	import com.greensock.loading.data.ImageLoaderVars;
	import com.greensock.loading.ImageLoader;
	import com.greensock.events.LoaderEvent;
	import com.greensock.easing.*;
	import com.greensock.*;
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
		private var second_child:module_asset;
		public function module_comparison(_main:Main, _Exhibit:exhibit_display, _items:Vector.<module>=null) 
		{
			t = this;
			super(_main, Exhibit, _items);
			
		}
		
		override public function draw_thumb(_w:int = 200, _h:int = 200, Return:Boolean = false):* 
		{
			
			
			first_child = module_asset(items[0]);
			second_child = module_asset(items[1]);
			
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
			trace("loading draw feature for comparison viewer");
						
			first_child.prepare_asset_window(_w, _h);
			first_child.draw_feature_content(false, img_downloaded);			
			phase_feature = true;
			
			
			
			
			function img_downloaded():void {
				var image_bounding_box:Sprite = module_asset_image(first_child).image_bounding_box;
				
				var second_child_image_wrapper:box = new box(image_bounding_box.width, image_bounding_box.height);
				second_child_image_wrapper.x = image_bounding_box.x;
				second_child_image_wrapper.y = image_bounding_box.y;
				first_child.asset_content_wrapper.addChild(second_child_image_wrapper);
				
				
				
				var target_url1:String = second_child.asset_url;
				if (first_child.can_resize)
				{
					target_url1 = main.image_url_resized(target_url1, second_child_image_wrapper.height);
				}
				new ImageLoader(target_url1, main.img_loader_vars(second_child_image_wrapper)).load();
				
				//@todo make mask
				
				var content_mask:box = new box(second_child_image_wrapper.width, second_child_image_wrapper.height);
				second_child_image_wrapper.addChild(content_mask);
				second_child_image_wrapper.mask = content_mask;
				
				var icon_box:box = new box(30, 60, 0xFFFFFF, .5, 1, 0x000000);
				second_child_image_wrapper.addChild(icon_box);
				icon_box.x = 0;
				icon_box.y = second_child_image_wrapper.height / 2;
				
				first_child.asset_content_wrapper.addEventListener(MouseEvent.MOUSE_MOVE, move_mask);
				first_child.asset_content_wrapper.mouseEnabled = true;
				
				function move_mask(m_evt:MouseEvent = null):void {
					
					var new_max_x:int = main.stage.mouseX;
					var new_min_x:int = main.stage.mouseX;
					new_max_x -= image_bounding_box.getBounds(main.stage).width;
					new_min_x -= second_child_image_wrapper.getBounds(main.stage).width
					
					TweenLite.to(content_mask, .4, { x:Math.max(new_max_x, 0) } );
					TweenLite.to(icon_box, .4, { x:Math.max(Math.min(new_min_x,0),new_max_x, 0) } );
					
					///grr...the icon is still going over too far.
				}
				
				first_child.asset_content_wrapper.addEventListener(Event.REMOVED_FROM_STAGE, removeListener);
				
				function removeListener(e:Event):void {
					first_child.asset_content_wrapper.removeEventListener(MouseEvent.MOUSE_MOVE, move_mask);
					}
			
			}
		}
		override public function draw_edit_button():void
		{
			
			super.draw_edit_button();
		}
		
		
	}
}