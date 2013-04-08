package net.psykosoft.notifications
{

	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;

	import net.psykosoft.notifications.events.NotificationExtensionEvent;

	public class NotificationsExtension extends EventDispatcher
	{
		private var _context:ExtensionContext;

		public function NotificationsExtension() {
			super();

			// Create context.
			_context = ExtensionContext.createExtensionContext( "net.psykosoft.notifications", null );

			// Listen to all status events.
			_context.addEventListener( StatusEvent.STATUS, onContextStatusUpdate );
		}

		// -----------------------
		// Native interface.
		// -----------------------

		public function initialize():void {
			_context.call( "initialize" );
		}

		public function simulateMemoryWarning():void {
			_context.call( "simulateMemoryWarning" );

			// Uncomment to bypass the native side on these simulations.
//			dispatchEvent( new NotificationExtensionEvent( NotificationExtensionEvent.RECEIVED_MEMORY_WARNING, "" ) );
		}

		// -----------------------
		// Internal.
		// -----------------------

		private function onContextStatusUpdate( event:StatusEvent ):void {
			dispatchEvent( new NotificationExtensionEvent( event.code, event.level ) );
		}
	}
}
