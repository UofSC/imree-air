package imree
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class exhibit extends MovieClip
	{
		public var device_type:String;
		public var main:Main;
		public function exhibit() {
			this.addEventListener(Event.ADDED_TO_STAGE, added_to_stage);
		}
		private function added_to_stage(e:Event):void {
			main = Main(this.parent);
			
			//this is an example query that can run against index.php inside imree-php/air/
			main.connection.server_command("group", '', test_complete);
			function test_complete(xml:XML):void {
				trace(xml);
			}
			
		}
		
		
		
	}
	
}