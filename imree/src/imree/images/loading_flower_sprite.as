package imree.images 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import imree.display_helpers.SpriteSheetAnimation;
	/**
	 * ...
	 * @author Jason Steelman - uscart@gmail.com
	 */
	public class loading_flower_sprite extends Sprite
	{
		[Embed(source = "loading_flower.png")]
		private var loadingFlower:Class;
		
		public function loading_flower_sprite(size:int = 128) 
		{
			var loader_image:SpriteSheetAnimation = new SpriteSheetAnimation(Bitmap(new loadingFlower()), 128, 128, 60);
			loader_image.scaleX = size / 128;
			loader_image.scaleY = size / 128;
			this.addChild(loader_image);
			
		}
		
	}

}