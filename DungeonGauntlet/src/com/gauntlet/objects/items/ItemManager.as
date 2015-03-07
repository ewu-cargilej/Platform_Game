package com.gauntlet.objects.items
{
	import com.gauntlet.runes.Rune;
	import com.gauntlet.runes.UpgradeManager;
	import flash.automation.Configuration;
	import flash.display.Sprite;
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
		public var spawnObjectSignal :Signal = new Signal();
		public var removeObjectSignal	:Signal = new Signal();
		public var upgradeHealthSignal	:Signal = new Signal();
		public var newRuneSignal		:Signal = new Signal();
		
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
			var tempCoin:Coin = new Coin($enemy);
			addItem(tempCoin);
		}
		
		public function addItem($object:FlxSprite):void
		{
			this.spawnObjectSignal.dispatch($object);
		}
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * spawns a new upgrade
		 *
		 * @param	$param1	Describe param1 here.
		 * @return			Describe the return value here.
		 */
		public function spawnUpgrade():void
		{
			uManager.spawnUpgrade(0);
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
				value = -1;
			}
			else
				value = Object2.health;
				
			this.removeObjectSignal.dispatch(Object2, value);
		}
		
		public function upgradeRune($rune:Rune):void 
		{
			this.newRuneSignal.dispatch($rune);
		}
		
		public function upgradeHealth():void 
		{
			this.upgradeHealthSignal.dispatch();
		}
		/* ---------------------------------------------------------------------------------------- */
		
	}
}

