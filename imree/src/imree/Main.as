package imree
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import imree.shortcuts.box;
	import imree.exhibit;
	
	/**
	 * ...
	 * @author Jason Steelman <uscart@gmail.com>, add yur name here as you work on this project/file
	 */
	public class Main extends Sprite 
	{
		public var connection:serverConnect;
		public var stack:exhibit;
		public function Main():void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			stage.addChild(this);
			
			connection = new serverConnect("http://imree.tcl.sc.edu/imree-php/api/");
			
			var sample_string:String = "<?xml version='1.0' encoding='utf-8' ?><flow:TextFlow whiteSpaceCollapse='preserve' xmlns:flow='http://ns.adobe.com/textLayout/2008'><flow:p><flow:span>Hoodie vero enim, XOXO Bushwick non </flow:span><flow:span textDecoration=\"underline\">8-bit</flow:span><flow:span> meh kitsch direct trade. Brooklyn authentic aesthetic, cillum paleo 8-bit PBR&B biodiesel nisi skateboard cornhole pork belly freegan ad. Pork belly distillery authentic irony aliquip cornhole. Odd Future art party ethnic, sustainable flannel fixie pork belly placeat gentrify yr flexitarian letterpress. Pop-up laboris synth stumptown Marfa messenger bag. Sunt dolore selfies eiusmod tofu assumenda. Chillwave small batch cornhole veniam duis.</flow:span></flow:p></flow:TextFlow>";
			var Format:textFont = new textFont('OpenSansLight',18);
			var txt:text = new text(sample_string, 400, Format);
			stage.addChild(txt);
			
		}
		
		private function deactivate(e:Event):void 
		{
			// make sure the app behaves well (or exits) when in background
			//NativeApplication.nativeApplication.exit();
		}
		
	}
	
}