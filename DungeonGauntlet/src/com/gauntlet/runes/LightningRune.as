package com.gauntlet.runes

{
	import flash.display.Sprite;
	import org.flixel.FlxPoint;

	
	/**
	 * Creates a magicRune gun.
	 * 
	 * @author Nicholas Valetnine
	 */
	public class LightningRune extends Rune
	{
		//[Embed(source = "../../../../embeded_resources/Game_Screen/Upgrades/FPO_Elec.png")] private static var ElecBlast:Class;
		[Embed(source = '../../../../embeded_resources/Game_Screen/Runes/Elec_Upgrade.png')]public static var LightningUpgrade:Class;
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the IamAGun object.
		 */
		public function LightningRune(X:Number, Y:Number, $parent:Rune = null, SimpleGraphic:Class=null)
		{
			super(X,Y);
			this.starting = new FlxPoint(X, Y);
			//this.loadGraphic(ElecBlast, true, true, 32);
			
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
			this.nRate = .5 + Math.random() * .5;
			nMyHealth = 5000 + Math.random() * 10000;
			this.nVelocity = 500 + (Math.random() * 200);
			
			this.nDamage = 10 + Math.random() * 30;
			this.sName = "Lightning Rune";
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
			var output:Rune = new LightningRune(this.x, this.y, this);
			return output;
		}
		/* ---------------------------------------------------------------------------------------- */
		override public function getUpgradeGraphic():Class
		{
			return LightningUpgrade;
		}
		
		override public function triggerAnimation():void
		{
			this.play("Elec");
		}
	}
}