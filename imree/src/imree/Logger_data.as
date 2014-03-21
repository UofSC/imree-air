package imree 
{
	import fl.controls.ScrollBar;
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.text.TextField;
	import fl.containers.ScrollPane;
	import fl.controls.UIScrollBar;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.core.LoaderCore;
	
	
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class Logger_data extends Sprite
	{
		public var txt:TextField;
		public function Logger_data() 
		{
			/**
			 * We need to make a displayObject (sprite, movieclip, etc...) that includes txt
			 * the displayObject needs to have a vertical scrolling feature so we can "scroll up" to log entries that may be too far back in time to be visible
			 */
			
						
			//TextField
				txt = new TextField();
				txt.border = true;
				txt.width = 200;
				txt.x = 115;
				txt.y = 100;
				txt.multiline = true;
				txt.wordWrap = true;
				txt.height = 500;
				txt.background = true;
				txt.mouseWheelEnabled = true;
				txt.backgroundColor = 0xFFFFFF;
				txt.text = "IO ERROR / IO GENERAL LOADER FAIL";
				this.visible = false;
				
				
			//ScrollBar is working with overflow of text
				var SB:UIScrollBar = new UIScrollBar();
				SB.direction = "vertical";
				SB.visible = true;
				SB.setSize(txt.width, txt.height);
				SB.move(txt.x - 15, txt.y);
				SB.scrollTarget = txt;
				
				addChild(txt);
				addChild(SB);
				
	
				
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
		public function general_io_error(e:LoaderEvent):void {
			LoaderCore(e.target).load(true);
		trace("IO ERROR: " + e.text);}
			
		public function general_loader_fail(str:*):void {
		trace("IO general_loader_fail: " + str);
				
		}
		
		}
	}
