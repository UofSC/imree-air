package imree.pages 
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	[Embed(source = "../../userinterface_components.swc", symbol = "Garnet")] public var garnet:Class;
	[Embed(source = "../../userinterface_components.swc", symbol = "UniversityLibrariesLogo")] public var UniLogo:Class;
	
	
	
	/**
	 * ...
	 * @author Tonya Holladay
	 */
	public class Preloader extends Sprite
	{
		
		public function Preloader() 
		{
			var garnet: Sprite = new garnet;
			garnet.width = stage.stageWidth;
			garnet.height = stage.stageHeight;
			addChild(garnet);
			
			var UniLogo:Sprite = new UniversityLibrariesLogo;
			addChild(UniLogo);
		}
		
		//Timer
	}

}