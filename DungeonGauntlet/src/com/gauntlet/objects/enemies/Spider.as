package com.gauntlet.objects.enemies
{
	import com.gauntlet.objects.player.Hero;
	import org.flixel.FlxObject;
	
	/**
	 * Spider enemy
	 * 
	 * @author Casey Sliger
	 */
	public class Spider extends BaseEnemy
	{
		[Embed(source = "../../../../../embeded_resources/Game_Screen/Enemies/Spider.png")] private static var ImgSpider:Class;
		
		/* ---------------------------------------------------------------------------------------- */
		/** Reference to the hero. */
		private var _mcHero:	Hero;
		/**
		 * Constructs the Spider object.
		 * 
		 * @param	X				The initial X position of the sprite.
		 * @param	Y				The initial Y position of the sprite.
		 */
		public function Spider(X:Number=0,Y:Number=0)
		{
			super(X, Y, 60, 20, 3);
			
			this.loadGraphic(ImgSpider, true, true, 32, 32);
			
			//bounding box tweaks
			this.width = 28;
			this.height = 30;
			this.offset.x = 2;
			this.offset.y = 1;
			
			//basic player physics
			this.drag.x = 2000;
			this.acceleration.y = 500;
			this.maxVelocity.x = 90;
			this.maxVelocity.y = 130;
			
			//animations
			this.addAnimation("idle", [0]);
		}
		/* ---------------------------------------------------------------------------------------- */
		/**
		 * Called every frame.
		 * Update the Enemy position and other stuff.
		 */
		override public function update():void
		{
			super.update();
			
			this.play("idle");
			this.acceleration.x = 0;
			if ((_mcHero.x - this.x) <= -16 && (_mcHero.x - this.x) >= -160)///just a place holder the real movement is yet to come
			{
				this.acceleration.x -= this.drag.x;
				this.facing = FlxObject.RIGHT;
			}
			if ((_mcHero.x - this.x) >= 28 && (_mcHero.x - this.x) <= 160)///just a place holder the real movement is yet to come
			{
				this.acceleration.x += this.drag.x;
				this.facing = FlxObject.LEFT;
			}
		}
		/* ---------------------------------------------------------------------------------------- */
		/**
		 * 
		 * gets the hero to target
		 */
		public function acquireTarget(hero:Hero):void 
		{
			_mcHero = hero;
		}
		
	}
}

