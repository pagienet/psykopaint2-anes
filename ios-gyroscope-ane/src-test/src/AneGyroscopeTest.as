package
{
	import flash.display.Sprite;
	import flash.geom.Matrix3D;

	import net.psykosoft.gyroscope.GyroscopeExtension;
	import net.psykosoft.gyroscope.events.GyroscopeExtensionEvent;

	public class AneGyroscopeTest extends Sprite
	{
		private var _extension:GyroscopeExtension;

		public function AneGyroscopeTest() {
			super();

			trace( this, "Gyroscope test started..." );

			_extension = new GyroscopeExtension();
			_extension.addEventListener( GyroscopeExtensionEvent.READING, onGyroscopeReading );
			_extension.initialize();
			_extension.startReadings();
//			_extension.stopReadings();
		}

		private function onGyroscopeReading( event:GyroscopeExtensionEvent ):void {

			trace( this, "Gyroscope reading ------------------------------------" );
			trace( "rotation rate: " + event.rotationRate );
			trace( "rotation matrix: " + traceMatrix3d( event.rotationMatrix ) );
		}

		private function traceMatrix3d( matrix:Matrix3D ):String {
			return "matrix3d: " + String( matrix.rawData );
		}
	}
}
