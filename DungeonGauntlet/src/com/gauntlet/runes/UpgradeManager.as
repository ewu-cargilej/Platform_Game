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
		
		[Embed(source = '../../../../embeded_resources/Game_Screen/Upgrades/FPO_Health.png')]private static var HealthUpgrade:Class;
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
			newRune = generateRune($level);
			runeUpgrade = new FlxSprite(350, 350);
			runeUpgrade.ID = 10101;
			runeUpgrade.loadGraphic(Rune.RuneUpgrade);
			//load text data and display
			this.displayUpgradeSignal.dispatch(runeUpgrade);
			
			//health upgrade
			/*
			healthUpgrade = new FlxSprite(x, y);
			healthUpgrade.ID = 20202;
			healthUpgrade.loadGraphic(health);
			this.displayUpgradeSignal.dispatch(healthUpgrade);
			*/
		}
		
		private function generateRune($level:Number):Rune
		{
			var runeType:int = 1 + (Math.random() * 3);
			var newRune :Rune;
			//switch types
			newRune = new Rune(0, 0);
			return newRune;
			
		}
		
		/*private function changeRune():void
		{
			//something
			this.newRuneSignal.dispatch(newRune);
			this.runeButton.visible = false;
			this.removeButtonSignal.dispatch(runeButton);
		}*/
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
				this.newRuneSignal.dispatch(newRune);
				return true;
			}
			else if (object2.ID == healthUpgrade.ID)
			{
				this.upgradeHealthSignal.dispatch();
				return true;
			}
			return false;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
	}
}

