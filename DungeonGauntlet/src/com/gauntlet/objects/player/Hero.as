package com.gauntlet.objects.player
{
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	
	/**
	 * The hero for the game.
	 * 
	 * @author Casey Sliger
	 */
	public class Hero extends FlxSprite
	{
		[Embed(source = "../../../../../embeded_resources/Game_Screen/Hero/Hero.png")] private static var ImgHero:Class;
		[Embed(source = "../../../../../embeded_resources/SFX/Jump.mp3")] private static var SoundJump:Class;
		[Embed(source = "../../../../../embeded_resources/SFX/Hero_Hit.mp3")] private static var HeroHit:Class;
		
		/* ---------------------------------------------------------------------------------------- */
		/** The hero's current maximum upgraded health. */
		private var _nMaxheath:	int;
		/**
		 * Constructs the Hero object.
		 * 
		 * @param	X				The initial X position of the sprite.
		 * @param	Y				The initial Y position of the sprite.
		 */
		public function Hero(X:Number=0,Y:Number=0)
		{
			super(X, Y);
			
			this.loadGraphic(ImgHero, true, true, 32);
			
			//at the beginning, health is 100
			this.health = 100;
			this._nMaxheath = this.health;
			
			//bounding box tweaks
			this.width = 16;
			this.height = 30;
			this.offset.x = 8;
			this.offset.y = 1;
			
			//basic player physics
			this.drag.x = 2000;
			this.acceleration.y = 500;
			this.maxVelocity.x = 120;
			this.maxVelocity.y = 500;
			
			//animations
			this.addAnimation("idle", [10]);
			this.addAnimation("run", [1, 2, 3, 4, 5, 6, 7, 8, 9], 12);
			this.addAnimation("jump", [2]);
		}
		
		/**
		 * Called every frame.
		 * Update the Hero's position and other stuff.
		 */
		override public function update():void
		{
			if (!FlxG.paused)
			{
				this.acceleration.x = 0;
				
				if(FlxG.keys.A)
				{
					this.facing = FlxObject.LEFT;
					this.acceleration.x -= this.drag.x;
				}
				else if(FlxG.keys.D)
				{
					this.facing = FlxObject.RIGHT;
					this.acceleration.x += this.drag.x;
				}
				if(FlxG.keys.justPressed("W") && this.velocity.y == 0)
				{
					this.y -= 1;
					this.velocity.y = -350;
					FlxG.play(SoundJump, .5, false);
				}
				
				//animate based on movement
				if(this.velocity.y != 0)
				{
					this.play("jump");
				}
				else if(this.velocity.x == 0)
				{
					this.play("idle");
				}
				else
				{
					this.play("run");
				}
				
				this.y = (this.y + this.height / 2) % FlxG.height - this.height / 2;
			}
		}
		/**
		 * Damage the hero and check if dead.
		 * 
		 * @param	Damage			Number of health to take away.
		 */
		override public function hurt(Damage:Number):void
		{
			super.hurt(Damage);
			FlxG.play(HeroHit, .5, false);
			
			//maybe add extra stuff later
		}
		
		public function increaseHealth():void 
		{
			this._nMaxheath += 20;
			this.health = this._nMaxheath;
		}
	}
}

