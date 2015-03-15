package com.gauntlet.objects.items
{
	import com.gauntlet.runes.Rune;
	import com.gauntlet.runes.UpgradeManager;
	import flash.display.Sprite;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.osflash.signals.Signal;

	
	/**
	 * manages all items that are on screen
	 * 
	 * @author Nicholas Valetnine
	 */
	public class ItemManager extends Sprite
	{
		private var uManager :UpgradeManager;
		[Embed(source = "../../../../../embeded_resources/SFX/Pickup_Coin.mp3")] private static var CollectSound:Class;
		public var spawnObjectSignal :Signal = new Signal();
		public var removeObjectSignal	:Signal = new Signal();
		public var upgradeHealthSignal	:Signal = new Signal();
		public var newRuneSignal		:Signal = new Signal();
		public var addStatSignal		:Signal = new Signal();
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the itemManager object.
		 */
		public function ItemManager()
		{
			super();
			uManager = new UpgradeManager();
			uManager.upgradeHealthSignal.add(upgradeHealth);
			uManager.newRuneSignal.add(upgradeRune);
			uManager.displayUpgradeSignal.add(addItem);
			uManager.displayDataSignal.add(addStat);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * spawns a new collectible
		 *
		 * @param	$param1	Describe param1 here.
		 * @return			Describe the return value here.
		 */
		public function spawnCollectible($enemy:FlxSprite):void
		{
			for (var i:int = 0; i < $enemy.ID; i++)
			{
				var tempCoin:Coin = new Coin($enemy, $enemy.ID == 30);
				addItem(tempCoin);
			}
			
			/*if ($enemy.ID != 999)
			{
				var tempCoin:Coin = new Coin($enemy);
				addItem(tempCoin);
			}
			else
			{
				this.bossSpawn($enemy);
			}*/
		}
		
		private function bossSpawn($enemy:FlxSprite):void 
		{
			
		}
		
		public function addItem($object:FlxSprite):void
		{
			this.spawnObjectSignal.dispatch($object);
		}
		
		public function addStat($stat:FlxSprite):void
		{
			this.addStatSignal.dispatch($stat);
		}
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * spawns a new upgrade
		 *
		 * @param	$param1	Describe param1 here.
		 * @return			Describe the return value here.
		 */
		public function spawnUpgrade($level:Number,$curRune:Rune, $X:Number, $Y:Number):void
		{
			uManager.spawnUpgrade($level,$curRune,$X,$Y );
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * used when an item is collected
		 *
		 * @param	$param1	Describe param1 here.
		 * @return			Describe the return value here.
		 */
		public function collect(Object1:FlxObject,Object2:FlxObject):void
		{
			var value:Number;
			if (uManager.isUpgrade(Object2))
			{
				//we need no signal
			}
			else
			{
				value = Object2.health;
				FlxG.play(CollectSound, .7, false);
				this.removeObjectSignal.dispatch(Object2, value);
			}
		}
		
		public function upgradeRune(runeUpgrade:FlxSprite, healthUpgrade:FlxSprite, newRune:Rune):void 
		{
			this.newRuneSignal.dispatch(runeUpgrade,healthUpgrade,newRune);
		}
		
		public function upgradeHealth(runeUpgrade:FlxSprite, healthUpgrade:FlxSprite):void 
		{
			this.upgradeHealthSignal.dispatch(runeUpgrade,healthUpgrade);
		}
		/* ---------------------------------------------------------------------------------------- */
		
	}
}

