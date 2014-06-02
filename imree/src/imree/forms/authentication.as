package imree.forms 
{
	import flash.accessibility.Accessibility;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import imree.data_helpers.data_value_pair;
	import imree.Main;
	import imree.serverConnect;
	import imree.shortcuts.box;
	import imree.text;
	import imree.textFont;
	import com.greensock.events.LoaderEvent;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class authentication extends Sprite
	{
		private var t:authentication;
		private var conn:serverConnect;
		public var onSuccess:Function;
		private var status:text;
		private var auth_wrapper:box;
		private var main:Main;
		public function authentication(server:serverConnect, _onSuccess:Function, _main:Main) 
		{
			t = this;
			conn = server;
			onSuccess = _onSuccess;
			main = _main;
			t.addEventListener(Event.ADDED_TO_STAGE, added_to_stage);
		}
		private function added_to_stage(e:Event):void {
			t.removeEventListener(Event.ADDED_TO_STAGE, added_to_stage);
			if(!t.conn.password_is_set()) {
				var background:box = new box(stage.stageWidth, stage.stageHeight, 0x000000, .6);
				t.addChild(background);
				
				auth_wrapper = new box(400, 400, 0xDEDEDE, 1);
				t.addChild(auth_wrapper);
				auth_wrapper.center();
				
				var labelfont:textFont = new textFont( '_sans', 22);
				var inputFormat:TextFormat = new TextFormat("_sans", 20);
				
				var title:text = new text("Please log in", 300, new textFont( '_sans', 16));
				auth_wrapper.addChild(title);
				title.y = 10;
				title.center_x(auth_wrapper);
				
				var elements:Vector.<f_element> = new Vector.<f_element>();
					elements.push(new f_element_text("Username", 'username',''));
					elements.push(new f_element_password("Password", 'password',''));
				var form:f_data = new f_data(elements);
					form.layout(16, 380, 300);
					form.onSubmit = auth;
					form.draw();
					form.y = 50;
				auth_wrapper.addChild(form);
				
				status = new text("Supports QR = " + main.Imree.Device.supports_qr, auth_wrapper.width, new textFont( '_sans', 18));
				status.y = form.height + 50 + 10;
				status.center_x(auth_wrapper);
				auth_wrapper.addChild(status);
				
				
			} else {
				trace("how you say already logged in?");
			}
		}
		private function auth(elements:Object):void {
			var status_y:Number = status.y;
			auth_wrapper.removeChild(status);
			conn.server_command('login', { username:elements.username, password:elements.password}, response );
			function response(evt:LoaderEvent):void {
				var xml:XML = XML(evt.currentTarget.content);
				if (xml.result.logged_in == "true") {
					conn.username = elements.username;
					conn.set_password(elements.password);
					onSuccess(xml);
				} else {
					status = new text("Your username or password were incorrect.");
					auth_wrapper.addChild(status);
					status.y = status_y;
					status.center_x(auth_wrapper);
					trace("Authentication failed");
				}
			}
		}
		
	}

}