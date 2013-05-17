package net.psykosoft.gyroscope.events
{

	import flash.events.Event;

	public class GyroscopeExtensionEvent extends Event
	{
		public static const READING:String = "gyroscope/reading";

		public var data:*;

		public function GyroscopeExtensionEvent( type:String, data:*, bubble:Boolean = false, cancelable:Boolean = false ) {
			this.data = data;
			super( type, bubble, cancelable );
		}
	}
}
