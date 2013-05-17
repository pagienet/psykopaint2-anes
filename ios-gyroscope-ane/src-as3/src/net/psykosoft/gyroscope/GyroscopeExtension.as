package net.psykosoft.gyroscope
{

	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;

	import net.psykosoft.gyroscope.events.GyroscopeExtensionEvent;

	public class GyroscopeExtension extends EventDispatcher
	{
		private var _context:ExtensionContext;

		public function GyroscopeExtension() {
			super();

			// Create context.
			_context = ExtensionContext.createExtensionContext( "net.psykosoft.gyroscope", null );

			// Listen to all status events.
			_context.addEventListener( StatusEvent.STATUS, onContextStatusUpdate );
		}

		// TODO: dispose method with context finalizer in xcode ( remember to kill retain queue )

		// -----------------------
		// Native interface.
		// -----------------------

		public function initialize():void {
			_context.call( "initialize" );
		}

		public function startReadings():void {
			_context.call( "startReadings" );
		}

		public function stopReadings():void {
			_context.call( "stopReadings" );
		}

		// -----------------------
		// Internal.
		// -----------------------

		private function onContextStatusUpdate( event:StatusEvent ):void {
			if( event.code == GyroscopeExtensionEvent.READING ) {
				var data:Array = event.level.split( "&" );
				dispatchEvent( new GyroscopeExtensionEvent( event.code,
						Number( data[ 0 ] ), Number( data[ 1 ] ), Number( data[ 2 ] ),
						Number( data[ 3 ] ), Number( data[ 4 ] ), Number( data[ 5 ] )
				) );
			}
		}
	}
}
