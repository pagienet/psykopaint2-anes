package
{
	import flash.display.Sprite;

	import net.psykosoft.wacom.WacomExtension;
	import net.psykosoft.wacom.events.WacomExtensionEvent;

	public class AneWacomTest extends Sprite
	{
		private var _extension:WacomExtension;

		public function AneWacomTest() {
			super();

			trace( this, "AneWacomTest" );

			_extension = new WacomExtension();
			_extension.addEventListener( WacomExtensionEvent.DEVICE_DISCOVERED, onDeviceDiscovered );
			_extension.addEventListener( WacomExtensionEvent.BATTERY_LEVEL_CHANGED, onBatteryLevelChanged );
			_extension.addEventListener( WacomExtensionEvent.BUTTON_1_PRESSED, onButton1Pressed );
			_extension.addEventListener( WacomExtensionEvent.BUTTON_2_PRESSED, onButton2Pressed );
			_extension.addEventListener( WacomExtensionEvent.BUTTON_1_RELEASED, onButton1Released );
			_extension.addEventListener( WacomExtensionEvent.BUTTON_2_RELEASED, onButton2Released );
			_extension.addEventListener( WacomExtensionEvent.PRESSURE_CHANGED, onPressureChanged );
			_extension.initialize();
		}

		private function onBatteryLevelChanged( event:WacomExtensionEvent ):void {
			trace( this, "Pen battery level changed: " + event.data );
		}

		private function onButton1Pressed( event:WacomExtensionEvent ):void {
			trace( this, "Button 1 pressed." );
		}

		private function onButton2Pressed( event:WacomExtensionEvent ):void {
			trace( this, "Button 2 pressed." );
		}

		private function onButton1Released( event:WacomExtensionEvent ):void {
			trace( this, "Button 1 released." );
		}

		private function onButton2Released( event:WacomExtensionEvent ):void {
			trace( this, "Button 2 released." );
		}

		private function onPressureChanged( event:WacomExtensionEvent ):void {
			trace( this, "Pen pressure changed: " + event.data );
		}

		private function onDeviceDiscovered( event:WacomExtensionEvent ):void {
			trace( this, "Device discovered." );
		}
	}
}
