package com.gauntlet.objects.enemies
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	
	/**
	 * Base Enemy to extend from.
	 * 
	 * @author Casey Sliger
	 */
	public class BaseEnemy extends FlxSprite
	{
		/** Contact damage. */
		protected var	_nContactDamage :int = 0;
		/** Number of coins to drop. */
		protected var	_nRewardValue	:int = 0;
		/** Point value of the enemy used for spawning. */
		protected var	_nSpawnValue	:int = 0;
		
		/* ---------------------------------------------------------------------------------------- */
		
		
		/**
		 * Constructs the BaseEnemy object.
		 * 
		 * @param	X				The initial X position of the sprite.
		 * @param	Y				The initial Y position of the sprite.
		 * @param   hp				Hit points.
		 * @param	dmg				Contact damage amount.
		 */
		public function BaseEnemy(X:Number,Y:Number, hp:Number, dmg:int, value:int)
		{
			super(X, Y);
			
			this.health = hp;
			this._nContactDamage = dmg;
			_nSpawnValue = value;
		}
		
		/**
		 * Called every frame.
		 * Update the Enemy position and other stuff.
		 */
		override public function update():void
		{
			this.y = (this.y + this.height / 2) % FlxG.height - this.height / 2;
		}
		
		/**
		 * Damage the enemy and check if dead.
		 * 
		 * @param	Damage			Number of health to take away.
		 */
		override public function hurt(Damage:Number):void
		{
			super.hurt(Damage);
			
			if (this.health <= 0)
			{
				//die
			}
		}
		/**
		 * 
		 * Returns the contact damage value
		 */
		public function getContact():int
		{
		return this._nContactDamage;
		}
	}
}

