package
{

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.setTimeout;

	import net.psykosoft.photos.UserPhotosExtension;

	public class AneUserPhotosTest extends Sprite
	{
		private var _extension:UserPhotosExtension;
		private var _numItems:uint;
		private var _currentItemIndex:uint;
		private var _spinner:Sprite;

		public function AneUserPhotosTest() {
			super();

			// Initialize stage.
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.stageWidth = 2048;
			stage.stageHeight = 1536;

			// Init spinner and enterframe.
			_spinner = new Sprite();
			_spinner.x = 100;
			_spinner.y = 100;
			addChild( _spinner );
			_spinner.graphics.beginFill( 0xFF0000, 1.0 );
			_spinner.graphics.drawRect( 0, 0, 100, 100 );
			_spinner.graphics.endFill();
			addEventListener( Event.ENTER_FRAME, enterframeHandler );

			// Initialize extension...
			_extension = new UserPhotosExtension();
			_extension.libraryReadySignal.addOnce( onUserLibraryReady );
			_extension.initialize();
		}

		private function onUserLibraryReady():void {

			// Retrieve number of items.
			_numItems = _extension.getNumberOfLibraryItems();
			trace( this, "User photos extension initialized, num items: " + _numItems + "." );

			// Pick a test.
			testMultipleThumbs();
		}

		private function testMultipleThumbs():void {

			// Trace number of items and thumb dimensions.
			for( var i:uint; i < _numItems; ++i ) {
				var size:Point = _extension.getThumbDimensionsAtIndex( i );
				trace( "thumb " + i + " size: " + size.x + "x" + size.y );
			}

			// Pick a thumb on stage click.
			stage.addEventListener( MouseEvent.CLICK, onClick );
		}

		private function onClick( event:MouseEvent ):void {
			getNextItem();
		}

		private function getNextItem():void {
			if( _currentItemIndex < _numItems ) {

				trace( this, "getting thumbnail..." );
				var size:Point = _extension.getThumbDimensionsAtIndex( _currentItemIndex );
				trace( "thumb " + _currentItemIndex + " size: " + size.x + "x" + size.y );

				var optionalBmd:BitmapData = new BitmapData( size.x, size.y, false, 0 );
				var bitmap:Bitmap = new Bitmap( _extension.getThumbnailAtIndex( _currentItemIndex, optionalBmd ) );
				bitmap.x = rand( 0, stage.stageWidth - bitmap.width );
				bitmap.y = rand( 0, stage.stageHeight - bitmap.height );
				addChild( bitmap );
			}
			_currentItemIndex++;
		}

		private function rand(min:Number, max:Number):Number {
		    return (max - min)*Math.random() + min;
		}

		private function enterframeHandler( event:Event ):void {
			_spinner.rotation += 1;
		}
	}
}
