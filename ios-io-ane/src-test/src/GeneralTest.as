package
{

	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;

	import net.psykosoft.psykopaint2.base.utils.io.BinaryIoUtil;

	public class GeneralTest extends TestBase
	{
		private var _time:uint;

		private const USE_COMPRESSION:Boolean = true;
		private const AS3_FILE_NAME:String = "fileWrittenByAS3.jpg";
		private const ANE_FILE_NAME:String = "fileWrittenByAne.jpg";

		public function GeneralTest() {
			super();

			writeTest();
			readTest();
		}

		// ---------------------------------------------------------------------
		// Tests.
		// ---------------------------------------------------------------------

		private function writeTest():void {

			log( this, "write test..." );

			// Produce an image.
			var bmd:BitmapData = new BitmapData( 2048, 1536, true, 0x00000000 );
			bmd.perlinNoise( 50, 50, 8, 1, false, true, 7, false );

			// Bmd -> ByteArray.
			var bytes:ByteArray = new ByteArray();
			bmd.copyPixelsToByteArray( bmd.rect, bytes );
			var bytes1:ByteArray = cloneByteArray( bytes );
			var bytes2:ByteArray = cloneByteArray( bytes );

			log( this, "writing: " + bytes.length + " bytes" );

			// Test write using ane.
			_time = getTimer();
			if( USE_COMPRESSION ) _extension.writeWithCompression( bytes1, ANE_FILE_NAME );
			else _extension.write( bytes1, ANE_FILE_NAME );
//			_extension.writeWithCompression( bytes2, "fileWrittenByAne1.jpg" );
			log( this, "ane took: " + String( getTimer() - _time ) + "ms" );

			// Test write using as3.
			_time = getTimer();
			var as3WriteUtil:BinaryIoUtil = new BinaryIoUtil( BinaryIoUtil.STORAGE_TYPE_IOS );
			if( USE_COMPRESSION ) bytes2.compress();
			as3WriteUtil.writeBytesSync( AS3_FILE_NAME, bytes2 );
			log( this, "as3 took: " + String( getTimer() - _time ) + "ms" );
		}

		private function readTest():void {

			log( this, "read test..." );

			// Test read using ane.
			var bytes:ByteArray = new ByteArray();
			_time = getTimer();
			if( USE_COMPRESSION ) _extension.readWithDeCompression( bytes, ANE_FILE_NAME );
			_extension.read( bytes, ANE_FILE_NAME );
			log( this, "read ios: " + bytes.length + " bytes, took: " + String( getTimer() - _time ) + "ms" );

			// Test read using as3.
			_time = getTimer();
			var as3WriteUtil:BinaryIoUtil = new BinaryIoUtil( BinaryIoUtil.STORAGE_TYPE_IOS );
			as3WriteUtil.readBytesAsync( AS3_FILE_NAME, onAs3DoneReading );
		}

		private function onAs3DoneReading( bytes:ByteArray ):void {
			if( USE_COMPRESSION ) bytes.uncompress();
			log( this, "read as3: " + bytes.length + " bytes, took: " + String( getTimer() - _time ) + "ms" );
		}

		// ---------------------------------------------------------------------
		// Utils.
		// ---------------------------------------------------------------------

		private function cloneByteArray( source:ByteArray ):ByteArray {
			var clone:ByteArray = new ByteArray();
			clone.writeBytes( source, 0, source.length );
			return clone;
		}
	}
}
