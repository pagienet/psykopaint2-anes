package net.psykosoft.io
{
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.utils.ByteArray;

	public class IOExtension
	{
		private var _context:ExtensionContext;

		public function IOExtension() {
			super();

			// Create context.
			_context = ExtensionContext.createExtensionContext( "net.psykosoft.io", null );

			// Listen to all status events.
//			_context.addEventListener( StatusEvent.STATUS, onContextStatusUpdate );
		}

		// -----------------------
		// Native interface.
		// -----------------------

		public function write( bytes:ByteArray, fileName:String ):void {
			_context.call( "write", bytes, fileName );
		}

		public function read( bytes:ByteArray, fileName:String ):void {
			_context.call( "read", bytes, fileName );
		}

		public function writeWithCompression( bytes:ByteArray, fileName:String ):void {
			_context.call( "writeWithCompression", bytes, fileName );
		}

		public function readWithDeCompression( bytes:ByteArray, fileName:String ):void {
			_context.call( "readWithDeCompression", bytes, fileName );
		}

		public function mergeRgbaPerByte( bytes:ByteArray ):void {
			_context.call( "mergeRgbaPerByte", bytes );
		}

		public function mergeRgbaPerInt( bytes:ByteArray ):void {
			_context.call( "mergeRgbaPerInt", bytes );
		}

		// -----------------------
		// Internal.
		// -----------------------

		private function onContextStatusUpdate( event:StatusEvent ):void {
//			dispatchEvent( new TestExtensionEvent( event.code, event.level ) );
		}
	}
}
