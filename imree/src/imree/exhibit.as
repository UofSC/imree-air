package imree
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import imree.data_helpers.data_asset;
	import imree.data_helpers.data_group;
	import com.greensock.events.LoaderEvent;
	
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
			main.connection.server_command("group", '1', test_complete);
			
			function test_complete(evt:LoaderEvent):void {
				var xml:XML = XML(evt.currentTarget.content);
				var dat:data_group = new data_group(xml);
				var asset:data_asset = new data_asset(xml);
			}
			
		}
		
		
		
	}
	
}