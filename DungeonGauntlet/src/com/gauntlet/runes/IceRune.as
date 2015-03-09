package com.gauntlet.runes

{
	import flash.display.Sprite;
	import org.flixel.FlxPoint;

	
	/**
	 * Creates a magicRune gun.
	 * 
	 * @author Nicholas Valetnine
	 */
	public class IceRune extends Rune
	{
		//[Embed(source = "../../../../embeded_resources/Game_Screen/Upgrades/FPO_ice.png")] private static var IceBlast:Class;
		[Embed(source = '../../../../embeded_resources/Game_Screen/Runes/Ice_Upgrade.png')]public static var IceUpgrade:Class;
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the IamAGun object.
		 */
		public function IceRune(X:Number, Y:Number, $parent:Rune = null, SimpleGraphic:Class=null)
		{
			super(X,Y);
			this.starting = new FlxPoint(X, Y);
			//this.loadGraphic(IceBlast, true, true, 32);
			
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
			this.nRate = .01 + Math.random() * .5;
			nMyHealth = 300 + Math.random() * 9000;
			this.nVelocity = 400 + (Math.random() * 300);
			
			this.nDamage = 10 + Math.random() * 30;
			this.sName = "Ice Rune";
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
			var output:Rune = new IceRune(this.x, this.y, this);
			return output;
		}
		/* ---------------------------------------------------------------------------------------- */
		override public function getUpgradeGraphic():Class
		{
			return IceUpgrade;
		}
		
		override public function triggerAnimation():void
		{
			this.play("Ice");
		}
	}
}