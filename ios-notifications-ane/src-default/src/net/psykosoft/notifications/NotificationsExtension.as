package net.psykosoft.notifications
{

	import flash.events.EventDispatcher;
	import net.psykosoft.notifications.events.NotificationExtensionEvent;

	public class NotificationsExtension extends EventDispatcher
	{
		public function NotificationsExtension() {
			super();
		}

		// -----------------------
		// Native interface.
		// -----------------------

		public function initialize():void {
		}

		public function simulateMemoryWarning():void {
			dispatchEvent( new NotificationExtensionEvent( NotificationExtensionEvent.RECEIVED_MEMORY_WARNING, "" ) );
		}
	}
}
