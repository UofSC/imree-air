package imree.signage 
{
	import flash.display.Sprite;
	import imree.serverConnect;
	import imree.signage.signage_feed_data;
	import com.greensock.loading.XMLLoader;
	/**
	 * ...
	 * @author Jason Steelman - uscart@gmail.com
	 */
	public class signage_stack extends Sprite
	{
		private var t:signage_stack;
		public var data:XML;
		public var data_news:signage_feed_data;
		public var data_events:signage_feed_data;
		public var data_exhibits:signage_feed_data;
		public var data_alerts:signage_feed_data;
		public var data_classes:signage_feed_data;
		public var data_open_sessions:signage_feed_data;
		public var data_building_constituents:signage_feed_data;
		
		public function signage_stack(server:serverConnect, width:Number=500, height:Number=500)
		{
			server.server_command("signage_items", '', signage_items_xml_loaded);
		}
		private function signage_items_xml_loaded(xml_data:XML):void {
			this.data = xml_data;
			
			for each (var feed:XML in this.data.result.children()) {
				if (feed.signage_feed_type == "news") {
					this.data_news = signage_feed_data(feed);
				} else if (feed.signage_feed_type == "events") {
					this.data_events = signage_feed_data(feed);
				} else if (feed.signage_feed_type == "exhibits") {
					this.data_exhibits = signage_feed_data(feed);
				} else if (feed.signage_feed_type == "alerts") {
					this.data_alerts = signage_feed_data(feed);
				} else if (feed.signage_feed_type == "classes") {
					this.data_classes = signage_feed_data(feed);
				} else if (feed.signage_feed_type == "open_sessions") {
					this.data_open_sessions = signage_feed_data(feed);
				} else if (feed.signage_feed_type == "building_constituents") {
					this.data_building_constituents = signage_feed_data(feed);
				}
			}
		}
		private function load_feeds():void {
			
		}
	}

}