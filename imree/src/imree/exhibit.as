package imree
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.XMLLoader;
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
		public var api_url:String;
		public function exhibit() {
			this.addEventListener(Event.ADDED_TO_STAGE, added_to_stage);
		}
		private function added_to_stage(e:Event):void {
			server_command("group", '', test_complete);
			function test_complete(xml:XML):void {
				trace(xml);
			}
		}
		
		
		/**
		 * This sends command:command_parameter to the PHP server and returns XML data to onCompleteFunction
		 * @param	command				The command to be executed
		 * @param	command_parameters	The paramater to pass with command [optional]
		 * @param	onCompleteFunction	The function to be executed when xml data is received. This function should accept one parameter of type :XML
		 */
		public function server_command(command:String, command_parameter:String, onCompleteFunction:Function=null):void {
			var post_data:URLVariables = new URLVariables();
				post_data.command = command;
				post_data.command_parameter = command_parameter;
				
			var request:URLRequest = new URLRequest(this.api_url);
				request.method = URLRequestMethod.POST;
				request.data = post_data;				
				
			var xmlloader:XMLLoader = new XMLLoader(request, { onComplete:getxmldata } );
			xmlloader.load();
			
			function getxmldata(e:LoaderEvent):void {
				if (onCompleteFunction !== null) {
					onCompleteFunction(e.target.content);
				}
			}
		}
	}
	
}