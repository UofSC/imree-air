package  {
	
	import flash.display.MovieClip;
	
	
	public class longpress_indicator extends MovieClip {
		
		public var onComplete:Function;
		public function longpress_indicator(_onComplete:Function = null) {
			if(_onComplete !== null) {
				onComplete = _onComplete;
			}
		}
	}
	
}
