package com.gauntlet.runes

{
	import flash.display.Sprite;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;

	
	/**
	 * Creates a magicRune gun.
	 * 
	 * @author Nicholas Valetnine
	 */
	public class MagicRune extends Rune
	{
		//[Embed(source = "../../../../embeded_resources/Game_Screen/Upgrades/FPO_Magic.png")] private static var MagicBlast:Class;
		[Embed(source = '../../../../embeded_resources/Game_Screen/Runes/Magic_Upgrade.png')]public static var MagicUpgrade:Class;
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the IamAGun object.
		 */
		public function MagicRune($level:Number, X:Number, Y:Number, $parent:Rune = null, SimpleGraphic:Class=null)
		{
			super(X,Y);
			this.starting = new FlxPoint(X, Y);
			//this.loadGraphic(MagicBlast, true, true, 32);
			
			this.allowCollisions
			if ($parent == null)
				fillValues($level);
			else
				copyParent($parent);
				
			this.health = nMyHealth;
			
			this.width = 7;
			this.height = 7;
			this.offset.x = 20;
			this.offset.y = 15;
		}
		
		
		/**
		 * Parses an XML file for the data about the weapon
		 *
		 * @param	$curLevel	the current level that the player is on. used for potentially modifying weapon's starting stats. 
		 * @return			Describe the return value here.
		 */
		override public function fillValues($curLevel:int):void
		{
			if ($curLevel < 50)
				this.nRate = ((40 - $curLevel) + Math.random() * (60 - $curLevel)) * .01;
			else
				this.nRate = .1;
			
			nMyHealth = 500 + Math.random() * (10000 + ($curLevel * 10));
			this.nVelocity = 400 + (Math.random() * 300);
			
			calcDamage($curLevel);
			this.sName = "Magic Rune";
		}
		
		
		private function copyParent($parent:Rune):void
		{
			this.nDamage = $parent.Damage;
			this.nRate = $parent.Rate;
			nMyHealth = $parent.health;
			this.nVelocity = $parent.myVelocity;
			this.sName = $parent.Name;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		override public function clone():Rune
		{
			var output:Rune = new MagicRune(0,this.x, this.y, this);
			return output;
		}
		/* ---------------------------------------------------------------------------------------- */
		override public function getUpgradeGraphic():Class
		{
			return MagicUpgrade;
		}
		
		override public function triggerAnimation():void
		{
			this.play("Magic");
		}
	}
}

