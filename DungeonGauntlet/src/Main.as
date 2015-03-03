package
{
	import com.gauntlet.states.TitleState;
	import org.flixel.*;
	[Frame(factoryClass="com.gauntlet.loading.Preloader")]
	
	/**
	 * Main class.
	 * 
	 * @author Casey Sliger
	 */
	public class Main extends FlxGame 
	{
		/**
		 * Entry point.
		 */
		public function Main() 
		{
			super(1024, 768, TitleState, 1, 30, 30);
		}
		
	}
	
}