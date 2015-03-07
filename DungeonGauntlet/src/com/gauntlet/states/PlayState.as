package com.gauntlet.states
{
	import com.gauntlet.objects.enemies.BaseEnemy;
	import com.gauntlet.objects.enemies.Bat;
	import com.gauntlet.objects.enemies.Ghost;
	import com.gauntlet.objects.enemies.Lumberer;
	import com.gauntlet.objects.enemies.Spider;
	import com.gauntlet.objects.items.ItemManager;
	import com.gauntlet.objects.player.Arm;
	import com.gauntlet.objects.player.Hero;
	import com.gauntlet.runes.Rune;
	import com.gauntlet.runes.UpgradeManager;
	import flash.events.AVLoadInfoEvent;
	import org.flixel.*;
	import org.flixel.system.FlxTile;

	/**
	 * Play state.
	 * Gameplay
	 * 
	 * @author Casey Sliger
	 */
	public class PlayState extends FlxState
	{
		[Embed(source = '../../../../embeded_resources/Game_Screen/Level_Building/Tiles.png')]private static var Tiles:Class;
		[Embed(source = '../../../../embeded_resources/Game_Screen/Maps/empty_map.txt', mimeType = 'application/octet-stream')]private static var EmptyMap:Class;
		
		[Embed(source = '../../../../embeded_resources/Music/Play.mp3')]private static var MusicPlay:Class;
		[Embed(source = '../../../../embeded_resources/Music/Boss.mp3')]private static var MusicBoss:Class;
		
		/** Level Complete flag. */
		protected var	_bLevelComplete	:Boolean;
		
		/** Map for level generation */
		protected var levelMap			:FlxTilemap;
		
		/** Player. */
		protected var mcHero			:Hero;
		
		/** Arm of player*/
		protected var mcArm				:Arm;
		
		/** All enemies on the screen. */
		protected var _enemyGroup		:FlxGroup;
		
		/** Group of all the runes that appear */
		protected var _runeGroup		:FlxGroup;
		
		/** Group of all collidable items */
		protected var _collectibleGroup	:FlxGroup;
		
		/** a text of the text added to screen for upgrades*/
		protected var _onScreenText		:FlxGroup;
		
		/** Show current health. */
		protected var _txtHealth		:FlxText;
		
		/**	Show current score. */
		protected var _txtScore			:FlxText;
		
		/** the current score of the game */
		protected var _numScore			:Number;
		
		/**	Show current rune. */
		protected var _txtRune			:FlxText;
		
		/** Current level number. */
		protected var _nLevelNumber		:int;
		
		/** Manages all the items that appear on screen */
		protected var	_iManager		:ItemManager;
		
		/**
		 * Set up the state.
		 */
		override public function create():void
		{
			FlxG.playMusic(MusicPlay);
			
			FlxG.mouse.show();
			
			this._bLevelComplete = false;
			this._nLevelNumber = 1;
			
			establishGroups();
			
			add(_enemyGroup);
			
			setupPlayer(32, 640);
			
			_iManager.newRuneSignal.add(upgrade);
			_iManager.spawnObjectSignal.add(addCollectible);
			_iManager.upgradeHealthSignal.add(upgrade);
			_iManager.removeObjectSignal.add(removeCollectible);
			
			
			levelMap = new FlxTilemap();
			this.generateRoomTiles(true);
			this.placeEnemies();
			
			this._numScore = 0;
			var intScore:int = int(this._numScore);
			
			_txtHealth = new FlxText(64, FlxG.height - 48, 150, "HP: " + this.mcHero.health);
			_txtHealth.size = 24;
			add(_txtHealth);
			
			_txtScore = new FlxText(FlxG.width/2 - 64, FlxG.height - 48, 150, "Score: " + intScore);
			_txtScore.size = 24;
			add(_txtScore);
			
			_txtRune = new FlxText(FlxG.width - 192, FlxG.height - 48, 150, "Rune:");
			_txtRune.size = 24;
			add(_txtRune);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * establishes all groups so they are non-null
		 */
		public function establishGroups():void
		{
			this._enemyGroup = new FlxGroup();
			this._runeGroup = new FlxGroup();
			this._collectibleGroup = new FlxGroup();
			this._onScreenText = new FlxGroup();
			_iManager = new ItemManager();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Called every frame.
		 */
		override public function update():void
		{
			super.update();
			
			if (FlxG.keys.justPressed("K"))
			{
				//this._bLevelComplete = true;
				this._enemyGroup.kill();
			}
			
			if (_enemyGroup.countLiving() == 0 && !this._bLevelComplete)
			{
				
				this._enemyGroup.clear();
				this._bLevelComplete = true;
				_iManager.spawnUpgrade();
			}
			
			if (this._bLevelComplete)
			{
				//open door
				this.levelMap.setTile(levelMap.widthInTiles - 1, levelMap.heightInTiles - 2, 0);
			}
			
			FlxG.collide(mcHero, levelMap);
			
			FlxG.collide(_enemyGroup, levelMap)
			
			FlxG.overlap(mcHero, _enemyGroup, collideDamage);
			
			FlxG.overlap(_runeGroup, _enemyGroup, enemyDamage);
			
			FlxG.collide(_runeGroup, levelMap, mcArm.tileCollision);
			
			FlxG.collide(mcHero, _collectibleGroup, _iManager.collect);
			
			FlxG.collide(_collectibleGroup, levelMap);
			
			alignArm();
			
			wrap();
		}
		
		/**
		 * updates the arm so that it's in proper alignment with the hero
		 */
		private function alignArm():void 
		{
			if (mcArm.x - 3.5 != mcHero.x)
			{
				mcArm.x  = mcHero.x - 3.5;
			}
			if (mcArm.y + 11 != mcHero.y)
			{
				mcArm.y = mcHero.y + 11;
			}
			
		}
		
		private function enemyDamage($rune:Rune, $enemy:BaseEnemy):void 
		{
			$enemy.hurt($rune.Damage);
			$rune.kill();
			if (!$enemy.alive)
			{
				_iManager.spawnCollectible($enemy);
			}
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Hero takes damage and is immune until flicker is finished.
		 */
		private function collideDamage($hero:Hero,$enemy:BaseEnemy):void
		{
			if (!$hero.flickering)
			{
				$hero.flicker();
				$hero.hurt($enemy.getContact());
				
				this._txtHealth.text = "HP: " + this.mcHero.health;
			}
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Initially create and place the hero.
		 * 
		 * @param $spawnX
		 * @param $spawnY
		 */
		protected function setupPlayer($spawnX:int, $spawnY:int):void
		{
			mcHero = new Hero($spawnX, $spawnY);
			
			add(mcHero);
			
			mcArm = new Arm(mcHero.x, mcHero.y);
			
			add(mcArm);
			
			mcArm.addRuneSignal.add(addRune);
			mcArm.removeRuneSignal.add(removeRune);
			
			mcArm.loadRune(new Rune(FlxG.width / 2 - 16, 640));			
		}
		
		/**
		 * adds a rune to the rune group and the screen
		 * @param	$rune
		 */
		private function addRune($rune:FlxSprite):void 
		{
			add($rune);
			this._runeGroup.add($rune);
		}
		
		/**
		 * removes a rune from the screen and group
		 * @param	$rune
		 */
		private function removeRune($rune:FlxSprite):void
		{
			remove($rune);
			this._runeGroup.remove($rune);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * adds collectibles to the screen and the group
		 * @param	$obj
		 */
		private function addCollectible($obj:FlxSprite):void 
		{
			add($obj);
			this._collectibleGroup.add($obj);
		}
		
		private function removeCollectible($obj:FlxSprite, $value:Number):void 
		{
			remove($obj);
			this._collectibleGroup.remove($obj);
			
			this._numScore += $value;
			var intScore:int = int(this._numScore);
			this._txtScore.text = "Score: " + intScore;
			this._txtScore.text = "COIN GRABBED";
		}
		
		private function upgrade(runeUpgrade:FlxSprite, healthUpgrade:FlxSprite, newRune:Rune = null):void
		{
			if (newRune != null)
			{
				mcArm.loadRune(newRune);
			}
			else
			{
				mcHero.increaseHealth();
				this._txtHealth.text = "HP: " + this.mcHero.health;
			}
			
			remove(runeUpgrade);
			remove(healthUpgrade);
			this._collectibleGroup.remove(runeUpgrade);
			this._collectibleGroup.remove(healthUpgrade);
		}
		/* ---------------------------------------------------------------------------------------- */
		
		private function addText($theObject:FlxObject):void
		{
			this._onScreenText.add($theObject);
			add($theObject);
		}
		
		private function removeText():void
		{
			this._onScreenText.kill();
			this._onScreenText.clear();
		}
		/* ---------------------------------------------------------------------------------------- */
		
		
		/**
		 * @private
		 * Check for the hero exiting the room and create a new room if it does.
		 * Also wraps the hero when exiting the room.
		 * 
		 */
		protected function wrap():void
		{
			if (this.mcHero.x > FlxG.width)
			{
				this.mcHero.x = 32;
				
				if (this._nLevelNumber == 11)
					FlxG.switchState(new ResultState());
				else
				{
					if (this._nLevelNumber < 10)
					{
						this.generateRoomTiles(true);
						this.placeEnemies();
						this._nLevelNumber++;
					}
					else
					{
						this.generateRoomTiles(false);
						this._nLevelNumber++;
						
						FlxG.music.stop();
						FlxG.playMusic(MusicBoss);
						
						var mcGhost :Ghost = new Ghost(FlxG.width/2, FlxG.height - 192);
						this._enemyGroup.add(mcGhost);
						add(mcGhost);
						mcGhost.acquireTarget(mcHero);
					}
				}
				this._collectibleGroup.kill();
				this._collectibleGroup.clear();
			}
				
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		
		/**
		 * @private
		 * Create a new room with option to place platforms.
		 * 
		 * @param $bMakePlatforms		Whether or not to generate platforms.
		 */
		protected function generateRoomTiles($bMakePlatforms:Boolean):void
		{
			levelMap.loadMap(new EmptyMap(), Tiles, 32, 32, FlxTilemap.OFF);
			
			if ($bMakePlatforms)
			{
				var n :Number = Math.random();
				
				if (n < .5)
					genBasic();
				else
					genNatesRecommendation();
			}
			
			this._bLevelComplete = false;
			
			add(levelMap);
		}
		
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Generate platforms, basic platforms.
		 *
		 */
		protected function genBasic():void
		{
			for (var x :int = 1; x < levelMap.widthInTiles - 1; x++)
			{
				for (var y :int = 3; y < levelMap.heightInTiles - 2; y+=3)
				{
					if(Math.random() * 20 > 5)
						levelMap.setTile(x, y, int(Math.random() * 4 + 1));
				}
			}
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Generate platforms as recommended from the proto presentation.
		 *
		 */
		protected function genNatesRecommendation():void
		{
			for (var x :int = 1; x < levelMap.widthInTiles - 1; x++)
			{
				for (var y :int = 3; y < levelMap.heightInTiles - 2; y+=3)
				{
					if(Math.random() * 20 > 5)
						levelMap.setTile(x, y - 1 + int(Math.random() * 2), int(Math.random() * 4 + 1));
				}
			}
			
		}
		
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Place enemies on the map.
		 */
		protected function placeEnemies():void
		{
			for (var x :int = 7; x < levelMap.widthInTiles - 2; x++)
			{
				for (var y :int = 2; y < levelMap.heightInTiles - 2; y+=3)
				{
					if (levelMap.getTile(x,y) == 0 && Math.random() * 20 > 19)
					{
						var n :int = int(Math.random() * 3);
						
						if (n == 0)
						{
							var mcBat :Bat = new Bat(x * 32, y * 32);
							this._enemyGroup.add(mcBat);
							add(mcBat);
						}
						else if (n == 1)
						{
							var mcSpider :Spider = new Spider(x * 32, y * 32);
							this._enemyGroup.add(mcSpider);
							add(mcSpider);
							mcSpider.acquireTarget(mcHero);
						}
						else
						{
							var mcLumberer :Lumberer = new Lumberer(x * 32, y * 32);
							this._enemyGroup.add(mcLumberer);
							add(mcLumberer);
							mcLumberer.acquireTarget(mcHero);
						}
						
					}
				}
			}
			
		}
	}
}
