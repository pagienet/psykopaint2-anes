package net.psykosoft.photos
{

	import flash.display.BitmapData;
	import flash.geom.Point;

	public class UserPhotosExtension
	{
		public function UserPhotosExtension() {
			super();
		}

		public function initialize( callback:Function ):void {
			
		}

		public function releaseLibraryItems():void {
			
		}

		public function getThumbDimensionsAtIndex():Point {
			return new Point();
		}

		public function getNumberOfLibraryItems():Number {
			return 0;	
		}

		public function getFullImageDimensionsAtIndex( index:uint ):Point {
			return new Point();	
		}

 		public function getThumbnailAtIndex( index:uint ):BitmapData {
			return new BitmapData( 32, 32, false, 0 );	
		}

		public function getFullImageAtIndex( index:uint ):BitmapData {
			return new BitmapData( 32, 32, false, 0 );		
		}
	}
}