package net.psykosoft.wacom.events
{
	import flash.events.Event;

	public class WacomExtensionEvent extends Event
	{
		public static const DEVICE_DISCOVERED:String = "wacom/device_discovered";
		public static const BATTERY_LEVEL_CHANGED:String = "wacom/battery_level_changed";
		public static const PRESSURE_CHANGED:String = "wacom/pressure_changed";
		public static const BUTTON_1_PRESSED:String = "wacom/button_1_pressed";
		public static const BUTTON_2_PRESSED:String = "wacom/button_2_pressed";
		public static const BUTTON_1_RELEASED:String = "wacom/button_1_released";
		public static const BUTTON_2_RELEASED:String = "wacom/button_2_released";

		public function WacomExtensionEvent( type:String, data:Number, bubble:Boolean = false, cancelable:Boolean = false ) {
			super( type, bubble, cancelable );
		}
	}
}
