package com.gauntlet.runes

{
	import flash.display.Sprite;

	
	/**
	 * Creates a magicRune gun.
	 * 
	 * @author Nicholas Valetnine
	 */
	public class MagicRune extends Rune
	{
		[Embed(source = "../../../../embeded_resources/Game_Screen/Upgrades/testshot.png")] private static var ImgRuneTemp:Class;
		[Embed(source = '../../../../embeded_resources/Game_Screen/Upgrades/FPO_Rune.png')]public static var RuneUpgrade:Class;
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the IamAGun object.
		 */
		public function MagicRune(X:Number, Y:Number, $parent:Rune = null, SimpleGraphic:Class=null)
		{
			super(X,Y, SimpleGraphic);
			starting = new FlxPoint(X, Y);
			this.loadGraphic(ImgRuneTemp, true, true, 32);
			
			this.allowCollisions
			if ($parent == null)
				parseXML(0);
			else
				copyParent($parent);
				
			this.health = nMyHealth;
		}
		
		
		/**
		 * Parses an XML file for the data about the weapon
		 *
		 * @param	$curLevel	the current level that the player is on. used for potentially modifying weapon's starting stats. 
		 * @return			Describe the return value here.
		 */
		ovrerride public function parseXML($curLevel:int):void
		{
			//not currently used for parsing
			this.nDamage = Math.random() * 40;
			this.nRate = Math.random();
			nMyHealth = Math.random() * 15000;
			this.nVelocity = 400 + (Math.random() * 300);
			this.sName = "tester Magic Rune";
		}
		
		
		override private function copyParent($parent:Rune):void
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
		
		
	}
}

