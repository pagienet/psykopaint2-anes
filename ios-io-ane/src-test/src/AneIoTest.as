package
{

	import by.blooddy.crypto.image.PNG24Encoder;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;

	import net.psykosoft.io.IOExtension;
	import net.psykosoft.psykopaint2.base.utils.io.BinaryIoUtil;

	public class AneIoTest extends Sprite
	{
		private var _extension:IOExtension;

		public function AneIoTest() {
			super();

			initConsole();

			_extension = new IOExtension();
			_extension.initialize( onInitialized );
		}

		private function onInitialized():void {
			writeTest();
		}

		// ---------------------------------------------------------------------
		// Tests.
		// ---------------------------------------------------------------------

		private function writeTest():void {

			trace( this, "write test..." );

			// Produce an image.
			var bmd:BitmapData = new BitmapData( 2048, 1536, true, 0x00000000 );
			bmd.perlinNoise( 50, 50, 8, 1, false, true, 7, false );

			// Bmd -> ByteArray.
			var bytes:ByteArray = new ByteArray();
			bmd.copyPixelsToByteArray( bmd.rect, bytes );

			// ByteArray -> PNG.
//			var pngBytes:ByteArray = PNG24Encoder.encode( bmd );
			var pngBytes1:ByteArray = cloneByteArray( bytes );
			var pngBytes2:ByteArray = cloneByteArray( bytes );

			// Test write with compression using ane.
			var time:uint = getTimer();
			_extension.writeWithCompression( pngBytes1, "fileWrittenByAne.jpg" );
			log( this, "ane took: " + String( getTimer() - time ) + "ms" );

			// Test write with compression using as3.
			time = getTimer();
			var infoWriteUtil:BinaryIoUtil = new BinaryIoUtil( BinaryIoUtil.STORAGE_TYPE_IOS );
			pngBytes2.compress();
			infoWriteUtil.writeBytesSync( "fileWrittenByAS3.jpg", pngBytes2 );
			log( this, "as3 took: " + String( getTimer() - time ) + "ms" );
		}

		// ---------------------------------------------------------------------
		// Utils.
		// ---------------------------------------------------------------------

		private function cloneByteArray( source:ByteArray ):ByteArray {
			var clone:ByteArray = new ByteArray();
			clone.writeBytes( source, 0, source.length );
			return clone;
		}

		// ---------------------------------------------------------------------
		// Console.
		// ---------------------------------------------------------------------

		private var _tf:TextField;

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

		private function log( ...args ):void {
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
