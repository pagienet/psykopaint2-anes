package net.psykosoft.photos
{

	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.geom.Point;

	import net.psykosoft.photos.data.SheetVO;
	import net.psykosoft.photos.events.UserPhotosExtensionEvent;

	public class UserPhotosExtension extends EventDispatcher
	{
		private var _context:ExtensionContext;

		public function UserPhotosExtension() {
			super();

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
		 * The extension will trigger a UserPhotosExtensionEvent.USER_LIBRARY_READY when done.
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

		/*
		* Returns the dimensions of a full image at the specified index.
		* */
		public function getFullImageDimensionsAtIndex( index:uint ):Point {
			var stringReply:String = _context.call( "getFullImageDimensionsAtIndex", index ) as String;
			var dump:Array = stringReply.split( "x" );
			return new Point(
					Number( dump[ 0 ] ),
					Number( dump[ 1 ] )
			);
		}

		/*
		* Retrieves a single thumbnail at the specified index.
		* */
		// TODO: isolate thumbSize?
 		public function getThumbnailAtIndex( index:uint, thumbSize:uint ):BitmapData {
			var bmd:BitmapData = new BitmapData( thumbSize, thumbSize, false, 0xFF0000 );
			_context.call( "getThumbnailAtIndex", index, bmd );
			return bmd;
		}

		/*
		* Returns the full image at the specified index.
		* */
		public function getFullImageAtIndex( index:uint ):BitmapData {
			var dimensions:Point = getFullImageDimensionsAtIndex( index );
			var bmd:BitmapData = new BitmapData( dimensions.x, dimensions.y, false, 0xFF0000 );
			_context.call( "getFullImageAtIndex", index, bmd );
			return bmd;
		}

		// -----------------------
		// AS3 only interface.
		// -----------------------

		/*
		* Given a range of thumbnail indices, produces a sprite sheet containing them.
		* The method identifies the best sheet size for the number of requested items.
		* */
		public function getThumbnailSheetFromIndexToIndex( fromIndex:uint, toIndex:uint, thumbSize:uint ):SheetVO {

			// Does the request make sense?
			var totalItemsInLibrary:uint = getNumberOfLibraryItems();
			if( toIndex > totalItemsInLibrary - 1 ) {
				throw new Error( this, "You have requested a top index that exceeds the number of items in the library." );
			}

			// Initialize data holder.
			var vo:SheetVO = new SheetVO();
			vo.baseItemIndex = fromIndex;
			vo.thumbSize = thumbSize;
			vo.numberOfItems = toIndex - fromIndex;

			// Evaluate best sheet size.
			var sqr:uint = Math.ceil( Math.sqrt( vo.numberOfItems ) );
			vo.sheetSize = sqr * thumbSize;
			vo.sheetSize = getBestPowerOf2( vo.sheetSize ); // Contain within power of 2 images.

			// Too many items requested?
			if( vo.sheetSize > 2048 ) {
				throw new Error( this, "You have requested too many items for a single sprite sheet." );
			}

			// Produce the sheet.
			vo.bmd = getThumbnailSheet( fromIndex, toIndex, thumbSize, vo.sheetSize );

			return vo;
		}

		// -----------------------
		// Internal.
		// -----------------------

		private function onContextStatusUpdate( event:StatusEvent ):void {
			dispatchEvent( new UserPhotosExtensionEvent( event.code, event.level ) );
		}

		private function getBestPowerOf2( value:uint ):Number {
			var p:uint = 1;
			while( p < value ) p <<= 1;
			return p;
		}

		/*
		* Produces a sprite sheet containing thumbnails from the specified index, to the specified index.
		* The size of the sheet needs to be calculated before calling this method.
		* */
		private function getThumbnailSheet( fromIndex:uint, toIndex:uint, thumbSize:uint, sheetSize:uint ):BitmapData {
			var bmd:BitmapData = new BitmapData( sheetSize, sheetSize, false, 0x00FF00 );
//			trace( this, "getThumbnailSheet - from: " + fromIndex + ", to: " + toIndex + ", thumb size: " + thumbSize + ", sheet size: " + sheetSize );
			_context.call( "getThumbnailSheetFromIndexToIndex", fromIndex, toIndex, thumbSize, sheetSize, bmd );
			return bmd;
		}
	}
}