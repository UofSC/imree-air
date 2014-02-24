package imree 
{
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import imree.shortcuts.box;
	/**
	 * ...
	 * @author Tonya Holladay
	 */
	public class news_accordion extends Sprite 
	{
		
		public function news_accordion(items:Vector.<news_accordion_item>, w:int = 500, h:int = 100) 
		{
			/*var mask:box = new box(w, h);
			this.addChild(mask);
			this.mask = mask;
			
			w--;
			h--;
			*/
			
			var number_of_boxes:int = items.length;
			var boxes:Vector.<box> = new Vector.<box>();
			for (var i:int; i < number_of_boxes; i++) {
				var bk:box = new box(w, 300, 0x00FF00, 1, true);
				this.addChild(bk);
				
				var f:textFont = new textFont('AbrahamLincoln', 18);
				f.padding = 15;
				var headline:text = new text(items[i].headline, 100, f);
				
				
				boxes.push(bk);
				var headline_wrapper:box = new box(w * i/ number_of_boxes, 50, 0xFF0000, 1,true);
				bk.addChild(headline_wrapper);
				headline_wrapper.addChild(headline);
				bk.x = w * (i / number_of_boxes);
				bk.addEventListener(MouseEvent.CLICK, show);
				
				var desc_format:textFont = new textFont();
				var desc:text = new text(items[i].description, 300, desc_format);
				//desc.x = headline_wrapper.width;
				desc.y = headline_wrapper.height;
				bk.addChild(desc);
			}
			
			var timer:Timer = new Timer(2000);
			function show(evt:MouseEvent):void 
			{
				timer.reset();
				var focus: box = box(evt.currentTarget);
				var new_Width:Number = (w - boxes[i].width) / (number_of_boxes +1);
				
				for (var i:int = 0; i < number_of_boxes; i++) {
					
					var target_x:Number = new_Width * i;
					if (boxes[i].x <= focus.x) {
						//trace("this box is 'above' the clicked box");
					} else {
						//trace("this box is 'below' the clicked box");
						target_x += boxes[0].width - new_Width;
					}
					TweenMax.to(boxes[i], .5, { x:target_x } );
								
				}
				
				
				
				timer.addEventListener(TimerEvent.TIMER, hide);
				timer.start();
				
				function hide(evt:TimerEvent):void
				{
					for (var i:int = 0; i < number_of_boxes; i++) {
						TweenMax.to(boxes[i], .5, { x : w * (i / number_of_boxes) } );
					}
					timer.stop();
					timer.removeEventListener(TimerEvent.TIMER, hide);
					
				}				
				
				
			}
			
			
			
			
		}
		
	}

}