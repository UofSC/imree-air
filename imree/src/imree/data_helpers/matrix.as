package imree.data_helpers 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class matrix extends Object
	{
		public var data:Array;
		public function matrix(columns:int, rows:int) {
			data = [];
			for (var y:int = 0; y < columns; y++) {
				var row:Array = [];
				for (var x:int = 0; x < rows; x++) {
					row.push(0);
				}
				data.push(row);
			}
		}
		public function toString():String {
			var str:String = "MATRIX[";
			for each(var row:Array in this.data) {
				var row_str:String = "\n\t[ ";
				for each (var cell:* in row) {
					row_str += String(cell) + ", ";
				}
				str += row_str.substr(0, row_str.length -2) + " ]";
			}
			return str + "]";
		}
		public function sum_region(rows:int, columns:int, at_x:int, at_y:int):Number {
			var sum:Number = 0;
			for (var i:int = 0; i < rows; i++) {
				for (var j:int = 0; j < columns; j++) {
					sum += Number(this.data[i + at_y][j + at_x]);
				}
			}
			return sum;
		}
		public function set_region(rows:int, columns:int, at_x:int, at_y:int, v:*):void {
			for (var i:int = 0; i < rows; i++) {
				for (var j:int = 0; j < columns; j++) {
					this.data[i + at_y][j + at_x] = v;
				}
			}
		}
		public function fit_region(rows:int, columns:int, from:String = "top", v:* = 1):Point {
			if(from === "left") {
				for (var x:int = 0; x < this.data[0].length - columns + 1; x++) {
					for (var y:int = 0; y < this.data.length - rows + 1; y++) {
						if (this.sum_region(rows, columns, x, y) === 0) {
							this.set_region(rows, columns, x, y, v);
							return new Point(x, y);
						}
					}
				}
			} else if(from === "top") {
				for (var y1:int = 0; y1 < this.data.length - columns + 1; y1++) {
					for (var x1:int = 0; x1 < this.data[0].length  - rows + 1; x1++) {
						if (this.sum_region(rows, columns, x1, y1) === 0) {
							this.set_region(rows, columns, x1, y1, v);
							return new Point(x1, y1);
						}
					}
				}
			}
			return null;
		}
		public function set(x:int, y:int, v:*):void {
			this.data[y][x] = v;
		}
		public function get(x:int, y:int):* {
			return this.data[y][x];
		}
	}

}