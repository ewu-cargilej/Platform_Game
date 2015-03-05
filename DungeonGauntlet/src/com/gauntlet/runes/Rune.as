package com.gauntlet.runes
{
	import flash.display.Sprite;
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
		[Embed(source = "../../../../embeded_resources/Game_Screen/Upgrades/testshot.png")] private static var ImgRuneTemp:Class;
		[Embed(source = '../../../../embeded_resources/Game_Screen/Upgrades/FPO_Rune.png')]public static var RuneUpgrade:Class;
		[Embed(source = "../../../../embeded_resources/SFX/Shoot.mp3")] private static var SoundShoot:Class;
		
		/** how fast the bullet objects fly  */
		protected var	nVelocity :Number;
		/** the damage the gun deals */
		protected var	nDamage	:Number;
		/** the range of the weapon */
		protected var	nRange	:Number;
		/** The rate the weapon can fire at */
		protected var	nRate	:Number;
		/** The name of the weapon */
		protected var	sName	:String;
		
		public var		runeDiedSignal	:Signal = new Signal();
		
		private var starting :FlxPoint;
		private var nMyHealth :Number;
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the rune object.
		 */
		public function Rune(X:Number, Y:Number, $parent:Rune = null, SimpleGraphic:Class=null)
		{
			super(X,Y, SimpleGraphic);
			starting = new FlxPoint(X, Y);
			this.loadGraphic(ImgRuneTemp, true, true, 32);
				
			if ($parent == null)
				fillValues(0);
			else
				copyParent($parent);
				
			this.health = nMyHealth;
			
			//offset
			this.width = 16;
			this.height = 16;
			this.offset.x = 8;
			this.offset.y = 8;
		}
		
		/**
		 * Parses an XML file for the data about the weapon
		 *
		 * @param	$curLevel	the current level that the player is on. used for potentially modifying weapon's starting stats. 
		 * @return			Describe the return value here.
		 */
		public function fillValues($curLevel:int):void
		{
			//not currently used
			this.nDamage = Math.random() * 40;
			this.nRate = Math.random();
			nMyHealth = Math.random() * 15000;
			this.nVelocity = 400 + (Math.random() * 300);
			this.sName = "tester Rune";
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
			var output:Rune = new Rune(this.x, this.y, this);
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
			super.update();
			if (!this.onScreen())
			{
				this.kill();
			}
			this.hurt(FlxU.getDistance(starting, new FlxPoint(this.x, this.y)));
			
		if (!this.alive)
			{
				this.runeDiedSignal.dispatch(this);
			}
		}
		
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
	}
}

