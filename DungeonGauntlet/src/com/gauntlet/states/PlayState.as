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
	import org.flixel.*;
	import treefortress.sound.SoundAS;

	/**
	 * Play state.
	 * Gameplay
	 * 
	 * @author Casey Sliger
	 */
	public class PlayState extends FlxState
	{
		[Embed(source = '../../../../embeded_resources/Game_Screen/Level_Building/Tiles.png')]private static var Tiles:Class;
		[Embed(source = '../../../../embeded_resources/Game_Screen/Level_Building/GameScreen_Background.png')]protected static var ImgBackground:Class;
		[Embed(source = '../../../../embeded_resources/Game_Screen/Maps/empty_map.txt', mimeType = 'application/octet-stream')]private static var EmptyMap:Class;
		
		[Embed(source = '../../../../embeded_resources/SFX/EnemiesDefeated.mp3')]private static var EnemiesDefeated:Class;
		
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
		
		/** All flying enemies on the screen. */
		protected var _enemyGroupFly		:FlxGroup;
		
		/** Group of all the runes that appear */
		protected var _runeGroup		:FlxGroup;
		
		/** Group of all collidable items */
		protected var _collectibleGroup	:FlxGroup;
		
		/** a text of the text added to screen for upgrades*/
		protected var _onScreenIdentify		:FlxGroup;
		
		/** Show current health. */
		protected var _txtHealth		:FlxText;
		
		/**	Show current score. */
		protected var _txtScore			:FlxText;
		
		/** the current score of the game */
		protected var _nScore			:Number;
		
		/**	Show current rune. */
		protected var _txtRune			:FlxText;
		
		/** Text to show that the game is paused. */
		protected var	_txtPause	:FlxText;
		
		/** grapic of the current rune*/
		protected var _currRune			:FlxSprite;
		
		/** Current level number. */
		protected var _nLevelNumber		:int;
		
		/** Manages all the items that appear on screen */
		protected var	_iManager		:ItemManager;
		
		/** Location of the exit. */
		protected var	_nExitHeight	:int;
		
		/** Level number for the Boss. */
		protected var	_nBossLevel	:int;
		
		/** FlxSave object to store the current score. */
		protected var	_saveData	:FlxSave;
		
		/**
		 * Set up the state.
		 */
		override public function create():void
		{
			SoundAS.stopAll();			
			SoundAS.playLoop("Play", .7, 0, true);
			
			FlxG.mouse.show();
			
			this._bLevelComplete = false;
			this._nLevelNumber = 1;
			this._nBossLevel = 11;
			
			this._saveData = new FlxSave();
			this._saveData.bind("scoreData");
			
			var background:FlxSprite = new FlxSprite(0, 0, ImgBackground);
			add(background);
			
			establishGroups();
			
			//add(_enemyGroup);
			//add(_enemyGroupFly);
			
			setupPlayer(32, 640);
			
			_iManager.newRuneSignal.add(upgrade);
			_iManager.spawnObjectSignal.add(addCollectible);
			_iManager.upgradeHealthSignal.add(upgrade);
			_iManager.removeObjectSignal.add(removeCollectible);
			_iManager.addStatSignal.add(addStats);
			
			levelMap = new FlxTilemap();
			this.generateRoomTiles(true);
			this.placeEnemies();
			
			this._nScore = 0;
			var intScore:int = int(this._nScore);
			
			_txtHealth = new FlxText(64, FlxG.height - 48, 150, "HP: " + this.mcHero.health);
			_txtHealth.size = 24;
			add(_txtHealth);
			
			_txtScore = new FlxText(FlxG.width/2 - 64, FlxG.height - 48, 400, "Score: " + intScore);
			_txtScore.size = 24;
			add(_txtScore);
			
			_txtRune = new FlxText(FlxG.width - 192, FlxG.height - 48, 150, "Rune:");
			_txtRune.size = 24;
			add(_txtRune);
			
			_txtPause = new FlxText(FlxG.width / 2 - 50, FlxG.height / 2, 100, "Pause");
			_txtPause.size = 24;
			add(_txtPause);
			_txtPause.visible = false;
			
			this._currRune = new FlxSprite(32 * 29 ,32 * 22.5);
			this._currRune.loadGraphic(mcArm.myRune.getUpgradeGraphic(), false, false, 32);
			add(_currRune);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * establishes all groups so they are non-null
		 */
		public function establishGroups():void
		{
			this._enemyGroup = new FlxGroup();
			this._enemyGroupFly = new FlxGroup();
			this._runeGroup = new FlxGroup();
			this._collectibleGroup = new FlxGroup();
			this._onScreenIdentify = new FlxGroup();
			_iManager = new ItemManager();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Called every frame.
		 */
		override public function update():void
		{
			super.update();
			
			if (FlxG.keys.justPressed("P"))
			{
				if (!FlxG.paused)
				{
					FlxG.timeScale = 0;
					FlxG.paused = true;
					this._txtPause.visible = true;
				}
				else
				{
					FlxG.timeScale = 1;
					FlxG.paused = false;
					this._txtPause.visible = false;
				}
			}
			
			if (FlxG.keys.justPressed("B") && FlxG.keys.pressed("SHIFT"))
			{
				this._nLevelNumber = 10;
			}
			if (FlxG.keys.justPressed("K") && FlxG.keys.pressed("SHIFT"))
			{
				this._enemyGroup.kill();
				this._enemyGroupFly.kill();
			}
			
			if ((_enemyGroupFly.length == 0 || _enemyGroupFly.countLiving() == 0 ) && (_enemyGroup.length == 0 || _enemyGroup.countLiving() == 0) && !this._bLevelComplete && !(this is TitleState))
			{
				FlxG.play(EnemiesDefeated, 1, false);
				
				//this._enemyGroup.kill();
				//this._enemyGroupFly.kill();
				
				this._enemyGroup.clear();
				this._enemyGroupFly.clear();
				this._bLevelComplete = true;
				if (this._nLevelNumber != this._nBossLevel)
					_iManager.spawnUpgrade(this._nLevelNumber, mcArm.myRune, levelMap.widthInTiles - 1, this._nExitHeight);

			}
			
			if (!this.mcHero.alive)
			{
				this._enemyGroup.kill();
				this._enemyGroupFly.kill();
				
				this._saveData.data.currentScore = this._nScore;
				
				FlxG.switchState(new ResultState(false));
			}
			
			if (this._bLevelComplete)
			{
				//open door
				this.levelMap.setTile(levelMap.widthInTiles - 1, this._nExitHeight, 0);
			}
			
			collisions();
			
			alignArm();
			
			wrap();
		}
		
		private function collisions():void
		{
			FlxG.collide(mcHero, levelMap);
			
			FlxG.collide(_enemyGroup, levelMap)
			
			FlxG.overlap(mcHero, _enemyGroup, collideDamage);
			
			FlxG.overlap(mcHero, _enemyGroupFly, collideDamage);
			
			FlxG.overlap(_runeGroup, _enemyGroup, enemyDamage);
			
			FlxG.overlap(_runeGroup, _enemyGroupFly, enemyDamage);
			
			FlxG.collide(_runeGroup, levelMap, mcArm.tileCollision);
			
			FlxG.overlap(mcHero, _collectibleGroup, _iManager.collect);
			
			FlxG.collide(_collectibleGroup, levelMap, _iManager.count);
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
			if ($enemy.alpha == 1)
			{
			$enemy.hurt($rune.Damage);
			$enemy.flicker();
			$rune.kill();
			}
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
			
			this._nScore += $value;
			var intScore:int = int(this._nScore);
			this._txtScore.text = "Score: " + intScore;
		}
		
		private function upgrade(runeUpgrade:FlxSprite, healthUpgrade:FlxSprite, newRune:Rune = null):void
		{
			if (newRune != null)
			{
				mcArm.loadRune(newRune);
				this._currRune = new FlxSprite(32 * 29 ,32 * 22.5);
				this._currRune.loadGraphic(newRune.getUpgradeGraphic(), false, false, 32);
				add(_currRune);
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
			this.removeStats();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * clears groups from the screen and ensures that their groups are empty
		 */
		private function clearGroups():void
		{
			this._collectibleGroup.kill();
			this._collectibleGroup.clear();
			
			this.removeStats();
				
			this._runeGroup.kill();
			this._collectibleGroup.clear();
		}
		/* ---------------------------------------------------------------------------------------- */
		
		private function addStats($theObject:FlxSprite):void
		{
			this._onScreenIdentify.add($theObject);
			add($theObject);
		}
		
		private function removeStats():void
		{
			this._onScreenIdentify.kill();
			this._onScreenIdentify.clear();
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
				
				if (this._nLevelNumber == this._nBossLevel)
				{
					this._saveData.data.currentScore = this._nScore;
					
					FlxG.switchState(new ResultState(true));
				}
				else
				{
					if (this._nLevelNumber < this._nBossLevel - 1)
					{
						this._nLevelNumber++;
						this.generateRoomTiles(true);
						this.placeEnemies();
						this.clearGroups();
					}
					else
					{
						
						this._nLevelNumber++;
						this.generateRoomTiles(true);
						this.clearGroups();
						
						SoundAS.stopAll();
						SoundAS.playLoop("Boss", .7, 0, true);
						
						var mcGhost :Ghost = new Ghost(FlxG.width, FlxG.height/4);
						this._enemyGroupFly.add(mcGhost);
						mcGhost.ID = 20;
						add(mcGhost);
						mcGhost.acquireTarget(mcHero);
					}
				}
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
				if (this._nLevelNumber == this._nBossLevel)
				{
					genBoss();
				}
				else
				{
					var n :int = int(Math.random() * 3);
				
				
					switch (n)
					{
						case 0:
						{
							genBasic();
							break;
						}
						
						case 1:
						{
							genHoles();
							break;
						}
					
						default:
						{
							genSlopes();
						}
							
					}
				}
				
				
			}
			else
				this._nExitHeight = levelMap.heightInTiles - 2;
			
			this._bLevelComplete = false;
			
			add(levelMap);
		}
		
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Generate basic platforms.
		 *
		 */
		protected function genBasic():void
		{
			for (var x :int = 1; x < levelMap.widthInTiles - 1; x++)
			{
				for (var y :int = 6; y < levelMap.heightInTiles - 2; y+=3)
				{
					if((Math.random() * 20 > 10 && x < levelMap.widthInTiles - 4 - y/3) || x > levelMap.widthInTiles - 3 - y/3)
						levelMap.setTile(x, y, int(Math.random() * 4 + 1));
				}
			}
			
			this._nExitHeight = levelMap.heightInTiles - 2 - int(Math.random() * 5) * 3;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Generate platforms with vertical wrapping
		 *
		 */
		protected function genHoles():void
		{			
			for (var x :int = 2; x < levelMap.widthInTiles - 5; x++)
			{
				levelMap.setTile(x, 0, 0);
				levelMap.setTile(x, levelMap.heightInTiles - 1, 0);
				
				levelMap.setTile(x, int(Math.random() * levelMap.heightInTiles), int(Math.random() * 4 + 1));
			}
			
			this._nExitHeight = levelMap.heightInTiles - 2;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		
		/**
		 * @private
		 * Generate tall stuff
		 *
		 */
		protected function genSlopes():void
		{
			var height :int = levelMap.heightInTiles - mcHero.y / 32;
			
			var slopeMod :Number = 1;
			if (mcHero.y < FlxG.height / 2)
				slopeMod = 1.5;
			
			
			for (var x :int = 1; x < levelMap.widthInTiles - 1; x++)
			{
				for (var y :int = 0; y < height; y++)
				{
					levelMap.setTile(x, levelMap.heightInTiles - y, int(Math.random() * 4 + 1));
				}
				
				if(x < levelMap.widthInTiles - 5)
					height += ((Math.random() * 3 - slopeMod) * 2);
				
				if (height < 0)
					height = 0;
				if (height > levelMap.heightInTiles - 5)
					height = levelMap.heightInTiles - 5;
			}
			
			this._nExitHeight = levelMap.heightInTiles - height - 2;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		
		/**
		 * @private
		 * Generate boss level
		 *
		 */
		protected function genBoss():void
		{
			for (var x :int = 2; x < levelMap.widthInTiles - 5; x++)
			{
				levelMap.setTile(x, 0, 0);
				levelMap.setTile(x, levelMap.heightInTiles - 1, 0);
				
				levelMap.setTile(x, int(Math.random() * levelMap.heightInTiles), int(Math.random() * 4 + 1));
			}
			
			
			
			var height :int = levelMap.heightInTiles - mcHero.y / 32;
			
			var slopeMod :Number = 1;
			if (mcHero.y < FlxG.height / 2)
				slopeMod = 1.5;
			
			
			for (x = 1; x < levelMap.widthInTiles - 1; x++)
			{
				for (var y :int = 0; y < height; y++)
				{
					levelMap.setTile(x, levelMap.heightInTiles - y, int(Math.random() * 4 + 1));
				}
				
				if(x < levelMap.widthInTiles - 5)
					height += ((Math.random() * 3 - slopeMod) * 2);
				
				if (height < 0)
					height = 0;
				if (height > levelMap.heightInTiles - 15)
					height = levelMap.heightInTiles - 15;
			}
			
			this._nExitHeight = levelMap.heightInTiles - height - 2;
		}
		
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Place enemies on the map.
		 */
		protected function placeEnemies():void
		{
			var enemyPoints :int = this._nLevelNumber;
			
			while (enemyPoints > 0)
			{
				for (var x :int = 10; x < levelMap.widthInTiles - 2; x++)
				{
					for (var y :int = levelMap.heightInTiles - 3; y > 2; y-=3)
					{
						if (enemyPoints > 0 && Math.random() * 20 > 19 && levelMap.getTile(x,y) == 0 && levelMap.getTile(x-1,y) == 0 && levelMap.getTile(x+1,y) == 0)
						{
							var n :int = int(Math.random() * 3);
							
							if (enemyPoints >= 5)
							{
								var mcLumberer :Lumberer = new Lumberer(x * 32, y * 32);
								this._enemyGroup.add(mcLumberer);
								add(mcLumberer);
								mcLumberer.ID = 3;
								mcLumberer.acquireTarget(mcHero,levelMap);
								enemyPoints -= 5;
							}
							else if (enemyPoints >= 3)
							{
								var mcSpider :Spider = new Spider(x * 32, y * 32);
								this._enemyGroup.add(mcSpider);
								add(mcSpider);
								mcSpider.ID = 2;
								mcSpider.acquireTarget(mcHero,levelMap);
								enemyPoints -= 3;
							}
							else
							{
								var mcBat :Bat = new Bat(x * 32, y * 32);
								this._enemyGroupFly.add(mcBat);
								mcBat.ID = 1;
								add(mcBat);
								mcBat.acquireTarget(mcHero);
								enemyPoints -= 1;
							}
							
							x += 5;//place them farther apart
						}
					}
				}
			}
			
		}
	}
}
