package net.psykosoft.gyroscope
{

	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	import net.psykosoft.gyroscope.events.GyroscopeExtensionEvent;

	public class GyroscopeExtension extends EventDispatcher
	{
		private var _context:ExtensionContext;
		private var _rotationRate:Vector3D;
		private var _rotationMatrix:Matrix3D;
		private var _rotationMatrixRaw:Vector.<Number>;

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
			_rotationRate = new Vector3D();
			_rotationMatrix = new Matrix3D();
			_rotationMatrixRaw = new Vector.<Number>( 16 );
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
				_rotationRate.x = data[ 0 ];
				_rotationRate.y = data[ 1 ];
				_rotationRate.z = data[ 2 ];
				_rotationMatrixRaw[ 0  ] = Number( data[ 3  ] );
				_rotationMatrixRaw[ 1  ] = Number( data[ 4  ] );
				_rotationMatrixRaw[ 2  ] = Number( data[ 5  ] );
				_rotationMatrixRaw[ 4  ] = Number( data[ 6  ] );
				_rotationMatrixRaw[ 5  ] = Number( data[ 7  ] );
				_rotationMatrixRaw[ 6  ] = Number( data[ 8  ] );
				_rotationMatrixRaw[ 8  ] = Number( data[ 9  ] );
				_rotationMatrixRaw[ 9  ] = Number( data[ 10 ] );
				_rotationMatrixRaw[ 10 ] = Number( data[ 11 ] );
				_rotationMatrix.copyRawDataFrom( _rotationMatrixRaw );
				dispatchEvent( new GyroscopeExtensionEvent( event.code,
						_rotationRate,
						_rotationMatrix
				) );
			}
		}
	}
}
