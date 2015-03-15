package com.gauntlet.objects.enemies
{
	import flash.utils.Timer;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	import com.gauntlet.objects.player.Hero;
	/**
	 * Bat enemy.
	 * 
	 * @author Casey Sliger
	 */
	public class Bat extends BaseEnemy
	{
		[Embed(source = "../../../../../embeded_resources/Game_Screen/Enemies/Bat.png")] private static var ImgBat:Class;
		[Embed(source = "../../../../../embeded_resources/SFX/BatDie.mp3")] private static var Die:Class;
		[Embed(source = "../../../../../embeded_resources/SFX/BatFlap.mp3")] private static var Flap:Class;
		/** Counts the number of frames. */
		protected var	_nFrame: int = 60;
		/** Stores a random number from 0-100, used for bat movement. */
		protected var	_nMoveValue: int = 0;
		/** Timer used for sounds. */
		protected var _tTimer: Timer = new Timer(1000);
		/** Reference to the hero. */
		private var _mcHero:	Hero;
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the Bat object.
		 * 
		 * @param	X				The initial X position of the sprite.
		 * @param	Y				The initial Y position of the sprite.
		 */
		public function Bat(X:Number=0,Y:Number=0)
		{
			super(X, Y, 50, 20, 1);
			_tTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			_tTimer.start();
			_tTimer.delay = int((Math.random() * 3000) + 3000);
			
			this.loadGraphic(ImgBat, true, true, 64, 32);
			
			//bounding box tweaks
			this.width = 60;
			this.height = 30;
			this.offset.x = 2;
			this.offset.y = 1;
			
			//basic player physics
			this.drag.x = 60;
			this.acceleration.y = 0;
			this.maxVelocity.x = 60;
			this.maxVelocity.y = 30;
			this.drag.y = 30;
			
			//animations
			this.addAnimation("fly", [0,1],4);
		}
		
		/**
		 * Called every frame.
		 * Update the Enemy position and other stuff.
		 */
		override public function update():void
		{
			super.update();
			this.acceleration.x = 0;
			this.acceleration.y = 0;
			this.play("fly");
			_nFrame++;
			if (_nFrame >= 20)//every 20 frames get a new move value
			{
			_nFrame = 0;
			_nMoveValue = int(Math.random() * 100);
			}
			if (_nMoveValue>=0 && _nMoveValue<10)//move left
			{
				if (this.x<=64)//dont go off screen
				{
				this.acceleration.x += this.drag.x;
				}
				else
				{
				this.acceleration.x -= this.drag.x;	
				}
			}
			if (_nMoveValue>=10 && _nMoveValue<20)//move right
			{
				if (this.x>=(FlxG.width-64-this.width))//dont go off screen
				{
				this.acceleration.x -= this.drag.x;	
				}
				else
				{
				this.acceleration.x += this.drag.x;	
				}
			}
			if (_nMoveValue>=20 && _nMoveValue<30)//move up
			{
				if (this.y<=64)//dont go off screen
				{
				this.acceleration.y += this.drag.y;	
				}
				else
				{
				this.acceleration.y -= this.drag.y;	
				}	
			}
			if (_nMoveValue>=30 && _nMoveValue<40)//move down
			{
				if (this.y>=(FlxG.height-128-this.height))//dont go off screen
				{
				this.acceleration.y -= this.drag.y;		
				}
				else
				{
				this.acceleration.y += this.drag.y;		
				}
			}
			if (_nMoveValue>=40 && _nMoveValue<50)//move up right
			{
				if ((this.x>=(FlxG.width-64-this.width)) || (this.y<=64))//dont go off screen
				{
				this.acceleration.x -= this.drag.x;	
				this.acceleration.y += this.drag.y;
				}
				else
				{
				this.acceleration.x += this.drag.x;	
				this.acceleration.y -= this.drag.y;	
				}
			}
			if (_nMoveValue>=50 && _nMoveValue<60)//move down right
			{
				if ((this.x>=(FlxG.width-64-this.width)) || (this.y>=(FlxG.height-128-this.height)))//dont go off screen
				{
				this.acceleration.x -= this.drag.x;	
				this.acceleration.y -= this.drag.y;
				}
				else
				{
				this.acceleration.x += this.drag.x;	
				this.acceleration.y += this.drag.y;	
				}
			}
			if (_nMoveValue>=60 && _nMoveValue<70)//move up left
			{
				if ((this.y<=64) || (this.x<=64))//dont go off screen
				{
				this.acceleration.x += this.drag.x;	
				this.acceleration.y += this.drag.y;	
				}
				else
				{
				this.acceleration.x -= this.drag.x;	
				this.acceleration.y -= this.drag.y;	
				}
			}
			if (_nMoveValue>=70 && _nMoveValue<80)//move down left
			{
				if ((this.x<=64) || (this.y>=(FlxG.height-128-this.height)))//dont go off screen
				{
				this.acceleration.x += this.drag.x;	
				this.acceleration.y -= this.drag.y;
				}
				else
				{
				this.acceleration.x -= this.drag.x;	
				this.acceleration.y += this.drag.y;	
				}
			}
			if (_nMoveValue>=80 && _nMoveValue<90)//move same direction
			{
				if (this.acceleration.x < 0)//going left
				{
					if (this.x<=64)//dont go off screen
					{
					this.acceleration.x += this.drag.x;
					}
					else
					{
					this.acceleration.x -= this.drag.x;	
					}	
				}
				if (this.acceleration.x > 0)//going right
				{
					if (this.x>=(FlxG.width-64-this.width))//dont go off screen
					{
					this.acceleration.x -= this.drag.x;	
					}
					else
					{
					this.acceleration.x += this.drag.x;	
					}
				}
				if (this.acceleration.y < 0)//going up
				{
					if (this.y<=64)//dont go off screen
					{
					this.acceleration.y += this.drag.y;	
					}
					else
					{
					this.acceleration.y -= this.drag.y;	
					}	
				}
				if (this.acceleration.y > 0)//going down
				{
					if (this.y>=(FlxG.height-128-this.height))//dont go off screen
					{
					this.acceleration.y -= this.drag.y;		
					}
					else
					{
					this.acceleration.y += this.drag.y;		
					}
				}
			}
			if (_nMoveValue >= 90 && _nMoveValue < 100)//move towards player
			{
				if (_mcHero.x - this.x < 0)//player left
				{
					if (this.x<=64)//dont go off screen
					{
					this.acceleration.x += this.drag.x;
					}
					else
					{
					this.acceleration.x -= this.drag.x;	
					}
				}
				if (_mcHero.x - this.x > 0)//player right
				{
					if (this.x>=(FlxG.width-64-this.width))//dont go off screen
					{
					this.acceleration.x -= this.drag.x;	
					}
					else
					{
					this.acceleration.x += this.drag.x;	
					}
				}
				if (_mcHero.y - this.y < 0)//player up
				{
					if (this.y<=64)//dont go off screen
					{
					this.acceleration.y += this.drag.y;	
					}
					else
					{
					this.acceleration.y -= this.drag.y;	
					}				
				}
				if (_mcHero.y - this.y > 0)//player down
				{
					if (this.y>=(FlxG.height-128-this.height))//dont go off screen
					{
					this.acceleration.y -= this.drag.y;		
					}
					else
					{
					this.acceleration.y += this.drag.y;		
					}
				}
			}
		}
		/* ---------------------------------------------------------------------------------------- */
		/**
		 * 
		 * gets the hero to target, and the map to check position
		 */
		public function acquireTarget(hero:Hero):void 
		{
			_mcHero = hero;
		}
		/* ---------------------------------------------------------------------------------------- */
		/**
		 * 
		 * plays sound
		 */
		private function timerHandler(e:TimerEvent):void
		{
			if (FlxG.paused == false)
			{
				FlxG.play(Flap, 0.5);
			}
        }
		/**
		 * kill enemy
		 * 
		 */
		override public function kill():void
		{
			super.kill();
			_tTimer.stop();
			FlxG.play(Die, 0.75);
			_tTimer.removeEventListener(TimerEvent.TIMER, timerHandler);
		}
		
	}
}

