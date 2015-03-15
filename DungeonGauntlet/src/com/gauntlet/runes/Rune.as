package com.gauntlet.runes
{
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	import org.osflash.signals.Signal;

	
	/**
	 * 
	 * 
	 * @author Nicholas Valetnine
	 */
	public class Rune extends FlxSprite
	{
		[Embed(source = "../../../../embeded_resources/Game_Screen/Runes/RuneAttacks_SpriteSheet.png")] public static var SpriteSheet:Class;
		[Embed(source = '../../../../embeded_resources/Game_Screen/Upgrades/FPO_Rune.png')]public static var RuneUpgrade:Class;
		[Embed(source = "../../../../embeded_resources/SFX/Shoot.mp3")] private static var SoundShoot:Class;
		
		/** how fast the bullet objects fly  */
		protected var	nVelocity :Number;
		public var  	nVelocityX	:Number;
		public var	nVelocityY	:Number;
		/** the damage the gun deals */
		protected var	nDamage	:Number;
		/** the range of the weapon */
		protected var	nRange	:Number;
		/** The rate the weapon can fire at */
		protected var	nRate	:Number;
		/** The name of the weapon */
		protected var	sName	:String;
		
		public var		runeDiedSignal	:Signal = new Signal();
		
		protected var starting :FlxPoint;
		protected var nMyHealth :Number;
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the rune object.
		 */
		public function Rune($level:Number, X:Number, Y:Number, $parent:Rune = null, $isParent:Boolean = true, SimpleGraphic:Class = null)
		{
			super(X,Y, SimpleGraphic);
			starting = new FlxPoint(X, Y);
			this.loadGraphic(SpriteSheet, true, true, 64, 32);
				
			if ($parent == null)
				fillValues(0);
			else if ($isParent)
				copyParent($parent);
			else
				beatPrior($level, $parent);
				
			this.health = nMyHealth;
			
			//animations
			this.addAnimation("Magic", [1]);
			this.addAnimation("Elec", [2]);
			this.addAnimation("Ice", [3, 4, 5], 12);
			this.addAnimation("Fire", [6, 7, 8], 12);
			
			//offset
			this.width = 16;
			this.height = 16;
			this.offset.x = 8;
			this.offset.y = 8;
		}
		
		protected function beatPrior($curLevel:Number, $parent:Rune):void 
		{
			fillValues($curLevel);
			var diff: int = compareValues(this, $parent);
			while (diff >= 2)
			{
				var change :int = 1
				switch(change)
				{
					case 1: 
						if (this.nRate > $parent.nRate)
						{
							this.nRate = Math.min((((40 - $curLevel) + Math.random() * (60 - $curLevel)) * .01), $parent.nRate);
							break;
						}
					case 2: 
						if (this.nMyHealth < $parent.nMyHealth)
						{
							nMyHealth = Math.max((500 + Math.random() * (10000 + ($curLevel * 10))), $parent.nMyHealth);
							break;
						}
					case 3: 
						if (this.nVelocity < $parent.nVelocity)
						{
							this.nVelocity = Math.max((400 + (Math.random() * 300)), $parent.nVelocity);
							break;
						}
				}
				calcDamage($curLevel);
				diff = compareValues(this, $parent);
			}
			
		}
		
		private static function compareValues(self:Rune, $parent:Rune):int
		{
			var diffCount:int = 0;
			if (self.nRate > $parent.nRate)
				diffCount++;
			if (self.nRange < $parent.nRange)
				diffCount++;
			if (self.nVelocity < $parent.nVelocity)
				diffCount++;
			if (self.nDamage < $parent.nDamage)
				diffCount++;
			return diffCount;
		}
		
		/**
		 * Parses an XML file for the data about the weapon
		 *
		 * @param	$curLevel	the current level that the player is on. used for potentially modifying weapon's starting stats. 
		 * @return			Describe the return value here.
		 */
		public function fillValues($curLevel:int):void
		{
			this.nRate = 1;
			nMyHealth = 6000;
			this.nVelocity = 400;
			this.sName = "base Rune";
			this.nDamage = 20;
			//calcDamage();
		}
		
		public function calcDamage($curLevel:Number):void
		{
			this.nDamage = (21 * this.nRate) + ((1 / 2900) * this.nMyHealth) + ((1 / 80) * this.nVelocity) + $curLevel + 7;
		}
		private function copyParent($parent:Rune):void
		{
			this.nDamage = $parent.Damage;
			this.nRate = $parent.Rate;
			nMyHealth = $parent.health;
			this.nVelocity = $parent.myVelocity;
			this.sName = $parent.Name;
		}
		
		public function clone():Rune
		{
			var output:Rune = new Rune(0, this.x, this.y, this);
			return output;
		}
		
		override public function revive():void 
		{
			super.revive();
			this.health = nMyHealth;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Called every frame.
		 * Update the arms's rotation and other stuff.
		 */
		override public function update():void
		{
			if (!FlxG.paused)
			{
				super.update();
				if (!this.onScreen())
				{
					this.kill();
				}
				this.hurt(FlxU.getDistance(starting, new FlxPoint(this.x, this.y)));
				
				this.alpha = (this.health / this.nMyHealth);
				if (this.alpha == 0)
					this.kill();
				
				if (!this.alive)
					{
						this.runeDiedSignal.dispatch(this);
					}
				this.velocity.x = nVelocityX;
				this.velocity.y = nVelocityY;
			}
		}
		
/*		override public function hurt(Damage:Number):void 
		{
			this.health = this.nMyHealth - Damage;
			if (this.health <= 0)
				this.kill();
		}*/
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * gets the string for calculating the damage
		 */
		public function get Damage():Number
		{
			return nDamage;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * gets the range of the weapon
		 */
		public function get Range():Number
		{
			return nRange;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * gets the rate of fire for the weapon
		 */
		public function get Rate():Number
		{
			return nRate;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * gets the name of the weapon
		 */
		public function get Name():String
		{
			return sName;
		}
		
		public function get myVelocity():Number
		{
			return nVelocity;
		}
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * 
		 * @param	X
		 * @param	Y
		 */
		override public function reset(X:Number, Y:Number):void 
		{
			super.reset(X, Y);
			this.starting.x = X;
			this.starting.y = Y;
		}
		
		public function playSound():void
		{
			FlxG.play(SoundShoot, .7, false);
		}
		
		public function getUpgradeGraphic():Class
		{
			return RuneUpgrade;
		}
		
		public function triggerAnimation():void
		{
			//this one does nothing
		}
	}
}

