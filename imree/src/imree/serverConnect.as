package imree
{
	import com.adobe.serialization.json.*;
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
		public var session_key:String;
		public var username:String;
		private var password:String;
		public function serverConnect(URI:String="") {
			this.uri = URI;
		}
		
		public function server_command(command:String, command_parameter:*, onCompleteFunction:Function=null, elevatedPrivileges:Boolean = false):void {
			if (this.uri.length < 1) {
				trace("No connection uri set. Use   ... = new serverConnect('http://site.com/imree/api/'); ... ");
			}
			
			if (typeof(command_parameter) === "object") {
				var j:JSONEncoder = new JSONEncoder(command_parameter);
				command_parameter = j.getString();
			}
			
			var post_data:URLVariables = new URLVariables();
				post_data.command = command;
				post_data.command_parameter = command_parameter;
				
			if (elevatedPrivileges && username.length > 0 && password.length > 0) {
				post_data.username = username;
				post_data.password = password;
			}
				
			var request:URLRequest = new URLRequest(this.uri);
				request.method = URLRequestMethod.POST;
				request.data = post_data;				
			
			var xmlloadervars:XMLLoaderVars = new XMLLoaderVars();
				xmlloadervars.noCache(true);
				xmlloadervars.onComplete(getxmldata);
				xmlloadervars.onFail(failed);
				xmlloadervars.onError(errored);
				xmlloadervars.autoDispose(true);
			var xmlloader:XMLLoader = new XMLLoader(request, xmlloadervars );
			xmlloader.load(true);
			
			function getxmldata(e:LoaderEvent):void {
				if (onCompleteFunction !== null) {
					onCompleteFunction(e.currentTarget.content);
				}
				XMLLoader(e.currentTarget).unload();
				
			}
			function failed(e:LoaderEvent):void {
				trace("XMLLoader faild! " + XMLLoader(e.currentTarget).url + " Command:" + command + " Parameter:" + command_parameter);
				if (String(XMLLoader(e.currentTarget).content).length > 0) {
					trace("XML::\n" + XMLLoader(e.currentTarget).content);
				}
			}
			function errored(e:LoaderEvent):void {
				trace("XMLLoader faild! " + XMLLoader(e.currentTarget).url + " Command:" + command + " Parameter:" + command_parameter);
				if (String(XMLLoader(e.currentTarget).content).length > 0) {
					trace("XML::\n" + XMLLoader(e.currentTarget).content);
				}
			}
		}
		public function set_password(str:String):void {
			password = str;
		}
		
	}
	
}