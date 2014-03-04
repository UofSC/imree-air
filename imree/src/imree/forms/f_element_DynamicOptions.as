package imree.forms 
{
	import imree.data_helpers.data_value_pair;
	import imree.serverConnect;
	import com.greensock.events.LoaderEvent;
	
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class f_element_DynamicOptions extends Object
	{
		public var onUpdate:Function;
		public var table:String;
		public var key_column:String;
		public var label_column:String;
		public var is_ready:Boolean;
		public var data:Vector.<data_value_pair>;
		private var conn:serverConnect;
		private var t:f_element_DynamicOptions;
		public var parent:f_element;
		public function f_element_DynamicOptions(_conn:serverConnect, _table:String, _key_column:String, _label_column:String, _onUpdate:Function = null, parent_element:f_element = null) 
		{
			t = this;
			data = new Vector.<data_value_pair>();
			is_ready = false;
			conn = _conn;
			table = _table;
			key_column = _key_column;
			label_column = _label_column;
			onUpdate = _onUpdate;
			parent = parent_element;
			//fetch();
		}
		public function fetch():void {
			is_ready = false;
			var query:Object = { };
				query.table = table;
				query.columns = {0:key_column, 1:label_column};
				query.where = " 1";
			conn.server_command("query", query, fetched, true);
		}
		public function fetched(evt:LoaderEvent):void {
			var xml:XML = XML(evt.currentTarget.content);
			dump();
			for each(var i:XML in xml.result.children()) {
				data.push(new data_value_pair(i[label_column], i[key_column]));
			}
			is_ready = true;
			if (onUpdate != null) {
				onUpdate();
			} else if (t.parent !== null) {
				t.parent.options = data;
				t.parent.draw();
			}
		}
		public function dump():void {
			while (data.length) {
				data.pop();
			}
		}
		
	}

}