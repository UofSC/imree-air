package imree.signage 
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.XMLLoader;
	import imree.data_helpers.date_from_mysql;
	import imree.data_helpers.date_helper;
	import imree.serverConnect;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class signage_feed_data extends Object
	{
		public var data:XML;
		public var node_item:String;
		public var node_headline:String;
		public var node_img:String;
		public var node_desc:String;
		public var node_location:String;
		public var node_datetime:String;
		public var url:String;
		public var name:String;
		public var type:String;
		public var count:int;
		public var items:Vector.<signage_feed_item_data>;
		private var initial_callback:Function;
		private var t:signage_feed_data;
		public function signage_feed_data(xml:XML)
		{
			t = this;
			this.node_item = xml.signage_feed_node_item;
			this.node_headline = xml.signage_feed_node_headline;
			this.node_img = xml.signage_feed_node_img;
			this.node_desc = xml.signage_feed_node_desc;
			this.node_location = xml.signage_feed_node_location;
			this.node_datetime = xml.signage_feed_node_datetime;
			this.url = xml.signage_feed_url;
			this.name = xml.signage_feed_name;
			this.type = xml.signage_feed_type;
			this.items = new Vector.<signage_feed_item_data>;
		}
		
		public function load(callback:Function = null):void {
			var xmlloader:XMLLoader = new XMLLoader(this.url, { onComplete:complete, onFail:fail, onIOError:ioerror } );
			xmlloader.load();
			function fail(e:LoaderEvent):void {	}
			function ioerror(e:LoaderEvent):void { }
			function complete(e:LoaderEvent):void {
				var x:XML = new XML(xmlloader.content);
				t.data = x;
				if (x.descendants(t.node_item).length() === 0) {
					t.count = 0;
					trace(t.name + " is empty?");
				} else {
					
					for each(var item:XML in x.descendants(t.node_item)) {
						var item_data:signage_feed_item_data = new signage_feed_item_data();
							item_data.headline = String(item[t.node_headline]);
							item_data.description = String(item[t.node_desc]);
							item_data.image_url = String(item[t.node_img]);
							item_data.location = String(item[t.node_location]);
							if (item[t.node_datetime].toString().length === 19) {
								var date_help:date_helper = new date_helper(item[t.node_datetime].toString());
								item_data.datetime = date_help.from_mysql();
							} else {
								item_data.datetime = null;
							}
							
						t.items.push(item_data);
					}
				}
				if (callback !== null) {
					callback();
				}
				
				trace(x);
			}
			
		}
		
		
	}

}