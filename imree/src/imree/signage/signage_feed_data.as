package imree.signage 
{
	import imree.data_helpers.date_from_mysql;
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
		public var node_datetime:Date;
		public var url:String;
		public var name:String;
		public var type:String;
		
		public function signage_feed_data(xml:XML) 
		{
			this.data = xml;
			this.node_item = xml.signage_feed_node_item;
			this.node_headline = xml.signage_feed_node_headline;
			this.node_img = xml.signage_feed_node_img;
			this.node_desc = xml.signage_feed_node_desc;
			this.node_location = xml.signage_feed_node_location;
			this.node_datetime = new date_from_mysql(xml.signage_feed_node_datetime);
			this.url = xml.signage_feed_url;
			this.name = xml.signage_feed_name;
			this.type = xml.signage_feed_type;
		}
		
	}

}