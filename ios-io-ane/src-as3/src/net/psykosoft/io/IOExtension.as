package net.psykosoft.io
{
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.utils.ByteArray;

	public class IOExtension
	{
		private var _context:ExtensionContext;
		private var _asyncWriteCallback:Function;
		private var _asyncWriteWithCompressionCallback:Function;

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

		public function writeAsync( bytes:ByteArray, fileName:String, callback:Function ):void {
			_asyncWriteCallback = callback;
			_context.call( "writeAsync", bytes, fileName );
		}

		public function writeWithCompressionAsync( bytes:ByteArray, fileName:String, callback:Function ):void {
			_asyncWriteWithCompressionCallback = callback;
			_context.call( "writeWithCompressionAsync", bytes, fileName );
		}

		// -----------------------
		// Internal.
		// -----------------------

		private function onContextStatusUpdate( event:StatusEvent ):void {
			switch( event.code ) {
				case "io/ane/asyncWriteComplete": {
					if( _asyncWriteCallback ) {
						_asyncWriteCallback();
						_asyncWriteCallback = null;
					}
					break;
				}
				case "io/ane/asyncWriteAndCompressComplete": {
					if( _asyncWriteWithCompressionCallback ) {
						_asyncWriteWithCompressionCallback();
						_asyncWriteWithCompressionCallback = null;
					}
					break;
				}
			}
		}
	}
}
