package net.psykosoft.gyroscope.events
{

	import flash.events.Event;

	public class GyroscopeExtensionEvent extends Event
	{
		public static const READING:String = "gyroscope/reading";

		public var rotationRateX:Number;
		public var rotationRateY:Number;
		public var rotationRateZ:Number;
		public var roll:Number;
		public var pitch:Number;
		public var yaw:Number;

		public function GyroscopeExtensionEvent(
				type:String,
				rotationRateX:Number, rotationRateY:Number, rotationRateZ:Number,
				roll:Number, pitch:Number, yaw:Number,
				bubble:Boolean = false, cancelable:Boolean = false ) {
			this.rotationRateX = rotationRateX;
			this.rotationRateY = rotationRateY;
			this.rotationRateZ = rotationRateZ;
			this.roll = roll;
			this.pitch = pitch;
			this.yaw = yaw;
			super( type, bubble, cancelable );
		}
	}
}
