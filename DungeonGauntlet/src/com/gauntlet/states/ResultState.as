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
		
		/** FlxSave object to store score and retrieve data. */
		protected var	_saveData	:FlxSave;
		
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
			this._saveData = new FlxSave();
			this._saveData.bind("scoreData");
			
			var tmpSprite:FlxSprite;
			tmpSprite = new FlxSprite(0, 0, ImgBackground);
			add(tmpSprite);
			
			tmpSprite = new FlxSprite(FlxG.width / 2 - 137, FlxG.height - 150, ImgPlayAgain);
			add(tmpSprite);
			
			tmpSprite = new FlxSprite(FlxG.width / 4 * 3 - 111, 75, ImgTopScores);
			add(tmpSprite);
			
			if (this._bWin)
			{
				FlxG.playMusic(MusicVictory, .8);
				
				tmpSprite = new FlxSprite(0, 0, ImgTreasure);
				add(tmpSprite);
				
				tmpSprite = new FlxSprite(FlxG.width/2 - 455, 50, ImgVictory);
				add(tmpSprite);
			}
			else
			{
				FlxG.playMusic(MusicDefeat, .7);
				
				tmpSprite = new FlxSprite(0, 0, ImgBones);
				add(tmpSprite);
				
				tmpSprite = new FlxSprite(FlxG.width/2 - 455, 50, ImgDefeat);
				add(tmpSprite);
			}
			
			setUpLeaderboard();
			
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
		
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Show the top 5 scores.
		 *
		 */
		protected function setUpLeaderboard():void
		{
			var currentScore :int = this._saveData.data.currentScore;
			var scores :Vector.<int> = new Vector.<int>();
			var tempText :FlxText;
			var tempInt :int;
			
			if (_saveData.data.score1 == null)
				_saveData.data.score1 = 130000;
			if (_saveData.data.score2 == null)
				_saveData.data.score2 = 100000;
			if (_saveData.data.score3 == null)
				_saveData.data.score3 = 70000;
			if (_saveData.data.score4 == null)
				_saveData.data.score4 = 50000;
			if (_saveData.data.score5 == null)
				_saveData.data.score5 = 30000;
			
			scores.push(_saveData.data.score1);
			scores.push(_saveData.data.score2);
			scores.push(_saveData.data.score3);
			scores.push(_saveData.data.score4);
			scores.push(_saveData.data.score5);
			scores.push(currentScore);
			
			scores = scores.sort(compare);
			
			tempInt = scores.pop();
			_saveData.data.score1 = tempInt;
			tempText = new FlxText(FlxG.width / 4 * 3 - 50, 150, 100, "" + tempInt);
			tempText.size = 20;
			tempText.alignment = "center";
			add(tempText);
			
			tempInt = scores.pop();
			_saveData.data.score2 = tempInt;
			tempText = new FlxText(FlxG.width / 4 * 3 - 50, 200, 100, "" + tempInt);
			tempText.size = 20;
			tempText.alignment = "center";
			add(tempText);
			
			tempInt = scores.pop();
			_saveData.data.score3 = tempInt;
			tempText = new FlxText(FlxG.width / 4 * 3 - 50, 250, 100, "" + tempInt);
			tempText.size = 20;
			tempText.alignment = "center";
			add(tempText);
			
			tempInt = scores.pop();
			_saveData.data.score4 = tempInt;
			tempText = new FlxText(FlxG.width / 4 * 3 - 50, 300, 100, "" + tempInt);
			tempText.size = 20;
			tempText.alignment = "center";
			add(tempText);
			
			tempInt = scores.pop();
			_saveData.data.score5 = tempInt;
			tempText = new FlxText(FlxG.width / 4 * 3 - 50, 350, 100, "" + tempInt);
			tempText.size = 20;
			tempText.alignment = "center";
			add(tempText);
		}
		
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Used to sort a vector of type int.
		 *
		 * @param	$x		First number.
		 * @param	$y		Second number.
		 * @return			The difference between the twon numbers.
		 */
		protected function compare($x:int, $y:int):Number
		{
			return $x - $y;
		}
	}
}