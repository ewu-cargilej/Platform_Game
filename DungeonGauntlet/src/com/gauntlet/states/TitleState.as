package com.gauntlet.states
{
	import com.gauntlet.objects.enemies.BaseEnemy;
	import com.gauntlet.objects.enemies.Bat;
	import com.gauntlet.objects.enemies.Ghost;
	import com.gauntlet.objects.enemies.Lumberer;
	import com.gauntlet.objects.enemies.PlayButtonEnemy;
	import com.gauntlet.objects.enemies.Spider;
	import com.gauntlet.objects.player.Hero;
	import flash.display.BlendMode;
	import org.flixel.*;
	import treefortress.sound.SoundAS;

	/**
	 * Title Scree/Level 0
	 * 
	 * @author Casey Sliger
	 */
	public class TitleState extends PlayState
	{
		[Embed(source = '../../../../embeded_resources/Title_Screen/TitleScreen_Logo.png')]private static var TitleLogo:Class;
		[Embed(source = '../../../../embeded_resources/Title_Screen/Button_Play.png')]private static var PlayButton:Class;
		[Embed(source = '../../../../embeded_resources/Title_Screen/Button_Credits.png')]private static var CreditsButton:Class;
		[Embed(source = '../../../../embeded_resources/Title_Screen/Icon_Jump.png')]private static var ImgJump:Class;
		[Embed(source = '../../../../embeded_resources/Title_Screen/Icon_MoveLeft.png')]private static var ImgLeft:Class;
		[Embed(source = '../../../../embeded_resources/Title_Screen/Icon_MoveRight.png')]private static var ImgRight:Class;
		[Embed(source = '../../../../embeded_resources/Title_Screen/Icon_Pause.png')]private static var ImgPause:Class;
		
		[Embed(source = '../../../../embeded_resources/SFX/Button_Click.mp3')]private static var ButtonClick:Class;
		
		/** Holder for Title components */
		protected var	_aTitleStuff	:Array;
		
		/**
		 * Set up the state.
		 */
		override public function create():void
		{
			SoundAS.stopAll();
			SoundAS.playLoop("Title", .7, 0, true);
			
			FlxG.mouse.show();
			
			this._bLevelComplete = false;
			this._nLevelNumber = 0;
			this._aTitleStuff = new Array();
			
			var background:FlxSprite = new FlxSprite(0, 0, ImgBackground);
			add(background);
			
			setupPlayer(FlxG.width/2 - 16, 640);
			
			levelMap = new FlxTilemap();
			this.generateRoomTiles(false);
			establishGroups();
			
			this.createTitle();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		
		
		/**
		 * @private
		 * Check for the hero exiting the room and create a new room if it does.
		 * Also wraps the hero when exiting the room.
		 * 
		 */
		override protected function wrap():void
		{
			if (this.mcHero.x > FlxG.width)
			{
				FlxG.switchState(new PlayState());
			}
				
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Place stuff for Title Screen.
		 *
		 */
		protected function createTitle():void
		{
			var tmpSprite :FlxSprite = new FlxSprite(FlxG.width / 2 - 225, FlxG.height / 2 - 300, TitleLogo);
			this._aTitleStuff.push(tmpSprite);
			add(tmpSprite);
			
			tmpSprite = new FlxSprite(FlxG.width / 2 - 35, FlxG.height / 2 + 50, ImgJump);
			this._aTitleStuff.push(tmpSprite);
			add(tmpSprite);
			
			tmpSprite = new FlxSprite(FlxG.width / 2 + 70, FlxG.height / 2 + 150, ImgRight);
			this._aTitleStuff.push(tmpSprite);
			add(tmpSprite);
			
			tmpSprite = new FlxSprite(FlxG.width / 2 - 140, FlxG.height / 2 + 150, ImgLeft);
			this._aTitleStuff.push(tmpSprite);
			add(tmpSprite);
			
			tmpSprite = new FlxSprite(FlxG.width / 2 - 95, FlxG.height - 68, ImgPause);
			this._aTitleStuff.push(tmpSprite);
			add(tmpSprite);
			
			var tempEnemy :PlayButtonEnemy = new PlayButtonEnemy();
			super._enemyGroup.add(tempEnemy);
			tempEnemy.playGameSignal.add(removeTitle);
			add(tempEnemy);
			
			var tmpButton:FlxButton = new FlxButton(60, FlxG.height / 2, "", goToCredits);
			tmpButton.loadGraphic(CreditsButton);
			this._aTitleStuff.push(tmpButton);
			add(tmpButton);
		}
		
		/**
		 * @private
		 * Remove stuff for Title Screen.
		 */
		protected function removeTitle():void
		{
			this._enemyGroup.kill();
			this._enemyGroup.clear();
			FlxG.play(ButtonClick, 1, false);
			
			this._bLevelComplete = true;
			
			var tmpObj: FlxObject;
			
			while (this._aTitleStuff.length > 0)
			{
				tmpObj = this._aTitleStuff.pop();
				tmpObj.destroy();
				remove(tmpObj);
			}
			
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Go to credits.
		 *
		 */
		protected function goToCredits():void
		{
			FlxG.play(ButtonClick, 1, false);
			FlxG.switchState(new CreditsState());
		}
	}
}
