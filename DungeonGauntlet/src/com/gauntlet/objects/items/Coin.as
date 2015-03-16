package com.gauntlet.objects.items 
{
	import org.flixel.FlxG;
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
		public var PopTimer		:FlxTimer;
		private var lifeTime	:Number = 3;
		public var tileCollision	:Number = 0;
		//coin graphic
		public function Coin($enemy:FlxSprite, $isBoss:Boolean = false) 
		{
			super($enemy.x, $enemy.y);
			this.loadGraphic(CoinGraphic, true, true, 16);
			this.health = 5000;
			LifeTimer = new FlxTimer();
			if ($isBoss)
			{
				var bossTimer:int = lifeTime + (Math.random() * 13);
				LifeTimer.start(bossTimer, 1, timeEnd);
				this.acceleration.y = 200;
				this.velocity.y = -500 - Math.random() * -200;
				this.velocity.x = 100 - Math.random() * 300;
				this.elasticity = .7;
			}
			else
			{
				LifeTimer.start(lifeTime, 1, timeEnd);
				this.acceleration.y = 150;
				this.velocity.y = -120 - Math.random() * -150;
				this.velocity.x = 80 - Math.random() * 160;
				this.elasticity = .55;
			}
		}
		
		override public function update():void 
		{
			super.update();
			this.alpha = (LifeTimer.timeLeft / lifeTime);
			this.y = (this.y + this.height / 2) % FlxG.height - this.height / 2;
			
			//this.health = this.health * (LifeTimer.timeLeft / lifeTime);
		}
		
		public function collideCount():void
		{
			this.tileCollision++;
			if (tileCollision > 3)
			{
				this.y -= 40;
				this.tileCollision = 0;
			}
			PopTimer.stop();
			PopTimer.start(.3, 1, collideReset);
		}
		
		public function timeEnd(Timer:FlxTimer):void
		{
			this.kill();
		}
		
		public function collideReset(Timer:FlxTimer):void
		{
			this.tileCollision = 0;
		}
	}

}