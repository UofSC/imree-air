package imree.modules 
{
	import com.greensock.layout.ScaleMode;
	import com.greensock.loading.data.ImageLoaderVars;
	import com.greensock.loading.ImageLoader;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import imree.Main;
	import imree.pages.exhibit_display;
	import imree.modules.module;
	import imree.shortcuts.box;
	
	/**
	 * The comparison module is almost identical in function to module_asset_image, except it gets most of its data from items[0]
	 * @author Jason Steelman
	 */
	public class module_comparison extends module
	{
		
		
		private var first_child:module_asset;
		private var seconds_child:module_asset;
		public function module_comparison(_main:Main, _Exhibit:exhibit_display, _items:Vector.<module>=null) 
		{
			super(_main, Exhibit, _items);
			
		}
		
		override public function draw_thumb(_w:int = 200, _h:int = 200, Return:Boolean = false):* 
		{
			var thumb_wrapper:Sprite = new Sprite();
			
			var result:box = new box(_w, _h, 0xFFFFFF, .2);
			thumb_wrapper.addChild(result);
			
			var imgvars:ImageLoaderVars = new ImageLoaderVars();
			imgvars.crop(true);
			imgvars.width(_w);
			imgvars.height(_h);
			imgvars.scaleMode(ScaleMode.PROPORTIONAL_OUTSIDE);
			imgvars.container(result);
			imgvars.estimatedBytes(20000);
			
			first_child = module_asset(items[0]);
			var target_url:String = first_child.asset_url;
			if (first_child.can_resize) {
				target_url = main.image_url_resized(target_url, _h);
				imgvars.alternateURL(target_url);
			}
			
			new ImageLoader(target_url, imgvars).load();
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
		
		
		override public function draw_feature(_w:int, _h:int):void 
		{
			first_child.prepare_asset_window(_w, _h);
			phase_feature = true;
			
			//image one is first_child, which is a module_asset_image
			//image two is second_child, which is also module_asset_image
			//i.e. image_url = first_child.asset_url;
		}
		
		
	}

}