package com.gauntlet.runes
{
	import com.gauntlet.runes.Rune;
	import flash.display.Sprite;
	import org.flixel.FlxG;
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
		//Graphic for the Health Upgrade
		[Embed(source = '../../../../embeded_resources/Game_Screen/Upgrades/HealthUpgrade.png')]private static var HealthUpgradeGraphic:Class;
		//Graphic for stats
		[Embed(source = '../../../../embeded_resources/Game_Screen/Upgrades/UpgradeStats.png')]private static var StatsGraphic:Class;
		//Graphics for Pluses
		[Embed(source = '../../../../embeded_resources/Game_Screen/Upgrades/Plus_And_Minus/PlusTop.png')]private static var PlusT:Class;
		[Embed(source = '../../../../embeded_resources/Game_Screen/Upgrades/Plus_And_Minus/PlusUpperMiddle.png')]private static var PlusUM:Class;
		[Embed(source = '../../../../embeded_resources/Game_Screen/Upgrades/Plus_And_Minus/PlusLowerMiddle.png')]private static var PlusLM:Class;
		[Embed(source = '../../../../embeded_resources/Game_Screen/Upgrades/Plus_And_Minus/PlusBottom.png')]private static var PlusB:Class;
		//Graphics for Minuses
		[Embed(source = '../../../../embeded_resources/Game_Screen/Upgrades/Plus_And_Minus/MinusTop.png')]private static var MinusT:Class;
		[Embed(source = '../../../../embeded_resources/Game_Screen/Upgrades/Plus_And_Minus/MinusUpperMiddle.png')]private static var MinusUM:Class;
		[Embed(source = '../../../../embeded_resources/Game_Screen/Upgrades/Plus_And_Minus/MinusLowerMiddle.png')]private static var MinusLM:Class;
		[Embed(source = '../../../../embeded_resources/Game_Screen/Upgrades/Plus_And_Minus/MinusBottom.png')]private static var MinusB:Class;
		//Sounds for upgrades
		[Embed(source = "../../../../embeded_resources/SFX/Rune_Upgrade.mp3")] private static var RuneUpgradeSound:Class;
		[Embed(source = "../../../../embeded_resources/SFX/Health_Upgrade.mp3")] private static var HealthUpgradeSound:Class;
		private var newRune  :Rune;
		private var runeUpgrade :FlxSprite = new FlxSprite();
		private var healthUpgrade :FlxSprite = new FlxSprite();
		private var pluses			:Array = new Array;
		private var minuses			:Array = new Array;
		private var UpgradeStats	:FlxSprite;
		
		public var displayUpgradeSignal	:Signal = new Signal;
		public var displayDataSignal	:Signal = new Signal;
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
			runeUpgrade.ID = 10101;
			healthUpgrade.ID = 20202;
		}
		
		public function spawnUpgrade($level:Number, $currRune:Rune, $X:Number, $Y:Number):void
		{
			//reviveStats();
			plusMinusSet($X, $Y - .5);
			//rune upgrade
			generateRune($level, $currRune);
			runeUpgrade = new FlxSprite(32 * ($X - 1), 32 * ($Y - 1.5));
			runeUpgrade.ID = 10101;
			runeUpgrade.loadGraphic(newRune.getUpgradeGraphic());
			//load text data and display
			this.displayUpgradeSignal.dispatch(runeUpgrade);
			
			compareRunes($currRune);
			
			//health upgrade
			healthUpgrade = new FlxSprite(32 * ($X - 3), 32 * ($Y - 1.5));
			healthUpgrade.ID = 20202;
			healthUpgrade.loadGraphic(HealthUpgradeGraphic);
			this.displayUpgradeSignal.dispatch(healthUpgrade);
		}
		
		private function plusMinusSet($X:Number, $Y:Number):void
		{
			UpgradeStats = new FlxSprite(32 * $X, 32 * ($Y - 1));
			UpgradeStats.loadGraphic(StatsGraphic);
			
			pluses[0] = new FlxSprite(32 * ($X - 1), 32 * ($Y - 1));
			pluses[0].loadGraphic(PlusT);
			pluses[1] = new FlxSprite(32 * ($X - 1), 32 * ($Y - 1));
			pluses[1].loadGraphic(PlusUM);
			pluses[2] = new FlxSprite(32 * ($X - 1), 32 * ($Y - 1));
			pluses[2].loadGraphic(PlusLM);
			pluses[3] = new FlxSprite(32 * ($X - 1), 32 * ($Y - 1));
			pluses[3].loadGraphic(PlusB);
			
			minuses[0] = new FlxSprite(32 * ($X - 1), 32 * ($Y - 1));
			minuses[0].loadGraphic(MinusT);
			minuses[1] = new FlxSprite(32 * ($X - 1), 32 * ($Y - 1));
			minuses[1].loadGraphic(MinusUM);
			minuses[2] = new FlxSprite(32 * ($X - 1), 32 * ($Y - 1));
			minuses[2].loadGraphic(MinusLM);
			minuses[3] = new FlxSprite(32 * ($X - 1), 32 * ($Y - 1));
			minuses[3].loadGraphic(MinusB);
		}
		
		private function reviveStats():void 
		{
			for (var i:uint = 0; i < 4; i++)
			{
				pluses[i].revive();
				minuses[i].revive();
			}
			UpgradeStats.revive();
		}
		
		private function compareRunes($currRune:Rune):void 
		{
			//compare the stats of the two runes and display the proper graphic
			this.displayDataSignal.dispatch(UpgradeStats);
			
			if (this.newRune.myVelocity >= $currRune.myVelocity)
				this.displayDataSignal.dispatch(pluses[0]);
			else
				this.displayDataSignal.dispatch(minuses[0]);
				
			if (this.newRune.Range >= $currRune.Range)
				this.displayDataSignal.dispatch(pluses[1]);
			else
				this.displayDataSignal.dispatch(minuses[1]);
			
			if (this.newRune.Rate <= $currRune.Rate)
				this.displayDataSignal.dispatch(pluses[2]);
			else
				this.displayDataSignal.dispatch(minuses[2]);
				
			if (this.newRune.Damage >= $currRune.Damage)
				this.displayDataSignal.dispatch(pluses[3]);
			else
				this.displayDataSignal.dispatch(minuses[3]);
		}
		
		private function generateRune($level:Number, $currRune:Rune):void
		{
			var runeType:Number;
			runeType = Math.random() * 4;
			
			//this.newRune = new RupeeRune(0, 0);
		
			if( 1 > runeType && runeType > 0)
			{
				this.newRune = new MagicRune($level, 0, 0, $currRune, false);
			}
			else if( 2 > runeType && runeType > 1)
			{
				this.newRune = new FireRune($level, 0, 0, $currRune, false);
			}
			else if( 3 > runeType && runeType > 2)
			{
				this.newRune = new IceRune($level, 0, 0, $currRune, false);
			}
			else if( 4 > runeType && runeType > 3)
			{
				this.newRune = new LightningRune($level, 0, 0, $currRune, false);
			}
			else
			{
				this.newRune = new Rune(0, 0, 0);
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
				FlxG.play(RuneUpgradeSound, .7, false);
				return true;
			}
			else if (object2.ID == healthUpgrade.ID)
			{
				this.upgradeHealthSignal.dispatch(runeUpgrade, healthUpgrade);
				FlxG.play(HealthUpgradeSound, .7, false);
				return true;
			}
			return false;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
	}
}

