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
		[Embed(source = '../../../../../embeded_resources/Game_Screen/Upgrades/Coin.png')]private static var CoinGraphic:Class;
		public var LifeTimer	:FlxTimer;
		private var lifeTime	:Number = 6;
		//coin graphic
		public function Coin($enemy:FlxSprite, $isBoss:Boolean = false) 
		{
			super($enemy.x, $enemy.y);
			this.loadGraphic(CoinGraphic, true, true, 16);
			this.health = 5000;
			LifeTimer = new FlxTimer();
			LifeTimer.start(lifeTime, 1, timeEnd);
			this.acceleration.y = 150;
			this.velocity.y = -50 - Math.random() * -150;
			this.velocity.x = 20 - Math.random() * 40;
			this.elasticity = .55;
			//this.ID = int(Math.random() * 1000);
		}
		
		override public function update():void 
		{
			super.update();
			if (Math.abs(this.velocity.y) < 2)
				this.velocity.y = 0;
				
			//this.health = this.health * LifeTimer.timeLeft;
		}
		
		public function timeEnd(Timer:FlxTimer):void
		{
			this.kill();
		}
	}

}