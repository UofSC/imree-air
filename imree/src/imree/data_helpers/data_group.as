package imree.data_helpers 
{
	/**
	 * ...
	 * @author Tonya Holladay
	 */
	public class data_group extends Object
	{
		public var group_name:String;
		public var group_id:int;
		public var group_type:String;
		public var children:Vector.<data_asset>;
		public var xml:XML;
		public function data_group(group_xml:XML) 
		{
			this.xml = group_xml;
			this.group_name = group_xml.result.group_name;
			this.group_type = group_xml.result.group_type;
			this.group_id = group_xml.result.group_id;
			children = new Vector.<data_asset>;
			
			for (var i:int = 0; i < group_xml.result.children.children().length(); i++) {
				children.push(new data_asset(group_xml.result.children.item[i]));
			}
			
		}
		
	}

}