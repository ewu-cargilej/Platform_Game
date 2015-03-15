package com.gauntlet.objects.player
{
	import com.gauntlet.runes.MagicRune;
	import com.gauntlet.runes.Rune;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
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
		private var rune :Rune;
		
		private var runeIndex :int;
		private var runeArray	:Array = new Array();
		/** Group of all the runes that appear */
		public var runeGroup		:FlxGroup;
		
		public var addRuneSignal :Signal = new Signal();
		public var removeRuneSignal :Signal = new Signal();
		public var removeGroupSignal :Signal = new Signal();
		public var addGroupSignal	:Signal = new Signal();
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
			rune = new Rune(this.x, this.y);
			
			rune = new MagicRune(0, rune.x, rune.y, rune);
		}
		/**
		 * removes a rune from the group
		 */
		private function removeRune($rune:FlxSprite):void 
		{
			this.removeRuneSignal.dispatch($rune);
		}
		
		public function changeFire(Timer:FlxTimer):void
		{
			this.canFire = true;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function loadRune($newRune:Rune):void
		{
			//this.removeGroupSignal.dispatch();
			rune = $newRune;
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
			if (!FlxG.paused)
			{
				super.update();
				setAimAngle();
				this.angle = aimAngle;
				
				if (FlxG.mouse.pressed() && canFire)
				{
					fireBullet(this.x, this.y, this.angle);
					this.canFire = false;
					shotTimer.start(rune.Rate, 1, changeFire);
					rune.playSound();
				}
			}
		}
		
		private function fireBullet(x:Number, y:Number, dFireAngle:Number):void
		{
			//var b:FlxSprite = runeArray[runeIndex];
			var b:Rune = rune.clone();
			var rFireAngle:Number; //create a variable for the angle in radians (required for velocity calculations because they don't work with degrees)
			b.revive();
			b.reset(x, y); //this puts the bullets in the middle of the PlayerUpper sprite, but you may not want the shots to originate from here (or change it depending on the angle, much like the animations above)
			b.angle = dFireAngle; //if your bullet shape doesn't need to be rotated (such as a circle) then remove this line to speed up the rendering
			rFireAngle = (dFireAngle * (Math.PI / 180)); //convert the fire angle from degrees into radians and apply that value to the radian fire angle variable
			b.velocity.x = Math.cos(rFireAngle) * rune.myVelocity; //calculate a velocity along the x axis, multiply the result by our diagonalVelocity (just 100 here).
			b.velocity.y = Math.sin(rFireAngle) * rune.myVelocity; //calculate a velocity along the y axis, ditto.
			b.nVelocityX = b.velocity.x;
			b.nVelocityY = b.velocity.y;
			
			b.triggerAnimation();
			this.addRuneSignal.dispatch(b);
		/*	runeIndex++;
			if (runeIndex > runeArray.length)
				runeIndex = 0;
		*/
		}
		
		public function tileCollision(Object1:FlxObject,Object2:FlxObject):void
		{
			Object1.kill();
		}
		
		public function get myRune():Rune
		{
			return this.rune;
		}
	}
}