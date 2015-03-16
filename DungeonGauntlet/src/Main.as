package
{
	import com.gauntlet.states.TitleState;
	import org.flixel.*;
	import treefortress.sound.SoundAS;
	
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
			
			SoundAS.addSound("Boss", new MusicBoss());
			SoundAS.addSound("Defeat", new MusicDefeat());
			SoundAS.addSound("Play", new MusicPlay());
			SoundAS.addSound("Title", new MusicTitle());
			SoundAS.addSound("Victory", new MusicVictory());
		}
	}
	
}