package imree 
{
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
		public function text(str:String, width:int = 300, Format:textFont = null) {
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
			controller.setCompositionSize(width, 9999);
			textFlow.flowComposer.addController(controller);
            textFlow.flowComposer.updateAllControllers();

		}
		
	}

}