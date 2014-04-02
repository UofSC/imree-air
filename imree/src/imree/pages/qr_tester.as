package imree.pages 
{
	import com.sbhave.nativeExtensions.zbar.Config;
	import com.sbhave.nativeExtensions.zbar.Scanner;
	import com.sbhave.nativeExtensions.zbar.ScannerEvent;
	import com.sbhave.nativeExtensions.zbar.Symbology;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Camera;
	import flash.display.Bitmap;
	import flash.media.Video;
	import imree.text;
	import imree.textFont;
	
	
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class qr_tester extends Sprite
	{
		private var cameraView:Sprite;    
		private var camera:Camera;
		private var video:Video = new Video(320, 320);
		private var freezeImage:Bitmap;
		private var blue:Sprite = new Sprite();
		private var red:Sprite = new Sprite();
		private const STAGE_SIZE:int = 350;
		private var s:Scanner;
		private var c:int = 0;
		public function qr_tester() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, start);
		}
		private function start(e:Event):void {
			this.stage.removeEventListener(Event.ADDED_TO_STAGE,start);
			s = new Scanner();
			s.setTargetArea(500, "0xFF0000FF", "0xFFABCDEF");
			s.setConfig(Symbology.EAN13, Config.ENABLE, 100);
			s.addEventListener(ScannerEvent.SCAN, onScan);
			s.launch(true, "rear");
		}
		private function onScan(e:ScannerEvent):void {
			trace(e.data);
			var txt:text = new text("Scanned " + e.data, 600, new textFont('_sans', 50));
			addChild(txt);
		}
		
	}

}