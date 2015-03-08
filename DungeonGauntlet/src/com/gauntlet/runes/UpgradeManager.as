package com.gauntlet.runes
{
	import flash.display.Sprite;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import com.gauntlet.runes.Rune;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.osflash.signals.Signal;

	
	/**
	 * creates and spawns new runes
	 * 
	 * @author Nicholas Valetnine
	 */
	public class UpgradeManager extends Sprite
	{
		
		[Embed(source = '../../../../embeded_resources/Game_Screen/Upgrades/FPO_Health.png')]private static var HealthUpgradeGraphic:Class;
		
		private var newRune  :Rune;
		private var runeUpgrade :FlxSprite;
		private var healthUpgrade :FlxSprite;
		
		public var displayUpgradeSignal	:Signal = new Signal;
		public var removeButtonSignal	:Signal = new Signal;
		public var upgradeHealthSignal	:Signal = new Signal;
		public var newRuneSignal		:Signal = new Signal;
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the runeMaker object.
		 */
		public function UpgradeManager()
		{
			super();
					
			
		}
		
		public function spawnUpgrade($level:Number):void
		{
			//rune upgrade
			generateRune($level);
			runeUpgrade = new FlxSprite(32 * 30, 32 * 19);
			runeUpgrade.ID = 10101;
			runeUpgrade.loadGraphic(newRune.getUpgradeGraphic());
			//load text data and display
			this.displayUpgradeSignal.dispatch(runeUpgrade);
			
			//rune text
			//_txtScore = new FlxText(FlxG.width/2 - 64, FlxG.height - 48, 400, "Score: " + intScore);
			//_txtScore.size = 24;
			//add(_txtScore);
			
			//or graphic
			
			//health upgrade
			healthUpgrade = new FlxSprite(32 * 27, 32 * 19);
			healthUpgrade.ID = 20202;
			healthUpgrade.loadGraphic(HealthUpgradeGraphic);
			this.displayUpgradeSignal.dispatch(healthUpgrade);
		}
		
		private function generateRune($level:Number):void
		{
			var runeType:Number;
			runeType = Math.random() * 4;
			
			if( 1 > runeType && runeType > 0)
			{
				this.newRune = new MagicRune(0, 0);
			}
			else if( 2 > runeType && runeType > 1)
			{
				this.newRune = new FireRune(0, 0);
			}
			else if( 3 > runeType && runeType > 2)
			{
				this.newRune = new IceRune(0, 0);
			}
			else if( 4 > runeType && runeType > 3)
			{
				this.newRune = new LightningRune(0, 0);
			}
			else
			{
				this.newRune = new Rune(0, 0);
			}			
		}
		
		/* ---------------------------------------------------------------------------------------- */		
		
		/**
		 * Relinquishes all memory used by this object.
		 */
		public function destroy():void
		{
			while (this.numChildren > 0)
				this.removeChildAt(0);
		}
		
		public function isUpgrade(object2:FlxObject):Boolean 
		{
			if (object2.ID == runeUpgrade.ID)
			{
				this.newRuneSignal.dispatch(runeUpgrade, healthUpgrade, newRune);
				return true;
			}
			else if (object2.ID == healthUpgrade.ID)
			{
				this.upgradeHealthSignal.dispatch(runeUpgrade, healthUpgrade);
				return true;
			}
			return false;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
	}
}

