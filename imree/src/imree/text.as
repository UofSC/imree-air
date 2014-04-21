package imree 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
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
		public function text(str:String, width:int = 300, Format:textFont = null, height:Number = 10000) {
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
			var controller:ContainerController = new ContainerController(this, 500, 200);
			controller.setCompositionSize(width,height);
			textFlow.flowComposer.addController(controller);
			textFlow.flowComposer.updateAllControllers();
			
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
		
	}

}