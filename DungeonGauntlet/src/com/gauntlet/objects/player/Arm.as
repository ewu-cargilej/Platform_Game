package com.gauntlet.objects.player
{
	import com.gauntlet.runes.MagicRune;
	import com.gauntlet.runes.Rune;
	import flash.display.Sprite;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor
	import flash.automation.MouseAutomationAction;
	import flash.display.DisplayObject;
	import org.flixel.FlxTimer;
	import org.flixel.FlxU;
	import org.osflash.signals.Signal;
	
	
	/**
	 * arm object that interacts with the mouse
	 * 
	 * @author Nicholas Valetnine
	 */
	public class Arm extends FlxSprite
	{
		[Embed(source = "../../../../../embeded_resources/Game_Screen/Hero/HeroArmSprite.png")] private static var ImgArmReal:Class;
		[Embed(source = "../../../../../embeded_resources/SFX/Shoot.mp3")] private static var SoundShoot:Class;
		public var aimAngle:Number = 0;
		private var runeIndex:Number = 0;
		public var runes:Array = new Array();
		public var runeGroup :FlxGroup;
		private var rune :Rune;
		private var angleAdjustX:Number = 0;
		private var angleAdjustY:Number = 0;
		public var addRuneSignal :Signal = new Signal();
		private var shotTimer :FlxTimer = new FlxTimer();
		private var canFire :Boolean;
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the Arm object.
		 */
		public function Arm(X:Number=0,Y:Number=0,SimpleGraphic:Class=null)
		{
			super(X - 4.25, Y + 12, SimpleGraphic);
			this.loadGraphic(ImgArmReal, true, true, 22,6);
			canFire = true;
			for (var i:uint = 0; i < 10; i++)
			{
				runes[i] = new Rune(this.x, this.y);
			}
			//runeGroup.members = runes;
			//load up rune array
		}
		
		public function changeFire(Timer:FlxTimer):void
		{
			this.canFire = true;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function loadRune(newrune:Rune):void
		{
			for (var i:uint = 0; i < 10; i++)
			{
				runes[i] = newrune.clone();
			}
		}
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * sets the angle of the arm
		 * @author Chevy Ray Johnston
		 * @author Adam 'Atomic' Saltsman
		 */
		private function setAimAngle():void
		{
			var mouse: FlxPoint = new FlxPoint(FlxG.mouse.x - (x + (width / 2)), (FlxG.mouse.y - (y + (height / 2))));
			var header: FlxPoint = new FlxPoint(this.x + 100 - (x + (width / 2)) - 80, this.y - (y + (height / 2)) + 13);
			
			this.aimAngle = FlxU.getAngle(header, mouse) - 90;
		}
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Called every frame.
		 * Update the arms's rotation and other stuff.
		 */
		override public function update():void
		{
			super.update();
			setAimAngle();
			this.angle = aimAngle;
			
			if (FlxG.mouse.justPressed() && canFire)
			{
				fireBullet(this.x, this.y, this.angle);
				this.canFire = false;
				shotTimer.start(runes[runeIndex].Rate, 1, changeFire);
				
				FlxG.play(SoundShoot, .5, false);
			}
		}
		
		private function fireBullet(x:Number, y:Number, dFireAngle:Number):void
		{
			var b:FlxSprite = runes[runeIndex];	//Figure out which bullet to fire
			b.revive();
			//var b:FlxSprite = new Rune(rune.myVelocity, rune.x,rune.y);
			var rFireAngle:Number; //create a variable for the angle in radians (required for velocity calculations because they don't work with degrees)
			b.reset(x - 3, y - 8); //this puts the bullets in the middle of the PlayerUpper sprite, but you may not want the shots to originate from here (or change it depending on the angle, much like the animations above)
			b.angle = dFireAngle; //if your bullet shape doesn't need to be rotated (such as a circle) then remove this line to speed up the rendering
			rFireAngle = (dFireAngle * (Math.PI / 180)); //convert the fire angle from degrees into radians and apply that value to the radian fire angle variable
			b.velocity.x = Math.cos(rFireAngle) * runes[runeIndex].myVelocity; //calculate a velocity along the x axis, multiply the result by our diagonalVelocity (just 100 here).
			b.velocity.y = Math.sin(rFireAngle) * runes[runeIndex].myVelocity; //calculate a velocity along the y axis, ditto.
			runeIndex++;							//Increment our bullet list tracker,
			addRuneSignal.dispatch(b);
			if(runeIndex >= runes.length)		//and check to see if we went over,
				runeIndex = 0;	
		}
	}
}