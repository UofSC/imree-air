package imree.display_helpers 
{
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import fl.events.ComponentEvent;
	import fl.events.DataChangeEvent
	import flash.display.Sprite;
	import flash.events.Event;
	import imree.serverConnect;
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class list_exhibits extends Sprite
	{
		public var combo:ComboBox;
		private var conn:serverConnect;
		private var t:list_exhibits;
		public function list_exhibits(conn:serverConnect, onSelect:Function = null, filter:* = "") 
		{
			combo = null;
			this.t = this;
			this.conn = conn;
			conn.server_command("exhibits", filter, ready);
			function ready(xml:XML):void {
				var dat:Array = [];
				for each(var x:XML in xml.result.children()) {
					dat.push( {label:x.exhibit_name.toString(), data:x.exhibit_id } );
				}
				dat.push( { label:"New Exhibit", data:'new' } );
				combo = new ComboBox();
				combo.dataProvider = new DataProvider(dat);
				t.addChild(combo);
				
				if (onSelect !== null) {
					combo.addEventListener(Event.CHANGE, onSelect);
				}
			}
			
		}
		
	}

}