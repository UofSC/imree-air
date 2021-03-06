package imree.forms 
{
	import flash.accessibility.Accessibility;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
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
	import fl.controls.Button;
	import imree.pages.exhibit_display;
	import imree.pages.home;
	
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
		public var Exhibit:exhibit_display;
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
				
				form.addEventListener(KeyboardEvent.KEY_DOWN, enter_pressed);
				
				function enter_pressed(e:KeyboardEvent):void
				{
					if (e.charCode == 13) 
					{
						form.removeEventListener(KeyboardEvent.KEY_DOWN, enter_pressed);
						form.submit();
					}
				}
				
				var close_bt:Button = new Button();
				close_bt.setSize(85, 35);
				close_bt.label = "close";
				auth_wrapper.addChild(close_bt);
				close_bt.x = auth_wrapper.width * .7;
				close_bt.y = auth_wrapper.height * .85;
				
				close_bt.addEventListener(MouseEvent.CLICK, close_auth);
				
				function close_auth(e:MouseEvent):void {
					
					removeChild(auth_wrapper);
					removeChild(background);
					close_bt.removeEventListener(MouseEvent.CLICK, close_auth);
					form.removeEventListener(KeyboardEvent.KEY_DOWN, enter_pressed);
					
					}
				
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