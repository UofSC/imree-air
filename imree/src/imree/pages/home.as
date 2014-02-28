package imree.pages 
{
	import com.greensock.events.LoaderEvent;
	import flash.display.Sprite;
	import imree.serverConnect;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class home extends Sprite
	{
		private var conn:serverConnect;
		public var xml:XML;
		public function home(_w:int, _h:int, _conn:serverConnect) 
		{
			conn = _conn;
			conn.server_command("exhibits", "", exhibits_data_receieved);
		}
		public function exhibits_data_receieved(e:LoaderEvent):void {
			xml = XML(e.target.content);
			for each(var item:XML in xml.result.children()) {
				trace(item);
			}
		}
		
	}

}