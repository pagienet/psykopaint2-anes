package net.psykosoft.photos
{

	import flash.display.BitmapData;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.geom.Point;

	import org.osflash.signals.Signal;

	public class UserPhotosExtension
	{
		private var _context:ExtensionContext;
		private var _point:Point;

		public var libraryReadySignal:Signal;

		public function UserPhotosExtension() {
			super();

			// Init vars.
			libraryReadySignal = new Signal();
			_point = new Point();

			// Create context.
			_context = ExtensionContext.createExtensionContext( "net.psykosoft.photos", null );

			// Listen to all status events.
			_context.addEventListener( StatusEvent.STATUS, onContextStatusUpdate );
		}

		// -----------------------
		// Native interface.
		// -----------------------

		/*
		 * Must be called to initialize the extension.
		 * Call this method so that the native part of the ANE retrieves all the user's assets
		 * and stores it in its own memory.
		 * The extension will trigger libraryReadySignal when ready.
		 * After that, call any of the methods below.
		 */
		public function initialize():void {
			_context.call( "initialize" );
		}

		/*
		 * Releases memory on the native side.
		 * If this method is called, initializeUserLibrary() will have to be called again.
		 * */
		public function releaseLibraryItems():void {
			_context.call( "releaseLibraryItems" );
		}

		/*
		* Returns the number of items in the user's library.
		* */
		public function getNumberOfLibraryItems():Number {
			return _context.call( "getNumberOfLibraryItems" ) as Number;
		}

		public function getThumbDimensionsAtIndex( index:uint ):Point {
			var stringReply:String = _context.call( "getThumbDimensionsAtIndex", index ) as String;
			var dump:Array = stringReply.split( "x" );
			_point.x = dump[ 0 ];
			_point.y = dump[ 1 ];
			return _point;
		}

		/*
		* Returns the dimensions of a full image at the specified index.
		* */
		public function getFullImageDimensionsAtIndex( index:uint ):Point {
			var stringReply:String = _context.call( "getFullImageDimensionsAtIndex", index ) as String;
			var dump:Array = stringReply.split( "x" );
			_point.x = dump[ 0 ];
			_point.y = dump[ 1 ];
			return _point;
		}

		/*
		* Retrieves a single thumbnail at the specified index.
		* */
 		public function getThumbnailAtIndex( index:uint, bmd:BitmapData = null ):BitmapData {
			var dims:Point = getThumbDimensionsAtIndex( index );
			bmd ||= new BitmapData( dims.x, dims.y, false, 0x000000 );
			_context.call( "getThumbnailAtIndex", index, bmd );
			return bmd;
		}

		/*
		* Returns the full image at the specified index.
		* */
		public function getFullImageAtIndex( index:uint, bmd:BitmapData = null ):BitmapData {
			var dims:Point = getFullImageDimensionsAtIndex( index );
			bmd ||= new BitmapData( dims.x, dims.y, false, 0x000000 );
			_context.call( "getFullImageAtIndex", index, bmd );
			return bmd;
		}

		private function onContextStatusUpdate( event:StatusEvent ):void {
			switch( event.code ) {
				case "user/library/items/retrieved": {
					libraryReadySignal.dispatch();
					break;
				}
			}
		}
	}
}