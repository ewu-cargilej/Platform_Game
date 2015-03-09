package com.gauntlet.runes

{
	import flash.display.Sprite;
	import org.flixel.FlxPoint;

	
	/**
	 * Creates a magicRune gun.
	 * 
	 * @author Nicholas Valetnine
	 */
	public class FireRune extends Rune
	{
		//[Embed(source = "../../../../embeded_resources/Game_Screen/Upgrades/FPO_Fire.png")] private static var FireBlast:Class;
		[Embed(source = '../../../../embeded_resources/Game_Screen/Runes/Fire_Upgrade.png')]public static var FireUpgrade:Class;
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the rune object.
		 */
		public function FireRune(X:Number, Y:Number, $parent:Rune = null, SimpleGraphic:Class=null)
		{
			super(X,Y);
			this.starting = new FlxPoint(X, Y);
			//this.loadGraphic(FireBlast, true, true, 32);
			
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
			this.nRate = .01 + Math.random();
			nMyHealth = 300 + Math.random() * 12000;
			this.nVelocity = 400 + (Math.random() * 100);
			
			this.nDamage = 10 + Math.random() * 50;
			this.sName = "Fire Rune";
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
			var output:Rune = new FireRune(this.x, this.y, this);
			return output;
		}
		/* ---------------------------------------------------------------------------------------- */
		override public function getUpgradeGraphic():Class
		{
			return FireUpgrade;
		}
		
		override public function triggerAnimation():void
		{
			this.play("Fire");
		}
	}
}