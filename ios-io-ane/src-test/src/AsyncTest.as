package
{

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.utils.ByteArray;

	public class AsyncTest extends TestBase
	{
		private var _data:ByteArray;
		private var _square:Sprite;
		private var _phase:uint;
		private var _bitmap:Bitmap;

		private const USE_COMPRESSION:Boolean = true;
		private const USE_ASYNC:Boolean = true;

		private const FILE_NAME:String = "fileWrittenByAne.jpg";
		
		public function AsyncTest() {
			super();

			initFlowAnimation();

			stage.addEventListener( MouseEvent.CLICK, onStageClick );
		}

		private function onStageClick( event:MouseEvent ):void {

			switch( _phase ) {

				case 0: {
					simulateData();
					_phase = 1;
					break;
				}

				case 1: {
					writeData();
					_phase = 2;
					break;
				}

				case 2: {
					readData();
					_phase = 3;
					break;
				}

				case 3: {
					disposeData();
					_phase = 4;
					break;
				}

			}

		}

		private function simulateData():void {

			trace( this, "simulating data..." );

			// Produce an image.
			var bmd:BitmapData = new BitmapData( 2048, 1536, true, 0x00000000 );
			bmd.perlinNoise( 50, 50, 8, 1, false, true, 7, false );

			// Bmd -> ByteArray.
			_data = new ByteArray();
			bmd.copyPixelsToByteArray( bmd.rect, _data );
			bmd.dispose();
		}

		private function writeData():void {

			trace( this, "writing data..." );

			// Write.
			if( USE_ASYNC ) {
				log( "writing async..." );
				if( USE_COMPRESSION ) _extension.writeWithCompressionAsync( _data, FILE_NAME, onAsyncWriteComplete );
				else _extension.writeAsync( _data, FILE_NAME, onAsyncWriteComplete );
			}
			else {
				log( "writing sync..." );
				if( USE_COMPRESSION ) _extension.writeWithCompression( _data, FILE_NAME );
				else _extension.write( _data, FILE_NAME );
				_data.length = 0;
				_data = null;
				System.gc();
				log( "done writing sync." );
			}
		}

		private function onAsyncWriteComplete():void {
			_data.length = 0;
			_data = null;
			System.gc();
			log("done writing async.");
		}

		private function readData():void {

			// NOTE: ANE does not read async yet.

			_data = new ByteArray();

			log( "reading sync..." );
			if( USE_COMPRESSION ) _extension.readWithDeCompression( _data, FILE_NAME );
			else _extension.read( _data, FILE_NAME );
			dataToImage();
			_data.length = 0;
			_data = null;
			System.gc();
			log( "done reading sync." );

		}

		private function dataToImage():void {

			var bmd:BitmapData = new BitmapData( 2048, 1536, true, 0x00000000 );
			bmd.setPixels( bmd.rect, _data );

			_bitmap = new Bitmap( bmd );
			_bitmap.y = 300;
			addChild( _bitmap );
		}

		private function disposeData():void {

			removeChild( _bitmap );
			_bitmap.bitmapData.dispose();
			_bitmap = null;

		}

		private function initFlowAnimation():void {

			trace( this, "starting animation..." );

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
