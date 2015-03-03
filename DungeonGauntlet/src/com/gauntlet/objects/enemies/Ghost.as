package com.gauntlet.objects.enemies
{
	import com.gauntlet.objects.player.Hero;
	
	/**
	 * Ghost enemy, final boss.
	 * 
	 * @author Casey Sliger
	 */
	public class Ghost extends BaseEnemy
	{
		[Embed(source = "../../../../../embeded_resources/Game_Screen/Enemies/Ghost.png")] private static var ImgGhost:Class;
		
		/** Reference to the hero. */
		private var _mcHero:	Hero;
		/** Counts the number of frames. */
		protected var	_nFrame: int = 60;
		/** Attack damage. Different from contact damage. */
		protected var	_nAttackDamage	:int;
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the Ghost object.
		 * 
		 * @param	X				The initial X position of the sprite.
		 * @param	Y				The initial Y position of the sprite.
		 */
		public function Ghost(X:Number=0,Y:Number=0)
		{
			super(X, Y, 280, 25, 11);
			
			this._nAttackDamage = 50;
			
			//actual height in png is 46
			this.loadGraphic(ImgGhost, true, true, 64, 46);
			
			//bounding box tweaks
			this.width = 60;
			this.height = 44;
			this.offset.x = 2;
			this.offset.y = 1;
			
			//basic player physics
			this.drag.x = 2000;
			this.acceleration.y = 0;
			this.maxVelocity.x = 120;
			this.maxVelocity.y = 120;
			
			//animations
			this.addAnimation("idle", [0]);
		}
		
		/**
		 * Called every frame.
		 * Update the Enemy position and other stuff.
		 */
		override public function update():void
		{
			super.update();
			
			this.play("idle");
			this.acceleration.x = 0;
			this.acceleration.y = 0;
			_nFrame++;
			if (_nFrame <= 14)//first 15 frames move left
			{
			this.acceleration.x -= this.drag.x;
			}
			if (_nFrame > 14)//second 15 frames move right
			{
			this.acceleration.x += this.drag.x;	
			}
			if (_nFrame >= 30)
			{
			_nFrame = 0;	
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

