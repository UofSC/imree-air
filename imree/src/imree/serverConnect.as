package imree
{
	import com.adobe.serialization.json.*;
	import com.greensock.events.*;
	import com.greensock.loading.*;
	import com.greensock.loading.data.*;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.*;
	import flash.net.*;
	import flash.utils.ByteArray;
	
	
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class serverConnect extends Object
	{
		public var uri:String;
		public var session_key:String;
		public var username:String;
		public var password:String;
		private var current_loader_number:int;
		private var main:Main;
		public function serverConnect(URI:String="", _main:Main=null) {
			this.uri = URI;
			current_loader_number = 0;
			main = _main;
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
			
			var request:URLRequest = get_url_vars(command, command_parameter, elevatedPrivileges);
			
			var post_data:URLVariables = new URLVariables();
				post_data.command = command;
				post_data.command_parameter = command_parameter;
				post_data.session_key = session_key;
			
			var xmlloadervars:XMLLoaderVars = new XMLLoaderVars();
				xmlloadervars.noCache(true);
				xmlloadervars.onComplete(getxmldata);
				xmlloadervars.onFail(failed);
				xmlloadervars.onError(errored);
				xmlloadervars.autoDispose(true);
				xmlloadervars.onInit(initialized);
				xmlloadervars.onOpen(opened);
				xmlloadervars.onIOError(IOERROR);
				xmlloadervars.prop("properties", {index:current_loader_number++, command:command, paramater:command_parameter, urlvars:post_data});
			var xmlloader:XMLLoader = new XMLLoader(request, xmlloadervars );
			xmlloader.load(true);
			
			
			function getxmldata(e:LoaderEvent):void {
				if (onCompleteFunction !== null) {
					if (XML(XMLLoader(e.target).content).success != "true") {
						main.log(say_loader_event(e) + " Errored because " + XML(XMLLoader(e.target).content).error);
					}
					onCompleteFunction(e);
				}
			}
			function failed(e:LoaderEvent):void {
				main.log(say_loader_event(e) + " FAAILED", e.target.content);
			}
			function IOERROR(e:LoaderEvent):void {
				main.log(say_loader_event(e) + " IOERROR", e.target.content);
			}
			function errored(e:LoaderEvent):void {
				main.log(say_loader_event(e) + " ERRORED", e.target.content);
			}
			function initialized(e:LoaderEvent):void {
				main.log(say_loader_event(e) + " INITIAL", say_loader_event(e) + " INITIAL");
			}
			function opened(e:LoaderEvent):void {
				main.log(say_loader_event(e) + " OPENED", say_loader_event(e) + " OPENED");
			}
		}
		public function set_password(str:String):void {
			password = str;
		}
		public function password_is_set():Boolean {
			return password != null;
		}
		public function say_loader_event(e:LoaderEvent):String {
			var vars:Object = DataLoader(e.currentTarget).vars.properties;
			return "[#" + vars.index + "] \t[" + vars.command + "] \t[" + vars.parameter + "]";
		}
		
		public function server_upload(command_parameter:*, probably_file:*, onComplete:Function = null):void {
			var request:URLRequest = get_url_vars("upload", command_parameter, true);
			
			try {
				new File();
				if (probably_file is File) {
					var file:File = File(probably_file);
					file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, upload_complete);
					file.addEventListener(IOErrorEvent.IO_ERROR, upload_error);
					file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, upload_error);
					function upload_complete(e:DataEvent):void {
						if (onComplete !== null) {
							onComplete();
							main.toast("Upload complete");
						}
					}
					function upload_error(e:*):void {
						main.log_to_server("Upload Failed " + e);
						main.toast("Upload Failed: " + e);
						
					}
					file.upload(request);
				}
			} catch (ve:VerifyError) {
				main.toast("Cannot upload files from flash player");
			}
		}
		
		public function server_upload_bytes(command_parameter:*, bytes:ByteArray, onComplete:Function = null):void {
			var request:URLRequest = get_url_vars("upload_bytes", command_parameter, true);
			request.data.bytesarray = bytes;
			var sendLoader:URLLoader = new URLLoader();
			sendLoader.addEventListener(Event.COMPLETE, loader_complete);
			sendLoader.addEventListener(IOErrorEvent.IO_ERROR, loader_error);
			sendLoader.load(request);
			function loader_complete(e:*):void {
				if (onComplete !== null) {
					onComplete(e);
				}
				main.toast("Data Uploaded");
			}
			function loader_error(e:*):void {
				main.toast("Error: " + String(e));
			}
			
		}
		
		private function get_url_vars(command:String, command_parameter:*, elevatedPrivileges:Boolean = false):URLRequest {
			if (typeof(command_parameter) === "object") {
				var j:JSONEncoder = new JSONEncoder(command_parameter);
				command_parameter = j.getString();
			}
			
			var post_data:URLVariables = new URLVariables();
				post_data.command = command;
				post_data.command_parameter = command_parameter;
				post_data.session_key = session_key;
				
			if (elevatedPrivileges && username.length > 0 && password.length > 0) {
				post_data.username = username;
				post_data.password = password;
			}
			
			var request:URLRequest = new URLRequest(this.uri);
				request.method = URLRequestMethod.POST;
				request.data = post_data;		
			
			return request;
		}
		
		public function toast(str:*):void {
			main.toast(str);
		}
	}
	
}