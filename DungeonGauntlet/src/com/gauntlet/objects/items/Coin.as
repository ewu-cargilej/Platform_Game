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
		public var LifeTimer	:FlxTimer;
		private var lifeTime	:Number = 1;
		//coin graphic
		public function Coin($enemy:FlxSprite) 
		{
			super($enemy.x, $enemy.y);
			//this.loadGraphic(coinGraphic, true, true, 32);
			this.health = 5000;
			LifeTimer = new FlxTimer();
			LifeTimer.start(lifeTime, 1, kill);
		}
		
		override public function update():void 
		{
			super.update();
			this.health = this.health * LifeTimer.timeLeft;
		}
		
	}

}