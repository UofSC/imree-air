package imree.data_helpers 
{
	/**
	 * ...
	 * @author Tonya Holladay
	 */
	public class data_asset extends Object
	{
		public var asset_group_assignment_id:int;
		public var asset_name:String;
		public var asset_id:int;		
		public var asset_type:String;
		public var asset_media_url:String;
		public var asset_thumb_url:String;
		public var asset_parent_id:int;
		public var asset_date_added:int;
		public var asset_date_created:int;
		
		public var xml:XML;
				
		public function data_asset(asset_xml:XML) 
		{
			
			this.asset_group_assignment_id = asset_xml.asset_group_assignment_id;
			this.asset_name = asset_xml.asset_name;
			this.asset_id = asset_xml.asset_id;
			this.asset_type = asset_xml.asset_type;
			this.asset_media_url = asset_xml.asset_type;
			this.asset_thumb_url = asset_xml.asset_thumb_url;
			this.asset_parent_id = asset_xml.asset_parent_id;
			this.asset_date_added = asset_xml.asset_date_added;
			this.asset_date_created = asset_xml.asset_date_created;
		}
		
	}

}