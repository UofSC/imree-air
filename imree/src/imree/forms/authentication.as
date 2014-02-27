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
		public function authentication(server:serverConnect, _onSuccess:Function) 
		{
			t = this;
			conn = server;
			onSuccess = _onSuccess;
			t.addEventListener(Event.ADDED_TO_STAGE, added_to_stage);
		}
		private function added_to_stage(e:Event):void {
			t.removeEventListener(Event.ADDED_TO_STAGE, added_to_stage);
			if (t.conn.session_key === null) {
				var background:box = new box(stage.stageWidth, stage.stageHeight, 0x000000, .6);
				t.addChild(background);
				
				var auth_wrapper:box = new box(400, 400, 0xDEDEDE, 1);
				t.addChild(auth_wrapper);
				auth_wrapper.center();
				
				var labelfont:textFont = new textFont('_sans', 22);
				var inputFormat:TextFormat = new TextFormat("_sans", 20);
				
				var title:text = new text("Please log in", 300, new textFont('_sans', 32));
				auth_wrapper.addChild(title);
				title.y = 10;
				title.center_x(auth_wrapper);
				
				var elements:Vector.<f_element> = new Vector.<f_element>();
					elements.push(new f_element_text("Username", 'username','steelmaj@mailbox.sc.edu'));
					elements.push(new f_element_password("Password", 'password','helpinghand'));
				var form:f_data = new f_data(elements);
					form.layout(16, 380, 300);
					form.onSubmit = auth;
					form.draw();
					form.y = 50;
				auth_wrapper.addChild(form);
				
				
			} else {
				//how you say already logged in?
			}
		}
		private function auth(elements:Object):void {
			
			conn.server_command('login', { username:elements.username, password:elements.password}, response );
			function response(evt:LoaderEvent):void {
				var xml:XML = XML(evt.currentTarget.content);
				if (xml.result == "false") {
					//do fail message
				} else {
					conn.username = elements.username;
					conn.set_password(elements.password);
					onSuccess();
				}
			}
		}
		
	}

}