package net.psykosoft.photos.events
{

	import flash.events.Event;

	public class UserPhotosExtensionEvent extends Event
	{
		public static const USER_LIBRARY_READY:String = "user/library/items/retrieved";
		public static const SPRITE_SHEET_READY:String = "sprite/sheet/ready";

		public var data:*;

		public function UserPhotosExtensionEvent( type:String, data:*, bubble:Boolean = false, cancelable:Boolean = false ) {
			this.data = data;
			super( type, bubble, cancelable );
		}
	}
}
