package imree.signage 
{
	import flash.display.Sprite;
	import imree.data_helpers.position_data;
	import imree.layout;
	import imree.Main;
	import imree.serverConnect;
	import imree.signage.signage_feed_data;
	import com.greensock.loading.XMLLoader;
	import fl.controls.ComboBox;
	
	import flash.events.MouseEvent;
	import com.greensock.TweenMax;

	
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
		public var data_featured_event:signage_feed_data;
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
				}else if (feed.signage_feed_type == "featured event") {
					this.data_featured_event = new signage_feed_data(feed);
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
			if (this.data_featured_event) {
				this.feeds.push(this.data_featured_event);
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
									
			
			this.data_classes = this.data_news;
			if (this.data_classes) {
				var classesdisplay: signage_feed_display = new signage_feed_display(this.data_classes, stage.stageWidth *.5 , stage.stageHeight * .4);
				stage.addChild(classesdisplay);
				
				classesdisplay.feed_background_color = 0x330033;
				classesdisplay.feed_border_color = 0x800000;
				classesdisplay.feed_border_width = 5;
				classesdisplay.feed_background_alpha = 1;
				classesdisplay.draw();
				classesdisplay.x = stage.stageWidth - classesdisplay.width;
				classesdisplay.y = stage.stageHeight - classesdisplay.height;
				trace('added classes display');
			}
			
			this.data_building_constituents = this.data_exhibits;
			if (this.data_building_constituents) {
				var constituentsdisplay: signage_feed_display = new signage_feed_display(this.data_building_constituents, stage.stageWidth * .5, stage.stageHeight * .4);
				stage.addChild(constituentsdisplay);				
				constituentsdisplay.feed_background_color = 0xFFFFFF;
				constituentsdisplay.feed_border_color = 0x800000;
				constituentsdisplay.feed_border_width = 5;
				constituentsdisplay.draw();
				constituentsdisplay.x = 0;
				constituentsdisplay.y = stage.stageHeight - constituentsdisplay.height;
				trace('added constituents display');
				
			
			}
			
			this.data_open_sessions = this.data_news;
			if (this.data_open_sessions) {
				var open_sessions_display: signage_feed_display = new signage_feed_display(this.data_open_sessions, stage.stageWidth * .5, stage.stageHeight * .1);
				stage.addChild(open_sessions_display);				
				open_sessions_display.feed_background_color = 0xFFFFFF;
				open_sessions_display.feed_border_color = 0x800000;				
				open_sessions_display.feed_border_width = 5;
				open_sessions_display.draw();
				open_sessions_display.x = stage.stageWidth - open_sessions_display.width;
				open_sessions_display.y = stage.stageHeight - (constituentsdisplay.height + open_sessions_display.height);
				trace('added open_sessions display');
			}
			
				if (this.data_exhibits) {
				var exhibitdisplay: signage_feed_display = new signage_feed_display(this.data_exhibits, stage.stageWidth *.5, stage.stageHeight * .3);
				stage.addChild(exhibitdisplay);				
				exhibitdisplay.feed_background_color = 0xFFFFFF;
				exhibitdisplay.feed_border_color = 0x800000;
				exhibitdisplay.feed_border_width = 5;
				exhibitdisplay.draw();
				exhibitdisplay.x = stage.stageWidth - exhibitdisplay.width;
				exhibitdisplay.y = stage.stageHeight - (constituentsdisplay.height + open_sessions_display.height + exhibitdisplay.height);
				trace('added exhibits display');
			}
			
				if (this.data_events) {
				var eventsdisplay: signage_feed_display = new signage_feed_display(this.data_events, stage.stageWidth * .5, stage.stageHeight * .31) ;
				stage.addChild(eventsdisplay);
				eventsdisplay.feed_background_alpha = 1;
				eventsdisplay.feed_background_color = 0xFFFFFF;
				eventsdisplay.feed_border_color =0x800000;
				eventsdisplay.feed_border_width = 5;
				eventsdisplay.draw();
				eventsdisplay.x = 0;
				eventsdisplay.y = stage.stageHeight - (classesdisplay.height + eventsdisplay.height);
				trace('added events display');
			
			}
			
			this.data_featured_event = this.data_news;
			if (this.data_featured_event) {
				var featured_evt_display: signage_feed_display = new signage_feed_display(this.data_featured_event, stage.stageWidth * .5, stage.stageHeight * .1);
				stage.addChild(featured_evt_display);
				featured_evt_display.draw();
				featured_evt_display.feed_background_color = 0xFFFFFF;
				featured_evt_display.feed_border_color = 0x800000;
				featured_evt_display.feed_border_width = 5;
				featured_evt_display.x = 0;
				featured_evt_display.y = stage.stageHeight - (classesdisplay.height + eventsdisplay.height + featured_evt_display.height);
				trace('added featured evt display');
			}
			
			
				if (this.data_news) {
				var newsdisplay: signage_feed_display = new signage_feed_display(this.data_news, stage.stageWidth, stage.stageHeight * .1);
				stage.addChild(newsdisplay);				
				newsdisplay.feed_background_alpha = 1;
				newsdisplay.feed_background_color = 0xFFFFFF;
				newsdisplay.feed_border_color =0xFFFFFF;
				newsdisplay.feed_border_width = 5;
				newsdisplay.draw();
				newsdisplay.x = 0;
				newsdisplay.y = stage.stageHeight - (classesdisplay.height + eventsdisplay.height + featured_evt_display.height + newsdisplay.height);
				trace('added news display');
			}
			
			this.data_alerts = this.data_exhibits;
			if (this.data_alerts) {
				var alertdisplay: signage_feed_display = new signage_feed_display(this.data_alerts, stage.stageWidth, stage.stageHeight *.04);
				stage.addChild(alertdisplay);				
				alertdisplay.feed_background_color = 0xFFFFFF;
				alertdisplay.feed_border_color = 0x800000;
				alertdisplay.feed_border_width = 5;
				alertdisplay.draw();
				alertdisplay.x = 0;
				alertdisplay.y = stage.stageHeight - (classesdisplay.height + eventsdisplay.height + featured_evt_display.height + newsdisplay.height + alertdisplay.height);
				trace('added alert display');
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