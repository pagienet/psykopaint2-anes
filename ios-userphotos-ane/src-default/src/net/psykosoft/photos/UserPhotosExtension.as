package net.psykosoft.photos
{

	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.events.EventDispatcher;

	import net.psykosoft.photos.data.SheetVO;

	public class UserPhotosExtension extends EventDispatcher
	{
		public function UserPhotosExtension() {
			super();
		}

		public function initialize():void {
			
		}

		public function releaseLibraryItems():void {
			
		}

		public function getNumberOfLibraryItems():Number {
			return 0;	
		}

		public function getFullImageDimensionsAtIndex( index:uint ):Point {
			return new Point();	
		}

 		public function getThumbnailAtIndex( index:uint, thumbSize:uint ):BitmapData {
			return new BitmapData( 32, 32, false, 0 );	
		}

		public function getFullImageAtIndex( index:uint ):BitmapData {
			return new BitmapData( 32, 32, false, 0 );		
		}

		public function getThumbnailSheetFromIndexToIndex( fromIndex:uint, toIndex:uint, thumbSize:uint ):SheetVO {
			return new SheetVO();
		}
	}
}