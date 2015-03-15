package com.gauntlet.objects.enemies
{
	import com.gauntlet.objects.player.Hero;
	import org.flixel.FlxObject;
	import org.flixel.FlxG;
	import org.flixel.FlxTilemap;
	import flash.utils.Timer;
    import flash.events.TimerEvent;		
	/**
	 * Lumberer enemy
	 * 
	 * @author Casey Sliger
	 */
	public class Lumberer extends BaseEnemy
	{
		[Embed(source = "../../../../../embeded_resources/Game_Screen/Enemies/Lumberer.png")] private static var ImgLumberer:Class;
		[Embed(source = "../../../../../embeded_resources/SFX/LumbererDie.mp3")] private static var Die:Class;
		[Embed(source = "../../../../../embeded_resources/SFX/BigFoot.mp3")] private static var Step:Class;
		/** Attack damage. Different from contact damage. */
		protected var	_nAttackDamage	:int;
		/** Counts the number of frames for attack cooldown. */
		protected var	_nFrames: int = 0;
		/** Counts the number of frames for jumping down. */
		protected var	_nDownFrames: int = 0;
		/** Timer used for sounds. */		
		protected var _tTimer: Timer = new Timer(1000);
		/* ---------------------------------------------------------------------------------------- */
		/** Reference to the hero. */
		private var _mcHero:	Hero;
		/** Reference to the map. */
		private var themap: FlxTilemap;
		/**
		 * Constructs the Lumberer object.
		 * 
		 * @param	X				The initial X position of the sprite.
		 * @param	Y				The initial Y position of the sprite.
		 */
		public function Lumberer(X:Number=0,Y:Number=0)
		{
			super(X, Y, 120, 25, 5);
			_tTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			_tTimer.start();
			_tTimer.delay = int((Math.random() * 3000) + 3000);
			this._nAttackDamage = 40;
			
			this.loadGraphic(ImgLumberer, true, true, 64, 64);
			
			//bounding box tweaks
			this.width = 60;
			this.height = 62;
			this.offset.x = 2;
			this.offset.y = 1;
			
			//basic player physics
			this.drag.x = 2000;
			this.acceleration.y = 90;
			this.maxVelocity.x = 45;
			this.maxVelocity.y = 130;
			
			//animations
			this.addAnimation("idle", [0]);
			this.addAnimation("walk", [1, 2, 3, 4, 5], 2);
			this.addAnimation("swing", [6, 7, 8, 9], 4);
		}
		
		/**
		 * Called every frame.
		 * Update the Enemy position and other stuff.
		 */
		override public function update():void
		{
			super.update();
			
			if (FlxG.paused == false)
			{
			if (_nFrames >= -30 && _nFrames <= 0)
			{
			this.play("idle");
			setContact(25);
			}
			else if(_nFrames >= 0) 
			{
			this.play("walk");	
			}
			//this.acceleration.x = 0;
			_nFrames++;
			if (_nFrames >= 60)
			{
			_nFrames = 0;	
			}	
			if ((_mcHero.x - this.x) <= -16)//if the player is on the left
			{
				this.acceleration.x = (-1 * this.drag.x);
				this.facing = FlxObject.RIGHT;
				jump();
				if ((_mcHero.x - this.x) >= -48 && ((this.y- _mcHero.y) <= 0 && (this.y- _mcHero.y) >= -33) && _nFrames >= 0)//if the player is on the left and ready to be attacked
				{
					this.play("swing");
					setContact(_nAttackDamage);
					this.maxVelocity.x = 90;
					_nFrames = -60;
				}
			}
			if ((_mcHero.x - this.x) >= 60)//if the player is on the right
			{
				this.acceleration.x = this.drag.x;
				this.facing = FlxObject.LEFT;
				jump();
				if ((_mcHero.x - this.x) <= 92 && ((this.y- _mcHero.y) <= 0 && (this.y- _mcHero.y) >= -33) && _nFrames >= 0)//if the player is on the right and ready to be attacked
				{
					this.play("swing");
					setContact(_nAttackDamage);
					this.maxVelocity.x = 90;
					_nFrames = -60;
				}
			}
			if (((_mcHero.x - this.x) >= -32 && (_mcHero.x - this.x) <= 76) || ((_mcHero.x - this.x) >= 96 || (_mcHero.x - this.x) <= -52))//make sure the swing speed doesn't last forever
			{
				this.maxVelocity.x = 45;
			}
			if ((((_mcHero.x - this.x) >= -16) && ((_mcHero.x - this.x) <= 60)) && (_mcHero.y - this.y) > 32)//unstick the lumberer or jump down to hero
			{
				this.immovable = true;
			}
			else
			{
				this.immovable = false;
			}
			}
		}
		/* ---------------------------------------------------------------------------------------- */
		/**
		 * 
		 * gets the hero to target, and the map to check position
		 */
		public function acquireTarget(hero:Hero, map: FlxTilemap):void 
		{
			_mcHero = hero;
			themap = map;
		}
		/* ---------------------------------------------------------------------------------------- */
		/**
		 * 
		 * checks to see if it is appropriate to jump
		 */
		private function jump():void
		{
			var tileX:uint = this.x / 32;
			var tileY:uint = this.y / 32;
			var tileY2:uint = (this.y + 32) / 32;
			
			if (themap.getTile(tileX - 1, tileY) != 0 && _mcHero.x < x && this.velocity.y == 0)//if stuck against tile
			{
				this.y -= 1;
				this.velocity.y = -350;
			}
			else if (themap.getTile(tileX + 2, tileY) != 0 && _mcHero.x > x && this.velocity.y == 0)//if stuck against tile
			{
				this.y -= 1;
				this.velocity.y = -350;
			}	
			else if (themap.getTile(tileX - 1, tileY2) != 0 && _mcHero.x < x && this.velocity.y == 0)//if stuck against tile
			{
				this.y -= 1;
				this.velocity.y = -350;
			}
			else if (themap.getTile(tileX + 2, tileY2) != 0 && _mcHero.x > x && this.velocity.y == 0)//if stuck against tile
			{
				this.y -= 1;
				this.velocity.y = -350;
			}	
			else if (_mcHero.y < this.y && this.velocity.y == 0)//try to jump to a higher platform
			{
				this.y -= 1;
				this.velocity.y = -350;	
			}
			
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
			FlxG.play(Step, 0.5);
			}
        }
		/**
		 * kill enemy
		 * 
		 */
		override public function kill():void
		{
			super.kill();
			FlxG.play(Die, 0.75);
			_tTimer.stop();
			_tTimer.removeEventListener(TimerEvent.TIMER, timerHandler);
		}
	}
}

