package
{
	import flash.display.Sprite;

	import net.psykosoft.test.TestExtension;

	public class TestAne extends Sprite
	{
		public function TestAne() {
			super();

			var testExtension:TestExtension = new TestExtension();
			testExtension.initialize();
		}
	}
}
