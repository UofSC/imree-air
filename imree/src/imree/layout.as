package imree 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import imree.data_helpers.matrix;
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
		
		// classic euclidean recursive greatest common divisor 
		public function gcd(a:int, b:int):int {
			if (b === 0) {
				return a;
			} else {
				return gcd(b, a % b);
			}
		}
		public function gcd_list(list:Vector.<int>):int {
			if (list.length < 2) {
				return list[0];
			} else if (list.length === 2) {
				return gcd(list[0], list[1]);
			} else {
				var r:int = list[0];
				for (var i:int = 1; i < list.length; i++) {
					r = gcd(r, list[i]);
				}
				return r;
			}
		}
		public function abstract_box_solver(items:Vector.<position_data>, width:int, height:int, padding:int = 10, from:String = "top", allow_overflow:Boolean = true):Vector.<position_data> {
			var widths:Vector.<int> = new Vector.<int>();
			var heights:Vector.<int> = new Vector.<int>();
			for each(var p:position_data in items) {
				widths.push(p.width);
				heights.push(p.height);
			}
			var gcd_width:int = gcd_list(widths);
			var gcd_height:int = gcd_list(heights);
			var columns:int = Math.floor(width / gcd_width);
			var rows:int = Math.floor(height / gcd_height);
			if (from === "top" && allow_overflow) {
				rows = rows * 100;
			} else if (from === "left" && allow_overflow) {
				columns = columns * 100;
			}
			
			var result:Vector.<position_data> = new Vector.<position_data>();
			var m:matrix = new matrix(rows, columns);
			for (var i:int = 0; i < items.length; i++) {
				var units_wide:int = items[i].width / gcd_width; //should always be a whole number (int)
				var units_tall:int = items[i].height / gcd_height; //likewise
				var location:Point = m.fit_region(units_wide, units_tall, from, 1);
				if (location !== null) {
					result.push(new position_data(items[i].width, items[i].height, gcd_width * location.x, gcd_height * location.y));
				} else {
					result.push(new position_data(0, 0, -100, -100));
				}
			}
			return result;
		}
		
		
	}

}