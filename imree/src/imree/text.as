package imree 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.engine.FontPosture;
	import flash.text.engine.Kerning;
	import flash.text.engine.TextBaseline;
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.conversion.IHTMLImporter;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.Configuration;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.formats.TextDecoration;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.TextLayoutVersion;
	import flashx.textLayout.events.*;
	
	
	/**
	 * ...
	 * @author Jason Steelman - uscart@gmail.com
	 */
	public class text extends Sprite
	{
		/**
		 * We're using http://www.adobe.com/devnet-apps/tlf/demo/ to help us write 
		 */
		public var format:textFont;
		private var value:String;
		public function text(str:String, _width:int = 300, Format:textFont = null, _height:Number = 10000) {
			is_cached = false;
			value = str;
			if (Format === null) {
				Format = new textFont();
			}
			var config:Configuration = new Configuration();
			config.textFlowInitialFormat = Format.describe();
            
			if (flashx.textLayout.conversion.TextConverter.importToFlow(str, TextConverter.TEXT_LAYOUT_FORMAT, config) == null) {
				str = '<?xml version="1.0" encoding="utf-8"?><flow:TextFlow whiteSpaceCollapse="preserve" xmlns:flow="http://ns.adobe.com/textLayout/2008"><flow:p><flow:span>' + str + '</flow:span></flow:p></flow:TextFlow>';
			}
			var textFlow:TextFlow = TextConverter.importToFlow(str, TextConverter.TEXT_LAYOUT_FORMAT, config);
			textFlow.paddingBottom = Format.padding;
			textFlow.paddingTop = Format.padding;
			textFlow.paddingLeft = Format.padding;
			textFlow.paddingRight = Format.padding;
			var controller:ContainerController = new ContainerController(this, _width, _height);
			controller.setCompositionSize(_width, _height);
			textFlow.flowComposer.addController(controller);
			textFlow.flowComposer.updateAllControllers();
			textFlow.addEventListener(UpdateCompleteEvent.UPDATE_COMPLETE, on_next_frame);
			function on_next_frame(e:Event):void {
				textFlow.removeEventListener(UpdateCompleteEvent.UPDATE_COMPLETE, on_next_frame);
				cache();
			}
			
		}
		public function center_x(target:DisplayObject=null):void {
			if (target === null) {
				x = (stage.stageWidth - this.width) / 2;
				} else {
				x = target.width / 2 - this.width / 2 ;
			}
		}
		public function center_y(target:DisplayObject=null):void {
			if (target === null) {
				y = stage.stageHeight / 2 - this.height / 2;
			} else {
				y = target.height / 2 - this.height / 2 ;
			}
		}
		private var is_cached:Boolean;
		public function cache():void {
			if(!is_cached) {
				var bitdata:BitmapData = new BitmapData(getBounds(parent).width + 100, getBounds(parent).height + 20, true, 0);
				bitdata.draw(this);
				while (this.numChildren > 0) {
					this.removeChildAt(0);
				}
				addChild(new Bitmap(bitdata));
				is_cached = true;
			}
		}
		public function get_val():String {
			return value;
		}
	}

}