package imree 
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
	public class accordion extends Sprite 
	{
		
		public function accordion(items:Vector.<accordion_item>, w:int = 300, h:int = 500) 
		{
			
			var number_of_boxes:int = items.length;
			var boxes:Vector.<box> = new Vector.<box>();
			for (var i:int; i < number_of_boxes; i++) {
				var bk:box = new box(w, 300, 0x00FF00, 1, true);
				this.addChild(bk);
				//add the headline from items[i].headline;
				//add the description from items[i].description;
				
				//var font:textFont = new textFont("Lobster", 14);
				//var headline:text = new text(items[i].headline, w, font);
				var headline:TextField = new TextField();
				var f:TextFormat = new TextFormat("_sans", 20,0x000000);		
				headline.width = w;
				headline.text = items[i].headline;
				
			
				
				boxes.push(bk);
				var headline_wrapper:box = new box(w, h / number_of_boxes, 0xFF0000, 1,true);
				bk.addChild(headline_wrapper);
				headline_wrapper.addChild(headline);
				bk.y = h * (i / number_of_boxes);
				bk.addEventListener(MouseEvent.CLICK, show);
				
				var description:TextField = new TextField();
				description.multiline = true;
				description.wordWrap = true;
				description.width = w;
				description.y = headline_wrapper.height;
				description.text = items[i].description;		
				bk.addChild(description);
			}
			
			
			function show(evt:MouseEvent):void 
			{
				var focus: box = box(evt.currentTarget);
				var new_Height:Number = (h - boxes[i].height) / (number_of_boxes +1);
				trace(focus.name);
				
				
				
				for (var i:int = 0; i < number_of_boxes; i++) {
					
					var target_y:Number = new_Height * i;
					if (boxes[i].y <= focus.y) {
						trace("this box is 'above' the clicked box");
					} else {
						trace("this box is 'below' the clicked box");
						target_y += boxes[0].height - new_Height;
					}
					TweenMax.to(boxes[i], .5, { y:target_y } );
				}
				
				var timer:Timer = new Timer(2000);
				
				timer.addEventListener(TimerEvent.TIMER, hide);
				timer.start();
				
				function hide(evt:TimerEvent):void
				{
					for (var i:int = 0; i < number_of_boxes; i++) {
						TweenMax.to(boxes[i], .5, { y : h * (i / number_of_boxes) } );
					}
					timer.stop();
					timer.removeEventListener(TimerEvent.TIMER, hide);
					
				}				
				
				
			}
			
			
			
			
		}
		
	}

}