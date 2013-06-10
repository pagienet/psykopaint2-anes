package net.psykosoft.wacom
{

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;

	import net.psykosoft.wacom.events.WacomExtensionEvent;

	public class WacomExtension extends EventDispatcher
	{
		private var _context:ExtensionContext;

		public function WacomExtension() {
			super();

			// Create context.
			_context = ExtensionContext.createExtensionContext( "net.psykosoft.wacom", null );

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
			dispatchEvent( new WacomExtensionEvent( event.code, Number( event.level ) ) );
		}
	}
}