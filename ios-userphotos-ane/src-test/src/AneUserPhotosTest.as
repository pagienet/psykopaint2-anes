package
{

	import flash.display.Sprite;

	import net.psykosoft.photos.UserPhotosExtension;
	import net.psykosoft.photos.events.UserPhotosExtensionEvent;

	public class AneUserPhotosTest extends Sprite
	{
		private var _extension:UserPhotosExtension;

		public function AneUserPhotosTest() {
			super();

			_extension = new UserPhotosExtension();
			_extension.addEventListener( UserPhotosExtensionEvent.USER_LIBRARY_READY, onUserLibraryReady );
			_extension.initialize();
		}

		private function onUserLibraryReady( event:UserPhotosExtensionEvent ):void {
			trace( this, "extension initialized." );
			_extension.removeEventListener( UserPhotosExtensionEvent.USER_LIBRARY_READY, onUserLibraryReady );
		}
	}
}
