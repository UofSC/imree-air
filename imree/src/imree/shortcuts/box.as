package imree.shortcuts
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class box extends Sprite
	{
		/**
		 * This function creates a sprite like any other except it draws a graphics box to give the sprite
		 * a real size. The width and height of box may not be immediately available and you should use a 
		 * calculated width and height when working with box's contents
		 * @param	width 
		 * @param	height
		 * @param	color
		 * @param	alpha
		 */
		public function box(width:Number, height:Number, color:uint = 0x000000, alpha:Number = 0, border:Boolean = false) {
			this.graphics.beginFill(color, alpha);
			if (border) {
				this.graphics.lineStyle(1, 0x000000);
			}
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();
		}
	}
	
}