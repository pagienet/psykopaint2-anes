package net.psykosoft.test.events
{
	import flash.events.Event;

	public class TestExtensionEvent extends Event
	{
		public static const XXX:String = "xxx";

		public var data:*;

		public function TestExtensionEvent( type:String, data:*, bubble:Boolean = false, cancelable:Boolean = false ) {
			this.data = data;
			super( type, bubble, cancelable );
		}
	}
}
