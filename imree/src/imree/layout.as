package imree 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import imree.data_helpers.position_data;
	import imree.shortcuts.box;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class layout extends Object
	{
		
		public function layout() 
		{
			
		}
		
		public function gallery_grid_solver():void {
			
		}
		
		public function asset_grid_solver():void {
			//place for asset _grid solver logic here
			
		}
		public function static_column_solver(items_count:int, width:int, height:int, padding:int = 0):Vector.<position_data> {
			var x:int = padding;
			var y:int = padding;
			var item_width:Number = width - (padding * 2);
			var item_height:Number = (height - (items_count * padding)) / items_count;
			var result:Vector.<position_data> = new Vector.<position_data>;
			for (var i:int = 0; i < items_count; i++) {
				result.push(new position_data(item_width, item_height, x, y));
				y = y + item_height + padding;
			}
			return result;
		}
		public function static_row_solver(items_count:int, width:int, height:int, padding:int = 0):Vector.<position_data> {
			var x:int = padding;
			var y:int = padding;
			var item_width:Number = (width - (items_count * padding)) / items_count;
			var item_height:Number = height - (padding * 2);
			var result:Vector.<position_data> = new Vector.<position_data>;
			for (var i:int = 0; i < items_count; i++) {
				result.push(new position_data(item_width, item_height, x, y));
				x = x + item_width + padding;
			}
			return result;
		}
		
	}

}