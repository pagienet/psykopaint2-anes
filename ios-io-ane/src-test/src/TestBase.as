package
{
	import flash.display.Sprite;
	import flash.text.TextField;

	import net.psykosoft.io.IOExtension;

	public class TestBase extends Sprite
	{
		private var _tf:TextField;

		protected var _extension:IOExtension;

		public function TestBase() {
			super();
			initConsole();
			_extension = new IOExtension();
		}

		private function initConsole():void {
			_tf = new TextField();
			_tf.name = "errors text field";
			_tf.scaleX = _tf.scaleY = 1;
			_tf.width = 1024 * 2;
			_tf.height = 250 * 2;
			_tf.background = true;
			_tf.border = true;
			_tf.multiline = true;
			_tf.wordWrap = true;
			_tf.mouseEnabled = _tf.selectable = false;
			_tf.backgroundColor = 0;
			_tf.textColor = 0xFFFFFF;
			_tf.alpha = 0.5;
			addChild( _tf );

			log( this, "IO ANE TEST" );
		}

		protected function log( ...args ):void {
			var msg:String = "";
			var len:uint = args.length;
			for( var i:uint; i < len; i++ ) {
				msg += args[ i ];
				if( len > 1 && i != len - 1 ) msg += ", ";
			}
			msg += "\n";
			_tf.appendText( msg );
			_tf.scrollV = _tf.maxScrollV;
			trace( this, msg );
		}
	}
}
