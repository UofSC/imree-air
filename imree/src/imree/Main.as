package imree
{
	
	import com.greensock.data.TweenLiteVars;
	import com.greensock.easing.Cubic;
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import imree.data_helpers.data_value_pair;
	import imree.data_helpers.position_data;
	import imree.display_helpers.*;
	import imree.forms.*;
	import imree.images.loading_flower_sprite;
	import imree.shortcuts.box;
	import imree.exhibit;
	import imree.signage.signage_stack;
	
	
	
	/**
	 * ...
	 * @author Jason Steelman <uscart@gmail.com>, add yur name here as you work on this project/file
	 */
	public class Main extends Sprite 
	{
		public var connection:serverConnect;
		public var stack:exhibit;
		public var animator:animate;
		public function Main():void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			stage.addChild(this);
			
			animator = new animate();
			animator.off_direction = "up";
			
			//here
			/*var accord:Vector.<accordion_item> = new Vector.<accordion_item>();
				accord.push(new accordion_item("Some headline", "Some Descrip"));
				accord.push(new accordion_item("Some headline", "Some Descrip"));
				accord.push(new accordion_item("Some headline", "Some Descrip"));
				accord.push(new accordion_item("Some headline", "Some Descrip"));
				accord.push(new accordion_item("Some headline", "Some Descrip"));
			var accordian:accordion = new accordion(accord, 300, 500);
			stage.addChild(accordian);
			*/
			
			
			var news_accord:Vector.<news_accordion_item> = new Vector.<news_accordion_item>();
				news_accord.push(new news_accordion_item("Headline", "Description"));
				news_accord.push(new news_accordion_item("Headline", "Description"));
				news_accord.push(new news_accordion_item("Headline", "Description"));
				news_accord.push(new news_accordion_item("Headline", "Description"));
				news_accord.push(new news_accordion_item("Headline", "Description"));
			var news_acc: news_accordion = new news_accordion(news_accord, 300, 500);
			stage.addChild(news_acc);
			
			connection = new serverConnect("http://imree.tcl.sc.edu/imree-php/api/");
			connection.server_command("signage_mode", '', sign_mode_loader);
			function sign_mode_loader(xml:XML):void {
				if (xml.result.signage_mode == 'signage') {
					trace("Based on our IP, this device has been instructed to be digital signage");
					load_signage();
					
				} else {
					trace("Based on our IP, this device has been instructed to be IMREE");
					load_imree();
				}
			}
		}
		
		private function load_signage():void {
			var stack:signage_stack = new signage_stack(connection, this.stage.stageWidth, this.stage.stageHeight);
			stage.addChild(stack);
		}
		
		private function load_imree():void {
			
			
			
			//var auth:authentication = new authentication(connection, loggedIn);
			//this.addChild(auth);
			
			/**
			function loggedIn(e:*= null):void {
				animator.off_stage(auth);
				var options:Vector.<data_value_pair> = new Vector.<data_value_pair>();
					options.push(new data_value_pair("Systems", 2));
					options.push(new data_value_pair("RBSC", 1));
					options.push(new data_value_pair("SCPC", 3));
				var exh:Vector.<f_element> = new Vector.<f_element>();
				exh.push(new f_element_text("Name", "exhibit_name"));
				exh.push(new f_element_text("Start Date", "exhibit_date_start"));
				exh.push(new f_element_select("Deptartment", "exhibit_department_id",options, "Please Select"));
				var form:f_data = new f_data(exh);
				form.connect(connection, 1, 'exhibits', 'exhibit_id');
				form.draw();
				addChild(form);
			}
			
			*/
			
			/**
			
			var sample:Vector.<position_data> = new Vector.<position_data>();
			for (var i:int = 0; i < 500; i++) {
				var w:int = Math.round((Math.random() * 3));
				var h:int = Math.round((Math.random() * 2));
				sample.push(new position_data(100 * w, 100 * h));
			}
			var stack_container:Sprite = new Sprite();
			stage.addChild(stack_container);
			var ly:layout = new layout();
			var result:Vector.<position_data> = ly.abstract_box_solver(sample, stage.stageWidth, stage.stageHeight, 1, "left");
			for each(var pos:position_data in result) {
				var bk:box = new box(pos.width, pos.height, Math.random() * 0xFFFFFF, .5);
				stack_container.addChild(bk);
				bk.x = pos.x;
				bk.y = pos.y;
			}
			stack_container.addEventListener(MouseEvent.MOUSE_DOWN, d0);
			stack_container.addEventListener(MouseEvent.MOUSE_UP, d1);
			function d0(e:MouseEvent):void {
				stack_container.startDrag(false, new Rectangle(stack_container.width * -1, 0, stack_container.width, 0));
			}
			function d1(e:MouseEvent):void {
				stack_container.stopDrag();
			}
			
			
			
			/*
			 * var sample_string:String = "<?xml version='1.0' encoding='utf-8' ?><flow:TextFlow whiteSpaceCollapse='preserve' xmlns:flow='http://ns.adobe.com/textLayout/2008'><flow:p><flow:span>Hoodie vero enim, XOXO Bushwick non </flow:span><flow:span textDecoration=\"underline\">8-bit</flow:span><flow:span> meh kitsch direct trade. Brooklyn authentic aesthetic, cillum paleo 8-bit PBR&B biodiesel nisi skateboard cornhole pork belly freegan ad. Pork belly distillery authentic irony aliquip cornhole. Odd Future art party ethnic, sustainable flannel fixie pork belly placeat gentrify yr flexitarian letterpress. Pop-up laboris synth stumptown Marfa messenger bag. Sunt dolore selfies eiusmod tofu assumenda. Chillwave small batch cornhole veniam duis.</flow:span></flow:p></flow:TextFlow>";
			var Format:textFont = new textFont('OpenSansLight',18);
			var txt:text = new text(sample_string, 400, Format);
			stage.addChild(txt);
			*/
			
			var items:Vector.<accordion_item> = new Vector.<accordion_item>();
			items.push(new accordion_item("Sample headline 1", "Veniam artisan you probably haven't heard of them, commodo direct trade literally sed High Life distillery. Cliche pug chillwave, minim actually quis church-key. Pork belly proident veniam, labore velit small batch four loko meggings Terry Richardson. Fashion axe paleo VHS retro Odd Future, post-ironic voluptate mustache elit roof party tofu High Life semiotics gluten-free before they sold out. Portland Tumblr deep v, High Life Pinterest mixtape occaecat street art Austin mlkshk. Id Cosby sweater 8-bit bicycle rights, nostrud consequat put a bird on it Neutra pop-up vegan occupy banjo disrupt sustainable meggings. Freegan excepteur deserunt, distillery farm-to-table tofu trust fund."));
			items.push(new accordion_item("Sample headline 2", "Fanny pack trust fund consequat placeat officia salvia asymmetrical ennui, letterpress polaroid beard Tonx occupy. Seitan umami Etsy hashtag. Voluptate art party narwhal occaecat cliche Intelligentsia asymmetrical duis VHS, esse pop-up stumptown. Godard yr qui bitters banh mi. IPhone typewriter do swag, mollit seitan fanny pack ea shabby chic assumenda cardigan Godard chillwave. Duis Austin bespoke, small batch tattooed cred Tonx organic plaid do seitan aute Neutra delectus forage. Synth gastropub anim, iPhone deep v chillwave master cleanse."));
			//items.push(new accordion_item("Sample headline 3", "Austin mollit sint assumenda farm-to-table ut. High Life ad tote bag ethnic jean shorts. Skateboard PBR&B cliche, nisi pariatur food truck VHS hoodie ex meh vinyl. VHS laboris odio, nesciunt hoodie asymmetrical Echo Park blog. Put a bird on it nulla keytar beard. Master cleanse Terry Richardson gentrify, beard bicycle rights eiusmod asymmetrical vinyl. Esse exercitation craft beer chia, occupy aliquip vero proident dolore paleo small batch veniam Wes Anderson."));
			//items.push(new accordion_item("Sample headline 4", "Quinoa Blue Bottle occupy Carles swag elit PBR&B, Vice eu proident. Wayfarers do fanny pack ennui, you probably haven't heard of them photo booth 90's brunch Blue Bottle polaroid fap post-ironic DIY. Fanny pack elit swag, cred craft beer ethical cupidatat nulla Pitchfork gastropub jean shorts 3 wolf moon twee. Consequat readymade food truck, beard Intelligentsia ex Williamsburg laborum narwhal ennui duis umami Etsy squid sunt. Kogi ethical delectus dreamcatcher VHS. Fap Terry Richardson butcher forage. Synth dolore asymmetrical, Intelligentsia mixtape occupy messenger bag High Life chambray ethical wolf Wes Anderson DIY."));
			//items.push(new accordion_item("Sample headline 5", "Pop-up forage cupidatat sed, PBR cred gluten-free messenger bag nulla ut deserunt pour-over elit selfies. Organic meggings kale chips magna tousled small batch, Cosby sweater craft beer narwhal ethical fap. Whatever beard XOXO occupy, flannel Wes Anderson keytar DIY Pinterest authentic bespoke sartorial kale chips 8-bit locavore. Freegan craft beer Helvetica eu keffiyeh veniam, kitsch raw denim ut asymmetrical typewriter kogi banjo. Tousled XOXO messenger bag food truck DIY cray. Blog selvage anim Truffaut trust fund fugiat, fashion axe lo-fi. Neutra American Apparel pug, chillwave vinyl Bushwick qui farm-to-table Tonx."));
			items.push(new accordion_item("Sample headline 6", "Vice Wes Anderson pour-over, flexitarian sunt authentic +1 cardigan chillwave letterpress plaid mollit whatever elit Odd Future. Deep v est butcher semiotics. Fugiat nisi PBR&B ea ad tempor officia, cornhole keytar authentic Pitchfork mumblecore literally. Adipisicing street art sed, Brooklyn chia kitsch do cred id keytar laboris sunt. Cliche you probably haven't heard of them Etsy, VHS id mlkshk pork belly Neutra pour-over asymmetrical gluten-free iPhone food truck brunch sriracha. Meggings consectetur four loko Bushwick chillwave polaroid, freegan ugh ethical bespoke mustache pickled Tumblr fugiat. Dreamcatcher mollit synth pork belly, freegan lomo selfies esse quis stumptown 90's drinking vinegar."));
			items.push(new accordion_item("Sample headline 7", "Dolor distillery hashtag direct trade viral et, photo booth High Life umami. Cardigan VHS umami twee. Typewriter put a bird on it assumenda irony aute Cosby sweater. Dolore in proident, gluten-free iPhone Marfa keffiyeh asymmetrical aesthetic pug. Tumblr duis pickled small batch master cleanse, dolor qui paleo disrupt cray hoodie street art. Banh mi occaecat kitsch disrupt, asymmetrical proident sartorial squid excepteur retro brunch fashion axe. Odio art party Pitchfork, church-key retro veniam kale chips slow-carb velit 3 wolf moon lomo delectus viral twee consequat."));
			var acc:accordion = new accordion(items);
			//stage.addChild(acc);
		}
		
		private function deactivate(e:Event):void 
		{
			// make sure the app behaves well (or exits) when in background
			//NativeApplication.nativeApplication.exit();
		}
		public function randomize ( a : *, b : * ) : int {
			return ( Math.random() > .5 ) ? 1 : -1;
		}
		
		
	}
	
}