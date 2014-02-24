package imree.signage 
{
	
	
	
	import flash.display.Sprite;
	import imree.data_helpers.position_data;
	import imree.layout;
	import imree.Main;
	import imree.serverConnect;
	import imree.shortcuts.box;
	import imree.signage.signage_feed_data;
	import com.greensock.loading.XMLLoader;
	import imree.text;
	import imree.textFont;
	import imree.*;
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
			var tonyasUnit:Number = stage.stageHeight / 24;
			
			var format:textFont = new textFont();
			
			trace(tonyasUnit);
			
			var alerts_wrapper:box = new box(stage.stageWidth, 1 * tonyasUnit, 0xFFFF80, 1);
			this.addChild(alerts_wrapper);
			alerts_wrapper.x = 0;
			alerts_wrapper.y = 0;
			
			var news_wrapper:box = new box(stage.stageWidth, 3 * tonyasUnit, 0x0000FF, 1);
			this.addChild(news_wrapper);
			news_wrapper.x = 0;
			news_wrapper.y = 1 * tonyasUnit;
			
			var events_wrapper:box = new box(stage.stageWidth, 13 * tonyasUnit, 0x008040, 1);
			this.addChild(events_wrapper);
			events_wrapper.x = 0;
			events_wrapper.y = 4 * tonyasUnit;
			
			var eventsList_wrapper:box = new box(stage.stageWidth * .4, 9 * tonyasUnit, 0xFF8000, 1);
			events_wrapper.addChild(eventsList_wrapper);
			eventsList_wrapper.x = 0;
			eventsList_wrapper.y = 4 * tonyasUnit;
			
			var featured_evt_wrapper: box = new box (stage.stageWidth * .4, 4 * tonyasUnit, 0xFF0000, 1);
			events_wrapper.addChild(featured_evt_wrapper);
			
			var evt_title:box = new box (stage.stageWidth, .5 * tonyasUnit, 0x800000, 1);
			eventsList_wrapper.addChild(evt_title);
			
			var evt_title_format:textFont = new textFont('_sans', 18);
				evt_title_format.color = 0xFFFFFF;
				evt_title.addChild(new text ("Events", evt_title.width, evt_title_format));
						
			
			var spotlight_wrapper:box = new box(stage.stageWidth * .6, events_wrapper.height, 0x00FFFF, 1);
			events_wrapper.addChild(spotlight_wrapper);
			spotlight_wrapper.x = stage.stageWidth * .4;
			spotlight_wrapper.y = 0;
			
			var openSession_wrapper: box = new box (spotlight_wrapper.width, 3 * tonyasUnit, 0xFF8080, 1);
			spotlight_wrapper.addChild(openSession_wrapper);
			openSession_wrapper.y = 10 * tonyasUnit;
			
			
			var openSession_title: box = new box (openSession_wrapper.width, .5 * tonyasUnit, 0x800000, 1);
			openSession_wrapper.addChild(openSession_title);
			var openSessions_title_format:textFont = new textFont('_sans', 20);
				openSessions_title_format.color = 0xFFFFFF;
			openSession_title.addChild(new text ("Open Study Sessions", openSession_title.width, openSessions_title_format));
			
			
			var class_wrapper:box = new box(stage.stageWidth, 7 * tonyasUnit, 0x800080, 1);
			this.addChild(class_wrapper);
			class_wrapper.x = 0;
			class_wrapper.y = 17 * tonyasUnit;
			
			var classWrap_title:box = new box (class_wrapper.width, .5 * tonyasUnit, 0x800000, 1);
			class_wrapper.addChild(classWrap_title);
			
			var classWrap_title_format:textFont = new textFont('_sans', 18);
				classWrap_title_format.color = 0xFFFFFF;
				classWrap_title.addChild(new text ("Classes and Workshops", classWrap_title.width, classWrap_title_format));
			
			
			var cons_wrapper:box = new box (stage.stageWidth * .3, class_wrapper.height, 0xFFFF00, 1);
			class_wrapper.addChild(cons_wrapper);
			cons_wrapper.x = stage.stageWidth * .7;
			
			var cons_data:Vector.<accordion_item> = new Vector.<accordion_item>();
			for (var i:int = 0; i < data_building_constituents.items.length; i++) {
				cons_data.push(new accordion_item(data_building_constituents.items[i].headline, data_building_constituents.items[i].description));
			}
			
			var cons_accord:accordion = new accordion(cons_data, cons_wrapper.width, cons_wrapper.height);
			cons_wrapper.addChild(cons_accord);
			
			
			if (this.data_news) {
				var newsdisplay: signage_feed_display = new signage_feed_display(this.data_news, news_wrapper.width, news_wrapper.height);
				news_wrapper.addChild(newsdisplay);				
				newsdisplay.feed_background_alpha = 1;
				newsdisplay.feed_background_color = 0xFFFFFF;
				newsdisplay.feed_border_color =0x000000;
				newsdisplay.feed_border_width = 1;
				newsdisplay.draw();
				trace('added news display');
			}
			
			if (this.data_events) {
				var eventsdisplay: signage_feed_display = new signage_feed_display(this.data_events,eventsList_wrapper.width, eventsList_wrapper.height);
				eventsList_wrapper.addChild(eventsdisplay);
				eventsdisplay.feed_background_alpha = 1;
				eventsdisplay.feed_background_color = 0xFFFFFF;
				eventsdisplay.feed_border_color =0x800000;
				eventsdisplay.feed_border_width = 1;
				eventsdisplay.draw();
				trace('added events display');
			
			}
		}
			 
	
	
			/*this.feeds_active = this.feeds.filter(feed_has_items);
			//This is Tonya's and Tabitha's area to handle the constituents, alerts, classes...
			if (this.data_alerts) {
				//do alerts
				var alert_height:int = 150;
		}
				
				this.target_h -= 150;
			}
			
			/if (this.data_classes) {
				//draw classes
			}
									
	
		
			/*this.data_classes = this.data_news;
			if (this.data_classes) {
				var classesdisplay: signage_feed_display = new signage_feed_display(this.data_classes, class_wrapper.width , class_wrapper.height);
				stage.addChild(classesdisplay);
				
				classesdisplay.feed_background_color = 0x330033;
				classesdisplay.feed_border_color = 0x800000;
				classesdisplay.feed_border_width = 5;
				classesdisplay.feed_background_alpha = 1;
				classesdisplay.draw();
				trace('added classes display');
			}

			
			/*this.data_building_constituents = this.data_exhibits;
			if (this.data_building_constituents) {
				var constituentsdisplay: signage_feed_display = new signage_feed_display(this.data_building_constituents, stage.stageWidth * .5, stage.stageHeight * .4);
				stage.addChild(constituentsdisplay);				
				constituentsdisplay.feed_background_color = 0xFFFFFF;
				constituentsdisplay.feed_border_color = 0x800000;
				constituentsdisplay.feed_border_width = 5;
				constituentsdisplay.draw();
				trace('added constituents display');
				
				
			
			}
			
			this.data_open_sessions = this.data_events;
			if (this.data_open_sessions) {
				var open_sessions_display: signage_feed_display = new signage_feed_display(this.data_open_sessions, openSession_wrapper.width , openSession_wrapper.height);
				stage.addChild(open_sessions_display);				
				open_sessions_display.feed_background_color = 0xFFFFFF;
				open_sessions_display.feed_border_color = 0x800000;				
				open_sessions_display.feed_border_width = 5;
				open_sessions_display.draw();
				trace('added open_sessions display');
			}
			
				
			
				if (this.data_events) {
				var eventsdisplay: signage_feed_display = new signage_feed_display(this.data_events,eventsList_wrapper.width, eventsList_wrapper.height);
				stage.addChild(eventsdisplay);
				eventsdisplay.feed_background_alpha = 1;
				eventsdisplay.feed_background_color = 0xFFFFFF;
				eventsdisplay.feed_border_color =0x800000;
				eventsdisplay.feed_border_width = 5;
				eventsdisplay.draw();
				trace('added events display');
			
			}
			
			this.data_featured_event = this.data_events;
			if (this.data_featured_event) {
				var featured_evt_display: signage_feed_display = new signage_feed_display(this.data_featured_event, featured_evt_wrapper.width, featured_evt_wrapper.height);
				stage.addChild(featured_evt_display);
				featured_evt_display.feed_background_color = 0xFFFFFF;
				featured_evt_display.feed_border_color = 0x800000;
				featured_evt_display.feed_border_width = 5;
				featured_evt_display.draw();
				trace('added featured evt display');
			}
			
			
			this.data_alerts = this.data_exhibits;
			if (this.data_alerts) {
				var alertdisplay: signage_feed_display = new signage_feed_display(this.data_alerts, alerts_wrapper.width, alerts_wrapper.height);
				stage.addChild(alertdisplay);				
				alertdisplay.feed_background_color = 0xFFFFFF;
				alertdisplay.feed_border_color = 0x800000;
				alertdisplay.feed_border_width = 5;
				alertdisplay.draw();
				trace('added alert display');
			}*/
			
			
	
			
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