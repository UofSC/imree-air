package imree.modules 
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import imree.data_helpers.Theme;
	import fl.controls.Button;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import imree.display_helpers.modal;
	import imree.display_helpers.smart_button;
	import imree.forms.f_data;
	import imree.forms.f_element;
	import imree.forms.f_element_text;
	import imree.Main;
	import imree.pages.exhibit_display;
	import imree.shortcuts.box;
	import imree.text;
	import imree.textFont;
	import flashx.textLayout.formats.TextAlign;
	
	/**
	 * ...
	 * @author Jason Steelman
	 */
	public class module_title extends module
	{
		private var edit_x:int;
		private var edit_y:int;
		public function module_title(_main:Main, _Exhibit:exhibit_display, _items:Vector.<module>=null)
		{
			t = this;
			super(_main, _Exhibit, _items);
		}
		override public function draw_thumb(_w:int = 200, _h:int = 200, Return:Boolean = false):* {
			var covertext:text = new text(module_name, _w * .5, Theme.font_style_title, _h * .5);
			covertext.x = (_w * .5) / 2 - covertext.width / 2;
			covertext.y = (_h * .5) / 2 - covertext.height / 2;
			var wrapper:Sprite = new Sprite();
			wrapper.addChild(covertext);
			wrapper.addChild(new box(_w * .5, _h * .5));
			if (Return) {
				var bits:BitmapData = new BitmapData(_w, _h);
				bits.draw(wrapper);
				var ret:Sprite = new Sprite();
				ret.addChild(new Bitmap(bits));
				return ret;
			} else {
				addChild(wrapper);
			}
			phase_feature = true;
		}
		override public function draw_feature(_w:int, _h:int):void {
			var covertext:text = new text(module_name, _w * .6, Theme.font_style_title, _h);
			
			covertext.x = (_w * .6) / 2 - covertext.width / 2;
			covertext.y = (_h * .6) / 2 - covertext.height / 2;
			edit_x = covertext.x;
			edit_y = covertext.y;
			addChild(covertext);
			addChild(new box(_w * .5, _h * .5));
			phase_feature = true;
		}
		override public function draw_edit_button():void {
			if (edit_button === null) {
				edit_button = new Sprite();
				var edit_ui:button_edit_module = new button_edit_module();
				main.Imree.UI_size(edit_ui);
				edit_button.addChild(edit_ui);
			}
			if (!contains(edit_button)) {
				addChild(edit_button);
				edit_button.x = edit_x - (edit_button.width);
				edit_button.y = edit_y;
				
				edit_button.transform.colorTransform = Theme.color_transform_page_buttons;
			
				TweenLite.from(edit_button, 1, {scaleX: .2, scaleY:.2, alpha:0, ease:Cubic.easeOut})
			}
			if (!edit_button.hasEventListener(MouseEvent.CLICK)) {
				edit_button.addEventListener(MouseEvent.CLICK, draw_edit_UI);
			}		
		}
		override public function draw_edit_UI(e:* = null, animate:Boolean = true, start_at_position:int =0):void {
			var buttons:Vector.<smart_button> = new Vector.<smart_button>();
			var cancel_butt_ui:Button = new Button();
			cancel_butt_ui.label = "Cancel";
			cancel_butt_ui.setSize(70, 70);
			buttons.push(new smart_button(cancel_butt_ui, close_dialog));
			
			var form:f_data;
			var elements:Vector.<f_element> = new Vector.<f_element>();
			elements.push(new f_element_text("Title", "module_name"));
			elements.push(new f_element_text("SubTitle", "module_sub_name"));
			form = new f_data(elements);
			form.connect(main.connection, int(module_id), 'modules', 'module_id');
			form.onSave = close_dialog;
			form.draw();
			var dialog:modal = new modal(main.Imree.staging_area.width, main.Imree.staging_area.height, buttons, form);
			
			main.Imree.Exhibit.overlay_add(dialog);
			main.animator.on_stage(dialog);
			
			function close_dialog(poo:*= null):void {
				main.Imree.Exhibit.overlay_remove();
				dialog = null;
				main.Imree.Exhibit.reload_current_page();
			}
		}
	}
}