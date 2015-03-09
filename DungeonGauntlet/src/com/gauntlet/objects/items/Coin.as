package com.gauntlet.objects.items 
{
	import flash.utils.Timer;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTimer;
	
	/**
	 * ...
	 * @author Nicholas Valentine
	 */
	public class Coin extends FlxSprite
	{
		[Embed(source = '../../../../../embeded_resources/Game_Screen/Upgrades/FPO_Coin.png')]private static var CoinGraphic:Class;
		public var LifeTimer	:FlxTimer;
		private var lifeTime	:Number = 3;
		//coin graphic
		public function Coin($enemy:FlxSprite) 
		{
			super($enemy.x, $enemy.y);
			this.loadGraphic(CoinGraphic, true, true, 16);
			this.health = 5000;
			LifeTimer = new FlxTimer();
			LifeTimer.start(lifeTime, 1, timeEnd);
			this.acceleration.y = 50;
			//this.ID = int(Math.random() * 1000);
		}
		
		override public function update():void 
		{
			super.update();
			//this.health = this.health * LifeTimer.timeLeft;
		}
		
		public function timeEnd(Timer:FlxTimer):void
		{
			this.kill();
		}
	}

}