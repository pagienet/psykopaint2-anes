package
{

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;

	public class AsyncTest extends TestBase
	{
		private var _data:ByteArray;
		private var _square:Sprite;

		private const USE_COMPRESSION:Boolean = true;
		private const USE_ASYNC:Boolean = true;
		private const FILE_NAME:String = "fileWrittenByAne.jpg";
		
		public function AsyncTest() {
			super();

			simulateData();
			initFlowAnimation();
			setTimeout( test, 5000 );
		}

		private function test():void {
			writeData();
			writeData();
			writeData();
		}

		private function simulateData():void {

			// Produce an image.
			var bmd:BitmapData = new BitmapData( 2048, 1536, true, 0x00000000 );
			bmd.perlinNoise( 50, 50, 8, 1, false, true, 7, false );

			// Bmd -> ByteArray.
			_data = new ByteArray();
			bmd.copyPixelsToByteArray( bmd.rect, _data );
		}

		private function writeData():void {

			// Write.
			if( USE_ASYNC ) {
				log( "writing async..." );
				if( USE_COMPRESSION ) _extension.writeWithCompressionAsync( _data, FILE_NAME );
				else _extension.writeAsync( _data, FILE_NAME );
			}
			else {
				log( "writing sync..." );
				if( USE_COMPRESSION ) _extension.writeWithCompression( _data, FILE_NAME );
				else _extension.write( _data, FILE_NAME );
			}

			log( "done writing." );
		}

		private function initFlowAnimation():void {
			_square = new Sprite();
			_square.graphics.beginFill(0xFF0000, 1.0);
			_square.graphics.drawRect(-50, -50, 100, 100);
			_square.graphics.endFill();
			_square.x = 475;
			_square.y = 75;
			addChild( _square );
			addEventListener(Event.ENTER_FRAME, enterframeHandler);
		}

		private function enterframeHandler( event:Event ):void {
			_square.rotation += 2;
		}
	}
}
