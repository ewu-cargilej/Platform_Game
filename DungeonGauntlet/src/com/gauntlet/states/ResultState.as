package com.gauntlet.states
{
	import com.gauntlet.states.PlayState;
	import org.flixel.*;

	/**
	 * Show results and high scores.
	 * 
	 * @author Casey Sliger
	 */
	public class ResultState extends FlxState
	{
		[Embed(source = '../../../../embeded_resources/Results_Screen/ResultsScreen_HeroDefeated_Bones.png')]private static var ImgBones:Class;
		[Embed(source = '../../../../embeded_resources/Results_Screen/ResultsScreen_HeroVictory_Treasure.png')]private static var ImgTreasure:Class;
		[Embed(source = '../../../../embeded_resources/Results_Screen/ResultsScreen_HeroDefeated_Text.png')]private static var ImgDefeat:Class;
		[Embed(source = '../../../../embeded_resources/Results_Screen/ResultsScreen_HeroVictory_Text.png')]private static var ImgVictory:Class;
		[Embed(source = '../../../../embeded_resources/Results_Screen/ResultsScreen_PlayAgain_Button.png')]private static var ImgPlayAgain:Class;
		[Embed(source = '../../../../embeded_resources/Results_Screen/ResultsScreen_TopScores_Text.png')]private static var ImgTopScores:Class;
		[Embed(source = '../../../../embeded_resources/Game_Screen/Level_Building/GameScreen_Background.png')]private static var ImgBackground:Class;
		
		[Embed(source = '../../../../embeded_resources/Music/Victory.mp3')]private static var MusicVictory:Class;
		[Embed(source = '../../../../embeded_resources/Music/Defeat.mp3')]private static var MusicDefeat:Class;
		
		/** Whether or not the player won or lost. */
		protected var	_bWin	:Boolean;
		
		/**
		 * Constructor
		 * 
		 * @param $win	whether to set up win or lose screen
		 */
		public function ResultState($win:Boolean=false)
		{
			this._bWin = $win;
		}
		
		/**
		 * Set up the state.
		 */
		override public function create():void
		{
			
			
			var tmpSprite:FlxSprite;
			tmpSprite = new FlxSprite(0, 0, ImgBackground);
			add(tmpSprite);
			
			tmpSprite = new FlxSprite(FlxG.width / 2 - 137, FlxG.height - 150, ImgPlayAgain);
			add(tmpSprite);
			
			if (this._bWin)
			{
				FlxG.playMusic(MusicVictory, .8);
				
				tmpSprite = new FlxSprite(0, 0, ImgTreasure);
				add(tmpSprite);
				
				tmpSprite = new FlxSprite(0, 0, ImgVictory);
				add(tmpSprite);
			}
			else
			{
				FlxG.playMusic(MusicDefeat, .7);
				
				tmpSprite = new FlxSprite(0, 0, ImgBones);
				add(tmpSprite);
				
				tmpSprite = new FlxSprite(0, 0, ImgDefeat);
				add(tmpSprite);
			}
			
			FlxG.mouse.show();
		}

		/**
		 * Called every frame.
		 * 
		 */
		override public function update():void
		{
			super.update();

			if(FlxG.mouse.justPressed())
				FlxG.switchState(new TitleState());
		}
	}
}