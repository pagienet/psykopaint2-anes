package net.psykosoft.gyroscope.events
{

	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	public class GyroscopeExtensionEvent extends Event
	{
		public static const READING:String = "gyroscope/reading";

		public var rotationRate:Vector3D;
		public var rotationMatrix:Matrix3D;

		public function GyroscopeExtensionEvent(
				type:String,
				rotationRate:Vector3D,
				rotationMatrix:Matrix3D,
				bubble:Boolean = false, cancelable:Boolean = false ) {
			this.rotationRate = rotationRate;
			this.rotationMatrix = rotationMatrix;
			super( type, bubble, cancelable );
		}
	}
}
