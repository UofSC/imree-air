package imree.signage 
{
	import flash.display.Sprite;
	import imree.data_helpers.position_data;
	import imree.layout;
	import imree.Main;
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
		public var stack:Vector.<signage_feed_display>;
		public var target_w:int;
		public var target_h:int;
		
		private var server:serverConnect;
		private var our_parent:Main;
		
		
		public function signage_stack(server:serverConnect, w:int = 500, h:int = 500)
		{
			this.server = server;
			this.our_parent = Main(this.parent);
			this.target_w = w;
			this.target_h = h;
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
			if (this.data_alerts) {
				this.feeds.push(this.data_alerts);
			}
			if (this.data_building_constituents) 	{
				this.feeds.push(this.data_building_constituents);
			}
			if (this.data_classes) {
				this.feeds.push(this.data_classes);
			}
			if (this.data_events) {
				this.feeds.push(this.data_events);
			}
			if (this.data_exhibits) 	{
				this.feeds.push(this.data_exhibits);
			}
			if (this.data_news) {
				this.feeds.push(this.data_news);
			}
			if (this.data_open_sessions) {
				this.feeds.push(this.data_open_sessions);
			}
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
			//This is Tonya's and Tabitha's area to handle the constituents, alerts, classes...
			if (this.data_alerts) {
				//do alerts
				var alert_height:int = 150;
				
				this.target_h -= 150;
			}
			if (this.data_classes) {
				//draw classes
			}
			
			//This section handles all "normal" feeds as "rows" of data when that feed actually has data
			var solver:Vector.<position_data> = new layout().static_column_solver(this.feeds_active.length, this.target_w, this.target_h, 10);
			this.stack = new Vector.<signage_feed_display>();
			var i:int = 0;
			for each(var feed:signage_feed_data in this.feeds_active) {
				trace("We're loading feed name " + feed.name);
				var feed_display:signage_feed_display = new signage_feed_display(feed, solver[i].width, solver[i].height, 'static_column');
				this.addChild(feed_display);
				feed_display.draw();
				feed_display.x = solver[i].x;
				feed_display.y = solver[i].y;
				this.stack.push(feed_display);
				i++;
			}
		}
		public function feed_has_items(item:signage_feed_data,index:int,arr:Vector.<signage_feed_data>):Boolean {
			var result:Boolean = false;
			if (item.items.length > 0) {
				result = true;
			}
			if (item.type == "alerts") {
				result = false;
			}
			if (item.type == "building_constituents") {
				result = false;
			}
			return result
		}
	}

}