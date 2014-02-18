package imree.data_helpers {

// Author: Rendall.
// Version: 1.0
// Described in this blog entry:
// http://rendallren.blogspot.com/2011/02/reader-friendly-keycode-class-for-as3.html
// Feel free to use and/or alter this code for any project, commercial, non-commercial, and personal.
	public class KeyCode {
		public static const A : uint = 65;
		public static const B : uint = 66;
		public static const C : uint = 67;
		public static const D : uint = 68;
		public static const E : uint = 69;
		public static const F : uint = 70;
		public static const G : uint = 71;
		public static const H : uint = 72;
		public static const I : uint = 73;
		public static const J : uint = 74;
		public static const K : uint = 75;
		public static const L : uint = 76;
		public static const M : uint = 77;
		public static const N : uint = 78;
		public static const O : uint = 79;
		public static const P : uint = 80;
		public static const Q : uint = 81;
		public static const R : uint = 82;
		public static const S : uint = 83;
		public static const T : uint = 84;
		public static const U : uint = 85;
		public static const V : uint = 86;
		public static const W : uint = 87;
		public static const X : uint = 88;
		public static const Y : uint = 89;
		public static const Z : uint = 90;

		public static const TILDE : uint = 192;
		public static const NUMBER_0 : uint = 48;
		public static const NUMBER_1 : uint = 49;
		public static const NUMBER_2 : uint = 50;
		public static const NUMBER_3 : uint = 51;
		public static const NUMBER_4 : uint = 52;
		public static const NUMBER_5 : uint = 53;
		public static const NUMBER_6 : uint = 54;
		public static const NUMBER_7 : uint = 55;
		public static const NUMBER_8 : uint = 56;
		public static const NUMBER_9 : uint = 57;

		public static const SPACEBAR : uint = 32;
		public static const ENTER : uint = 13;
		public static const CTRL : uint = 17;
		public static const SHIFT : uint = 16;

		public static const INSERT : uint = 45;
		public static const DELETE : uint = 46;
		public static const PAGE_UP : uint = 33;
		public static const PAGE_DOWN : uint = 34;
		public static const END : uint = 35;
		public static const HOME : uint = 36;

		public static const NUMPAD_0 : uint = 96;
		public static const NUMPAD_1 : uint = 97;
		public static const NUMPAD_2 : uint = 98;
		public static const NUMPAD_3 : uint = 99;
		public static const NUMPAD_4 : uint = 100;
		public static const NUMPAD_5 : uint = 101;
		public static const NUMPAD_6 : uint = 102;
		public static const NUMPAD_7 : uint = 103;
		public static const NUMPAD_8 : uint = 104;
		public static const NUMPAD_9 : uint = 105;
		public static const NUMPAD_DIVIDE : uint = 111;
		public static const NUMPAD_MULTIPLY : uint = 106;
		public static const NUMPAD_MINUS : uint = 109;
		public static const NUMPAD_PLUS : uint = 107;
		public static const NUMPAD_POINT : uint = 110;

		public static const F1 : uint = 112;
		public static const F2 : uint = 113;
		public static const F3 : uint = 114;
		public static const F4 : uint = 115;
		public static const F5 : uint = 116;
		public static const F6 : uint = 117;
		public static const F7 : uint = 118;
		public static const F8 : uint = 119;

		public static const COMMA : uint = 188;
		public static const PERIOD : uint = 190;
		public static const SEMI_COLON : uint = 186;
		public static const APOSTROPHE : uint = 222;
		public static const LEFT_BRACKET : uint = 219;
		public static const RIGHT_BRACKET : uint = 221;
		public static const HYPHEN : uint = 189;
		public static const PLUS : uint = 187;
		public static const BACK_SLASH : uint = 220;
		public static const FORWARD_SLASH : uint = 191;
		public static const TAB : uint = 9;
		public static const BACKSPACE : uint = 8;

		public static const UP : uint = 38;
		public static const DOWN : uint = 40;
		public static const LEFT : uint = 37;
		public static const RIGHT : uint = 39;
		
		// alternately
		
		public static const ARROW_UP : uint = 38;
		public static const ARROW_DOWN : uint = 40;
		public static const ARROW_LEFT : uint = 37;
		public static const ARROW_RIGHT : uint = 39;
		
		
		/**
		 * KeyCode Constructor
		 * Unnecessary to instantiate.  Just use static fields.
		 * e.g. if (keyEvent.keyCode==KeyboardCode.A) trace("A was pressed");
		 */
		public function KeyCode() {}
		
	}
}