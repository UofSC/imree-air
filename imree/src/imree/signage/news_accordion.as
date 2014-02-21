package imree.signage 
{
	import com.greensock.TweenMax;
	import flash.display.Sprite;
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
		
		public function news_accordion(items:Vector.<news_accordion_items>, w:int = 300, h:int = 100) 
		{
			//var mask:box = new box(w, h);
			//this.addChild(mask);
			//this.mask = mask;
			//w--;
			//h--;
			var number_of_boxes:int = items.length;
			var boxes:Vector.<box> = new Vector.<box>();
			for (var i:int; i < number_of_boxes; i++) {
				var bk:box = new box(w, 300, 0x00FF00, 1, true);
				this.addChild(bk);
				//add the headline from items[i].headline;
				//add the description from items[i].description;
				
				//var font:textFont = new textFont("Lobster", 14);
				//var headline:text = new text(items[i].headline, w, font);
				/*
				 * var headline:TextField = new TextField();
				var f:TextFormat = new TextFormat("_sans", 20,0x000000);		
				headline.width = w;
				headline.text = items[i].headline;
				*/
				var f:textFont = new textFont('AbrahamLincoln', 18);
				f.padding = 15;
				var headline:text = new text(items[i].headline, 300, f);
				
				
				boxes.push(bk);
				var headline_wrapper:box = new box(w, h / number_of_boxes, 0xFF0000, 1,true);
				bk.addChild(headline_wrapper);
				headline_wrapper.addChild(headline);
				bk.x = w * (i / number_of_boxes);
				bk.addEventListener(MouseEvent.CLICK, show);
				
				var desc_format:textFont = new textFont();
				var desc:text = new text(items[i].description, 300, desc_format);
				desc.w = headline_wrapper.width;
				bk.addChild(desc);
			}
			
			var timer:Timer = new Timer(2000);
			function show(evt:MouseEvent):void 
			{
				timer.reset();
				var focus: box = box(evt.currentTarget);
				var new_Height:Number = (w - boxes[i].width) / (number_of_boxes +1);
				
				for (var i:int = 0; i < number_of_boxes; i++) {
					
					var target_x:Number = new_Width * i;
					if (boxes[i].w <= focus.x) {
						//trace("this box is 'above' the clicked box");
					} else {
						//trace("this box is 'below' the clicked box");
						target_w += boxes[0].width - new_Width;
					}
					TweenMax.to(boxes[i], .5, { x:target_w } );
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