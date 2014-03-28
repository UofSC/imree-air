package imree 
{
	import fl.controls.ScrollBar;
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.text.TextField;
	import fl.containers.ScrollPane;
	import imree.shortcuts.box;
	//import fl.controls.UIScrollBar;
	import flash.text.TextFieldAutoSize;
	import imree.display_helpers.scrollPaneFancy;
	
	
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class logger extends Sprite
	{
		public var txt:TextField;
		private var scroller:scrollPaneFancy;
		public function logger(Label:String="") 
		{
			/**
			 * We need to make a displayObject (sprite, movieclip, etc...) that includes txt
			 * the displayObject needs to have a vertical scrolling feature so we can "scroll up" to log entries that may be too far back in time to be visible
			 */
			
			 addChild(new box(600, 500, 0xEDEDED, 1));
			 
			//TextField
			txt = new TextField();
			txt.border = true;
			txt.width = 580;
			txt.multiline = true;
			txt.wordWrap = true;
			txt.height = 500;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.background = true;
			//txt.mouseWheelEnabled = true;
			txt.backgroundColor = 0xFFFFFF;
			txt.text = Label;
			this.visible = false;
				
			//ScrollBar is working with overflow of text
			
			/**
			 
			var SB:UIScrollBar = new UIScrollBar();
			SB.direction = "vertical";
			SB.visible = true;
			SB.setSize(txt.width, txt.height);
			SB.move(txt.x - 15, txt.y);
			SB.scrollTarget = txt;
			*/
			//addChild(txt);
			//addChild(SB);
			
			scroller = new scrollPaneFancy();
			scroller.setSize(600, 500);
			scroller.source = txt;
			scroller.update();
			addChild(scroller);
		}
		
		
		public function toggle():void {
			if (this.visible) {
				hide();
			} else {
				show();
			}
		}
		public function show():void {
			
			this.visible = true;
			

		}
		public function hide():void {
			
			this.visible = false;
		}
		public function add(str:*):void {
			txt.appendText("\n" + String(str));
			scroller.update();
		}
		
	}

}