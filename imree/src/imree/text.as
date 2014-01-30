package imree 
{
	import flash.display.Sprite;
	import flash.text.engine.FontPosture;
	import flash.text.engine.Kerning;
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
		public var format:textFont;
		public function text(str:String, width:int = 300, Format:textFont = null) {
			if (Format === null) {
				Format = new textFont();
			}
			var config:Configuration = new Configuration();
			config.textFlowInitialFormat = Format.describe();
            var textFlow:TextFlow = TextConverter.importToFlow(str, TextConverter.TEXT_LAYOUT_FORMAT, config);
            
			textFlow.flowComposer.addController(new ContainerController(this,500,200));
            textFlow.flowComposer.updateAllControllers(); 

		}
		
	}

}