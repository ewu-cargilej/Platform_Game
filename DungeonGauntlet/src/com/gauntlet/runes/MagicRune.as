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
		public function MagicRune(X:Number, Y:Number, $parent:Rune = null, SimpleGraphic:Class=null)
		{
			super(X,Y);
			this.starting = new FlxPoint(X, Y);
			//this.loadGraphic(MagicBlast, true, true, 32);
			
			this.allowCollisions
			if ($parent == null)
				fillValues(0);
			else
				copyParent($parent);
				
			this.health = nMyHealth;
			
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
		override public function fillValues($curLevel:int):void
		{
			this.nDamage = Math.random() * 40;
			this.nRate = Math.random();
			nMyHealth = Math.random() * 15000;
			this.nVelocity = 400 + (Math.random() * 300);
			this.sName = "tester Magic Rune";
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
			var output:Rune = new MagicRune(this.x, this.y, this);
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

