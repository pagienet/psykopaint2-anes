package net.psykosoft.notifications.events
{

	import flash.events.Event;

	public class NotificationExtensionEvent extends Event
	{
		public static const RECEIVED_MEMORY_WARNING:String = "received/memory/warning";

		public var data:*;

		public function NotificationExtensionEvent( type:String, data:*, bubble:Boolean = false, cancelable:Boolean = false ) {
			this.data = data;
			super( type, bubble, cancelable );
		}
	}
}
