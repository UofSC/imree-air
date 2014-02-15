package imree.display_helpers 
{
	import flash.display.Sprite;
	import imree.data_helpers.data_value_pair;
	import imree.shortcuts.box;
	import imree.text;
	import imree.textFont;
	/**
	 * ...
	 * @author Jason Steelman - uscart@gmail.com
	 */
	public class ui_selectList_item extends Sprite
	{
		public var label:String;
		public var value:*;
		public function ui_selectList_item(data:data_value_pair, width:int, height:int) {
			this.label = data.label;
			this.value = data.value;
			this.mouseChildren = false;
			this.mouseEnabled = true;
			this.addChild(new box(width, height)); // for selection testing
			
			var txtfont:textFont = new textFont();
			var txt:text = new text(label, width, txtfont, height);
			this.addChild(txt);
		}
		
	}

}