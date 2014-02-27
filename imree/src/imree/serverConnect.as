package imree
{
	import com.adobe.serialization.json.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.DataLoader;
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
		public function clone():serverConnect {
			var n:serverConnect = new serverConnect();
			n.uri = uri;
			n.session_key = session_key;
			n.username = username;
			n.password = password;
			return n;
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
				xmlloadervars.onComplete(onCompleteFunction);
				xmlloadervars.onFail(failed);
				xmlloadervars.onError(errored);
				xmlloadervars.autoDispose(true);
			var xmlloader:XMLLoader = new XMLLoader(request, xmlloadervars );
			xmlloader.load(true);
			trace("Requested on " + xmlloader.name + " = " + request.data.command);
			
			function getxmldata(e:LoaderEvent):void {
				trace("Received on " + DataLoader(e.currentTarget).name + " = " + DataLoader(e.currentTarget).request.data.command);
				if (onCompleteFunction !== null) {
					onCompleteFunction(e.currentTarget.content);
				}
				DataLoader(e.currentTarget).unload();
			}
			function failed(e:LoaderEvent):void {
				trace("DataLoader faild! " + e.text + ". " + DataLoader(e.target).url + " Command:" + command + " Parameter:" + command_parameter);
				if (String(DataLoader(e.target.content)).length > 0) {
					trace("XML::\n" + DataLoader(e.target).content);
				}
			}
			function errored(e:LoaderEvent):void {
				trace("DataLoader faild! " + e.text + ". " +  DataLoader(e.currentTarget).url + " Command:" + command + " Parameter:" + command_parameter);
				if (String(DataLoader(e.currentTarget).content).length > 0) {
					trace("XML::\n" + DataLoader(e.currentTarget).content);
				}
			}
		}
		public function set_password(str:String):void {
			password = str;
		}
		public function password_is_set():Boolean {
			return password != null;
		}
		
	}
	
}