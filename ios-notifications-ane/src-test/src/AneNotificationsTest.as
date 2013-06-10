package
{

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import net.psykosoft.notifications.NotificationsExtension;
	import net.psykosoft.notifications.events.NotificationExtensionEvent;

	public class AneNotificationsTest extends Sprite
	{
		private var _notificationsExtension:NotificationsExtension;

		public function AneNotificationsTest() {
			super();

			_notificationsExtension = new NotificationsExtension();
			_notificationsExtension.addEventListener( NotificationExtensionEvent.RECEIVED_MEMORY_WARNING, onMemoryWarning );
			_notificationsExtension.initialize();

			stage.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
		}

		private function onMouseDown( event:MouseEvent ):void {
			_notificationsExtension.simulateMemoryWarning();
		}

		private function onMemoryWarning( event:NotificationExtensionEvent ):void {
			trace( this, "AS3 knows about memory warning." );
		}
	}
}
