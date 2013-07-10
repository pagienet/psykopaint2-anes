package net.psykosoft.test
{
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;

	import net.psykosoft.test.events.TestExtensionEvent;

	public class TestExtension extends EventDispatcher
	{
		private var _context:ExtensionContext;

		public function TestExtension() {
			super();

			// Create context.
			_context = ExtensionContext.createExtensionContext( "net.psykosoft.test", null );

			// Listen to all status events.
			_context.addEventListener( StatusEvent.STATUS, onContextStatusUpdate );
		}

		// -----------------------
		// Native interface.
		// -----------------------

		public function initialize():void {
			_context.call( "initialize" );
		}

		// -----------------------
		// Internal.
		// -----------------------

		private function onContextStatusUpdate( event:StatusEvent ):void {
			dispatchEvent( new TestExtensionEvent( event.code, event.level ) );
		}
	}
}
