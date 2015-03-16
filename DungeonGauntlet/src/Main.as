package
{
	import com.gauntlet.states.TitleState;
	import org.flixel.*;
	import treefortress.sound.SoundAS;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	[Frame(factoryClass="com.gauntlet.loading.Preloader")]
	
	/**
	 * Main class.
	 * 
	 * @author Casey Sliger
	 */
	public class Main extends FlxGame 
	{
		var swf:MovieClip;
		/**
		 * Entry point.
		 */
		public function Main() 
		{
			super(1024, 768, TitleState, 1, 30, 30);
			
			var l:Loader = new Loader();
            l.contentLoaderInfo.addEventListener(Event.COMPLETE, swfLoaded);
            l.load( new URLRequest("DungeonGauntletMusic.swf") );
			
			
			SoundAS.loadSound("../embeded_resources/Music/Boss.mp3", "Boss", 100);
			SoundAS.loadSound("../embeded_resources/Music/Defeat.mp3", "Defeat", 100);
			SoundAS.loadSound("../embeded_resources/Music/Play.mp3", "Play", 100);
			SoundAS.loadSound("../embeded_resources/Music/Title.mp3", "Title", 100);
			SoundAS.loadSound("../embeded_resources/Music/Victory.mp3", "Victory", 100);
			
			
		}
		    
        
		
        private function swfLoaded(e:Event):void
        {
            swf = e.target.content as MovieClip;
            addChild(swf);

            swf.playSound();

        }
	}
	
}