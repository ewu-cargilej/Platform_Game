package com.gauntlet.runes

{
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
		public function IceRune($level:Number, X:Number, Y:Number, $parent:Rune = null, $isParent:Boolean = true, SimpleGraphic:Class=null)
		{
			super(0, X, Y);
			this.starting = new FlxPoint(X, Y);
			
			if ($parent == null)
				fillValues(0);
			else if ($isParent)
				copyParent($parent);
			else
				beatPrior($level, $parent);
				
			this.health = nMyHealth;
			
			this.width = 24;
			this.height = 16;
			this.offset.x = 8;
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
			var output:Rune = new IceRune(0, this.x, this.y, this);
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