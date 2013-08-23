package net.psykosoft.io
{
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.utils.ByteArray;

	public class IOExtension
	{
		private var _context:ExtensionContext;
		private var _onInitializedCallback:Function;

		public function IOExtension() {
			super();

			// Create context.
			_context = ExtensionContext.createExtensionContext( "net.psykosoft.io", null );

			// Listen to all status events.
			_context.addEventListener( StatusEvent.STATUS, onContextStatusUpdate );
		}

		// -----------------------
		// Native interface.
		// -----------------------

		public function initialize( onComplete:Function ):void {
			_context.call( "initialize" );
			_onInitializedCallback = onComplete;
			_onInitializedCallback();
			_onInitializedCallback = null;
		}

		public function write( bytes:ByteArray, fileName:String ):void {
			_context.call( "write", bytes, fileName );
		}

		public function writeWithCompression( bytes:ByteArray, fileName:String ):void {
			_context.call( "writeWithCompression", bytes, fileName );
		}

		public function readWithDeCompression( bytes:ByteArray, fileName:String ):void {
			_context.call( "readWithDeCompression", bytes, fileName );
		}

		// -----------------------
		// Internal.
		// -----------------------

		private function onContextStatusUpdate( event:StatusEvent ):void {
//			dispatchEvent( new TestExtensionEvent( event.code, event.level ) );
		}
	}
}