package imree.signage 
{
	import flash.display.Sprite;
	import imree.serverConnect;
	/**
	 * ...
	 * @author Jason Steelman - uscart@gmail.com
	 */
	public class signage_stack extends Sprite
	{
		private var t:signage_stack;
		public var data:XML;
		public var data_news:XML;
		public var data_events:XML;
		public var data_exhibits:XML;
		public var data_alerts:XML;
		public var data_classes:XML;
		public var data_open_sessions:XML;
		public var data_building_constituents:XML;
		
		public function signage_stack(server:serverConnect, width:Number=500, height:Number=500)
		{
			server.server_command("signage_items", '', signage_items_xml_loaded);
		}
		private function signage_items_xml_loaded(xml_data:XML):void {
			this.data = xml_data;
			for each (var feed:XML in this.data.result.children()) {
				if (feed.signage_feed_type == "news") {
					this.data_news = feed;
				} else if (feed.signage_feed_type == "events") {
					this.data_events = feed;
				} else if (feed.signage_feed_type == "exhibits") {
					this.data_exhibits = feed;
				} else if (feed.signage_feed_type == "alerts") {
					this.data_alerts = feed;
				} else if (feed.signage_feed_type == "classes") {
					this.data_classes = feed;
				} else if (feed.signage_feed_type == "open_sessions") {
					this.data_open_sessions = feed;
				} else if (feed.signage_feed_type == "building_constituents") {
					this.data_building_constituents = feed;
				}
			}
		}
		private function load_feeds():void {
			
		}
	}

}