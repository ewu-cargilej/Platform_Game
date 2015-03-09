package com.gauntlet.objects.enemies
{
	import com.gauntlet.objects.player.Hero;
	import flash.geom.Point;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxU;
	import org.flixel.FlxObject;
	
	/**
	 * Ghost enemy, final boss.
	 * 
	 * @author Casey Sliger
	 */
	public class Ghost extends BaseEnemy
	{
		[Embed(source = "../../../../../embeded_resources/Game_Screen/Enemies/Ghost.png")] private static var ImgGhost:Class;
		[Embed(source = "../../../../../embeded_resources/SFX/GhostDie.mp3")] private static var Die:Class;
		[Embed(source = "../../../../../embeded_resources/SFX/Whoosh.mp3")] private static var Whoosh:Class;
		[Embed(source = "../../../../../embeded_resources/SFX/GhostShort.mp3")] private static var GhostShort:Class;
		[Embed(source = "../../../../../embeded_resources/SFX/GhostLong.mp3")] private static var GhostLong:Class;
		/** Reference to the hero. */
		private var _mcHero:	Hero;
		/** Counts the number of frames. */
		protected var	_nFrames: int = 0;
		/** Counts the number of degrees. */
		protected var	_nDegree: int = 0;
		/** Attack damage. Different from contact damage. */
		protected var	_nAttackDamage	:int;
		/**every 10-15s change moves */
		protected var _nMaxMoveValue: int = int((Math.random() * 300) + 600);
		/** Stores a random number from 0-100, used for bat movement. */
		protected var	_nMoveValue: int = int(Math.random() * 100);
		/**checks to see if currently doing an action */
		protected var _bNotBusy: Boolean = true;
		/** Timer used for attacks. */
		protected var _tTimer: Timer = new Timer(17, 300);
		/** difference in x values of hero and ghost. */
		protected var _nXdiff: Number = 0;
		/** difference in y values of hero and ghost. */
		protected var _nYdiff: Number = 0;
		/** the attack angle used to target hero. */
		protected var _nAttackAngle: Number = 0;
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the Ghost object.
		 * 
		 * @param	X				The initial X position of the sprite.
		 * @param	Y				The initial Y position of the sprite.
		 */
		public function Ghost(X:Number=0,Y:Number=0)
		{
			super(X, Y, 280, 25, 11);
			
			this._nAttackDamage = 50;
			this.alpha = .5;
			_tTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			_tTimer.addEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
			
			//actual height in png is 46
			this.loadGraphic(ImgGhost, true, true, 64, 46);
			
			//bounding box tweaks
			this.width = 60;
			this.height = 44;
			this.offset.x = 2;
			this.offset.y = 1;
			
			//basic player physics
			this.drag.x = 0;
			this.acceleration.y = 0;
			this.maxVelocity.x = 350;
			this.maxVelocity.y = 350;
			
			//animations
			this.addAnimation("idle", [0]);
			this.addAnimation("attack", [1]);
			this.addAnimation("float", [2]);
		}
		
		/**
		 * Called every frame.
		 * Update the Enemy position and other stuff.
		 */
		override public function update():void
		{
			super.update();
			
			_nFrames++;
			if ((_nFrames >= _nMaxMoveValue) && !_bNotBusy)
			{
				_nFrames = 0;
			}
			if ((_nFrames > _nMaxMoveValue) && _bNotBusy)
			{
				_nMaxMoveValue = int((Math.random() * 300) + 600);
				_nFrames = 0;
				_bNotBusy = false;
				_tTimer.reset();
				attack();
			}
			if(_bNotBusy)
			{
				this.acceleration.x = 0;
				this.acceleration.y = 0;
				this.velocity.x = 0;
				this.velocity.y = 0;
			
				if (_nMoveValue >= 0 && _nMoveValue < 50)
				{
					this.play("idle");
					_nDegree++;
					if (_nDegree >= 360)
					{
					FlxG.play(GhostLong,0.5);
					_nDegree = 0;
					}
					if (_nDegree >=0 && _nDegree < 180)
					{
					this.facing = FlxObject.RIGHT;	
					}
					else if(_nDegree >= 180 && _nDegree < 360)
					{
					this.facing = FlxObject.LEFT;
					}
					this.x = (FlxG.width / 2) + 192 * Math.cos((_nDegree * Math.PI / 180));
					this.y = (FlxG.height / 2) + 192 * Math.sin((_nDegree * Math.PI / 180));
				}
				if (_nMoveValue >= 50 && _nMoveValue < 100)
				{
					this.play("float");
					if (_nFrames == 300 || _nFrames == 600)
					{
					this.y += FlxG.height / 4;
					FlxG.play(GhostShort,0.5);
					}
					if (_nFrames >= 300 && _nFrames < 600)
					{
					this.facing = FlxObject.RIGHT;
					this.x -= FlxG.width / 300;	
					}
					else
					{
					this.facing = FlxObject.LEFT;
					this.x += FlxG.width / 300;
					}
				}
			}
			

		}
		/* ---------------------------------------------------------------------------------------- */
		/**
		 * 
		 * gets the hero to target
		 */
		public function acquireTarget(hero:Hero):void 
		{
			_mcHero = hero;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		/**
		 * 
		 * monster attack function
		 */
		public function attack():void 
		{
			_tTimer.start();
			this.alpha = 1;
			_nXdiff = _mcHero.x - this.x;
			_nYdiff = _mcHero.y - this.y;
			_nAttackAngle = Math.atan2(_nYdiff , _nXdiff);
			setContact(_nAttackDamage);
			FlxG.play(Whoosh,0.5);
		}
		/* ---------------------------------------------------------------------------------------- */
		/**
		 * 
		 * targets the hero
		 */
		private function timerHandler(e:TimerEvent):void
		{
			this.play("attack");
			if (_nAttackAngle >= (Math.PI/2) && _nAttackAngle < (3*Math.PI/2))
			{
			this.facing = FlxObject.RIGHT;	
			}
			if (_nAttackAngle >= (3* Math.PI/2) || _nAttackAngle < (Math.PI/2))
			{
			this.facing = FlxObject.LEFT;	
			}
			this.acceleration.x = Math.cos(_nAttackAngle) * 350;
			this.acceleration.y = Math.sin(_nAttackAngle) * 350;
        }
		/* ---------------------------------------------------------------------------------------- */
		/**
		 * 
		 * completes attack phase
		 */
		private function completeHandler(e:TimerEvent):void 
		{
			this.alpha = .5;
			_bNotBusy = true;
			_nMoveValue = int(Math.random() * 100);
			this.x = FlxG.width / 300;
			this.y = FlxG.height / 4; 
			this.acceleration.x = 0;
			this.acceleration.y = 0;
			_nFrames = 0;
			setContact(25);
        }
		/**
		 * Damage the enemy and check if dead.
		 * 
		 * @param	Damage			Number of health to take away.
		 */
		override public function hurt(Damage:Number):void
		{
			if (this.alpha == 1)
			{
				super.hurt(Damage);
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
			_tTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
		}
	}
}

