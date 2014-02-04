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
		public var feeds_count:int;
		public var feeds_ready:int;
		public var feeds:Vector.<signage_feed_data>;
		public var feeds_active:Vector.<signage_feed_data>;
		private var server:serverConnect;
		
		
		public function signage_stack(server:serverConnect, width:Number=500, height:Number=500)
		{
			this.server = server;
			this.feeds = new Vector.<signage_feed_data>();
			server.server_command("signage_items", '', signage_items_xml_loaded);
		}
		
		private function signage_items_xml_loaded(xml_data:XML):void {
			this.data = xml_data;
			this.feeds_count = this.data.result.children().length();
			this.feeds_ready = 0;
			for each (var feed:XML in this.data.result.children()) {
				if (feed.signage_feed_type == "news") {
					this.data_news = new signage_feed_data(feed);
				} else if (feed.signage_feed_type == "events") {
					this.data_events = new signage_feed_data(feed);
				} else if (feed.signage_feed_type == "exhibits") {
					this.data_exhibits = new signage_feed_data(feed);
				} else if (feed.signage_feed_type == "alerts") {
					this.data_alerts = new signage_feed_data(feed);
				} else if (feed.signage_feed_type == "classes") {
					this.data_classes = new signage_feed_data(feed);
				} else if (feed.signage_feed_type == "open_sessions") {
					this.data_open_sessions = new signage_feed_data(feed);
				} else if (feed.signage_feed_type == "building_constituents") {
					this.data_building_constituents = new signage_feed_data(feed);
				}
			}
			load_feeds();
		}
		
		private function load_feeds():void {
			if (this.data_alerts) 						this.feeds.push(data_alerts);
			if (this.data_building_constituents) 		this.feeds.push(this.data_building_constituents);
			if (this.data_classes) 						this.feeds.push(this.data_classes);
			if (this.data_events) 						this.feeds.push(this.data_events);
			if (this.data_exhibits) 					this.feeds.push(this.data_exhibits);
			if (this.data_news) 						this.feeds.push(this.data_news);
			if (this.data_open_sessions) 				this.feeds.push(this.data_open_sessions);
			for each (var f:signage_feed_data in this.feeds) {
				f.load(feed_loaded);
			}
		}
		
		public function feed_loaded():void {
			this.feeds_ready++;
			if (this.feeds_ready === this.feeds_count) {
				draw();
			}
		}
		
		public function draw():void {
			this.feeds_active = this.feeds.filter(feed_has_items);
			for each(var feed:signage_feed_data in this.feeds_active) {
				trace("We're loading feed name " + feed.name);
			}
		}
		public function feed_has_items(item:signage_feed_data,index:int,arr:Vector.<signage_feed_data>):Boolean {
			return item.items.length > 0;
		}
	}

}