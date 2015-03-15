package com.gauntlet.runes

{
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;

	
	/**
	 * Creates a magicRune gun.
	 * 
	 * @author Nicholas Valetnine
	 */
	public class SharkRune extends Rune
	{
		[Embed(source = "../../../../embeded_resources/Game_Screen/Runes/Shark_Rune_Attack.png")] private static var SharkAttack:Class;
		[Embed(source = '../../../../embeded_resources/Game_Screen/Runes/Shark_Upgrade.png')]public static var SharkUpgrade:Class;
		[Embed(source = "../../../../embeded_resources/SFX/Shark_Bite.mp3")] private static var SharkShoot:Class;
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the IamAGun object.
		 */
		public function SharkRune($level:Number, X:Number, Y:Number, $parent:Rune = null, SimpleGraphic:Class=null)
		{
			super(X,Y);
			this.starting = new FlxPoint(X, Y);
			this.loadGraphic(SharkAttack, true, true, 64,22);
			
			this.allowCollisions
			if ($parent == null)
				fillValues($level);
			else
				copyParent($parent);
				
			this.health = nMyHealth;
			
			//this.width = 7;
			this.height = 7;
			//this.offset.x = 20;
			//this.offset.y = 11;
		}
		
		
		/**
		 * Parses an XML file for the data about the weapon
		 *
		 * @param	$curLevel	the current level that the player is on. used for potentially modifying weapon's starting stats. 
		 * @return			Describe the return value here.
		 */
		override public function fillValues($curLevel:int):void
		{
			this.nRate = .5;
			
			nMyHealth = 15000;
			this.nVelocity = 400 + (Math.random() * 300);
			
			calcDamage($curLevel);
			this.sName = "Shark Rune";
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
			var output:Rune = new SharkRune(0,this.x, this.y, this);
			return output;
		}
		/* ---------------------------------------------------------------------------------------- */
		override public function getUpgradeGraphic():Class
		{
			return SharkUpgrade;
		}
		
		override public function triggerAnimation():void
		{
			//this.play("Magic");
		}
		
		override public function kill():void
		{
			super.kill();
			FlxG.play(SharkShoot, .7, false);
		}
	}
}

