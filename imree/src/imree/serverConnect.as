package imree
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.XMLLoader;
	import com.greensock.loading.data.XMLLoaderVars;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class serverConnect extends Object
	{
		public var uri:String;
		public function serverConnect(URI:String="") {
			this.uri = URI;
		}
		
		/**
		 * This sends command:command_parameter to the PHP server and returns XML data to onCompleteFunction
		 * @param	command				The command to be executed
		 * @param	command_parameters	The paramater to pass with command [optional]
		 * @param	onCompleteFunction	The function to be executed when xml data is received. This function should accept one parameter of type :XML
		 */
		public function server_command(command:String, command_parameter:String, onCompleteFunction:Function=null):void {
			if (this.uri.length < 1) {
				trace("No connection uri set. Use   ... = new serverConnect('http://site.com/imree/api/'); ... ");
			}
			
			var post_data:URLVariables = new URLVariables();
				post_data.command = command;
				post_data.command_parameter = command_parameter;
				
			var request:URLRequest = new URLRequest(this.uri);
				request.method = URLRequestMethod.POST;
				request.data = post_data;				
				
			var xmlloader:XMLLoader = new XMLLoader(request, { onComplete:getxmldata, onFail:failed } );
			xmlloader.load(true);
			
			function getxmldata(e:LoaderEvent):void {
				if (onCompleteFunction !== null) {
					onCompleteFunction(e.target.content);
				}
			}
			function failed(e:LoaderEvent):void {
				trace("Failed to load something");
				trace(XMLLoader(e.currentTarget).url + " Command:"+command + " Parameter:"+command_parameter);
			}
		}
	}
	
}