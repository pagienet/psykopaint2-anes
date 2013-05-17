package net.psykosoft.gyroscope
{
	import flash.events.EventDispatcher;

	public class GyroscopeExtension extends EventDispatcher
	{
		public function GyroscopeExtension() {
			super();
		}

		// -----------------------
		// Native interface.
		// -----------------------

		public function initialize():void {
		}

		public function startReadings():void {
		}

		public function stopReadings():void {
		}
	}
}
