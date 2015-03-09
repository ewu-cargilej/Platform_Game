package com.gauntlet.objects.enemies
{
	import com.gauntlet.objects.player.Hero;
	import org.flixel.FlxObject;
	import org.flixel.FlxG;
	import org.flixel.FlxTilemap;
	import flash.utils.Timer;
    import flash.events.TimerEvent;	
	/**
	 * Spider enemy
	 * 
	 * @author Casey Sliger
	 */
	public class Spider extends BaseEnemy
	{
		[Embed(source = "../../../../../embeded_resources/Game_Screen/Enemies/Spider.png")] private static var ImgSpider:Class;
		[Embed(source = "../../../../../embeded_resources/SFX/SpiderDie.mp3")] private static var Die:Class;
		[Embed(source = "../../../../../embeded_resources/SFX/SpiderScuttle.mp3")] private static var Scuttle:Class;
		/* ---------------------------------------------------------------------------------------- */
		/** Reference to the hero. */
		private var _mcHero:	Hero;
		/** Reference to the map. */
		private var themap: FlxTilemap;
		/** Counts the number of frames for attack cooldown. */
		protected var	_nFrames: int = 0;
		/** Timer used for sounds. */
		protected var _tTimer: Timer = new Timer(1000);
		/**
		 * Constructs the Spider object.
		 * 
		 * @param	X				The initial X position of the sprite.
		 * @param	Y				The initial Y position of the sprite.
		 */
		public function Spider(X:Number=0,Y:Number=0)
		{
			super(X, Y, 60, 20, 3);
			_tTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			_tTimer.start();
			_tTimer.delay = int((Math.random() * 3000) + 3000);
			
			this.loadGraphic(ImgSpider, true, true, 32, 32);
			
			//bounding box tweaks
			this.width = 28;
			this.height = 30;
			this.offset.x = 2;
			this.offset.y = 1;
			
			//basic player physics
			this.drag.x = 2000;
			this.acceleration.y = 130;
			this.maxVelocity.x = 90;
			this.maxVelocity.y = 130;
			
			//animations
			this.addAnimation("idle", [0]);
			this.addAnimation("jump", [2]);
			this.addAnimation("walk", [3,1,4,1], 5);
		}
		/* ---------------------------------------------------------------------------------------- */
		/**
		 * Called every frame.
		 * Update the Enemy position and other stuff.
		 */
		override public function update():void
		{
			super.update();
			this.acceleration.x = 0;
			_nFrames++;
			if (_nFrames >= 60)
			{
			_nFrames = 0;	
			}	
			
			if (((_mcHero.x - this.x) <= -16 && (_mcHero.x - this.x) >= -160) && Math.abs(_mcHero.y - this.y) <= 160)//if the player is on the left
			{
				if (_nFrames >= -30)
				{
				this.play("walk");	
				}
				this.acceleration.x -= this.drag.x;
				this.facing = FlxObject.RIGHT;
				jump();
			
			}
			else if (((_mcHero.x - this.x) >= 28 && (_mcHero.x - this.x) <= 160) && Math.abs(_mcHero.y - this.y) <= 160)//if the player is on the right
			{
				if (_nFrames >= -30)
				{
				this.play("walk");	
				}
				this.acceleration.x += this.drag.x;
				this.facing = FlxObject.LEFT;
				jump();
				
			}
			else
			{
			this.play("idle");	
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
			
			if (themap.getTile(tileX - 1, tileY) != 0 && _mcHero.x < x && this.velocity.y == 0)//if stuck against tile
			{
				this.y -= 1;
				this.velocity.y = -130;
				this.play("jump");
				_nFrames = -60;
			}
			else if (themap.getTile(tileX + 1, tileY) != 0 && _mcHero.x > x && this.velocity.y == 0)//if stuck against tile
			{
				this.y -= 1;
				this.velocity.y = -130;
				this.play("jump");
				_nFrames = -60;
			}	
			else if (_mcHero.y < this.y && this.velocity.y == 0)//try to jump to a higher platform
			{
				this.y -= 1;
				this.velocity.y = -130;
				this.play("jump");
				_nFrames = -60;
			}
			
		}
		/* ---------------------------------------------------------------------------------------- */
		/**
		 * 
		 * plays sound
		 */
		private function timerHandler(e:TimerEvent):void
		{
		FlxG.play(Scuttle,0.5);
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

