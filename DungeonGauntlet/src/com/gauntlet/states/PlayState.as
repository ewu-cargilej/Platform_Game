package com.gauntlet.states
{
	import com.gauntlet.objects.enemies.BaseEnemy;
	import com.gauntlet.objects.enemies.Bat;
	import com.gauntlet.objects.enemies.Ghost;
	import com.gauntlet.objects.enemies.Lumberer;
	import com.gauntlet.objects.enemies.Spider;
	import com.gauntlet.objects.player.Arm;
	import com.gauntlet.objects.player.Hero;
	import com.gauntlet.runes.Rune;
	import com.gauntlet.runes.UpgradeManager;
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
		
		/** Show current health. */
		protected var _txtHealth		:FlxText;
		
		/**	Show current score. */
		protected var _txtScore			:FlxText;
		
		/**	Show current rune. */
		protected var _txtRune			:FlxText;
		
		/** Current level number. */
		protected var _nLevelNumber		:int;
		
		/** The upgrade manage for the runes and health*/
		protected var 	upgrades		:UpgradeManager;
		
		/** Location of the exit. */
		protected var	_nExitHeight	:int;
		
		/**
		 * Set up the state.
		 */
		override public function create():void
		{
			FlxG.playMusic(MusicPlay, .5);
			
			FlxG.mouse.show();
			
			this._bLevelComplete = false;
			this._nLevelNumber = 1;
			this._enemyGroup = new FlxGroup();
			
			add(_enemyGroup);
			this.upgrades = new UpgradeManager();
			
			setupPlayer(32, 640);
			
			
			upgrades.displayButtonSignal.add(add);
			upgrades.removeButtonSignal.add(remove);
			upgrades.newRuneSignal.add(mcArm.loadRune);
			
			levelMap = new FlxTilemap();
			this.generateRoomTiles(true);
			this.placeEnemies();
			
			
			_txtHealth = new FlxText(64, FlxG.height - 48, 150, "HP: " + this.mcHero.health);
			_txtHealth.size = 24;
			add(_txtHealth);
			
			_txtScore = new FlxText(FlxG.width/2 - 64, FlxG.height - 48, 150, "Score:");
			_txtScore.size = 24;
			add(_txtScore);
			
			_txtRune = new FlxText(FlxG.width - 192, FlxG.height - 48, 150, "Rune:");
			_txtRune.size = 24;
			add(_txtRune);
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
				this._bLevelComplete = true;
				this._enemyGroup.kill();
				this._enemyGroup.clear();
			}
			
			if (this._bLevelComplete)
			{
				//open door
				this.levelMap.setTile(levelMap.widthInTiles - 1, this._nExitHeight, 0);
			}
			
			FlxG.collide(mcHero, levelMap);
			
			FlxG.collide(_enemyGroup, levelMap);
			
			FlxG.overlap(mcHero, _enemyGroup, collideDamage);
			
			
			if (mcArm.x - 3.5 != mcHero.x)
			{
				mcArm.x  = mcHero.x - 3.5;
			}
			if (mcArm.y + 11 != mcHero.y)
			{
				mcArm.y = mcHero.y + 11;
			}
			
			wrap();
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
			
			mcArm = new Arm(mcHero.x + 16, mcHero.y);
			
			add(mcArm);
			
			mcArm.addRuneSignal.add(add);
			
			mcArm.loadRune(new Rune(FlxG.width / 2 - 16, 640));			
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
						this._nLevelNumber++;
						this.generateRoomTiles(true);
						this.placeEnemies();
						//this._txtScore.text = this._nLevelNumber + "";
					}
					else
					{
						this._nLevelNumber++;
						this.generateRoomTiles(false);
						
						FlxG.music.stop();
						FlxG.playMusic(MusicBoss, .5);
						
						var mcGhost :Ghost = new Ghost(FlxG.width/2, FlxG.height - 192);
						this._enemyGroup.add(mcGhost);
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
			else
				this._nExitHeight = levelMap.heightInTiles - 2;
			
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
					if((Math.random() * 20 > 10 && x < levelMap.widthInTiles - 3 - y/3) || x > levelMap.widthInTiles - 2 - y/3)
						levelMap.setTile(x, y, int(Math.random() * 4 + 1));
				}
			}
			
			this._nExitHeight = levelMap.heightInTiles - 2 - int(Math.random() * 5)*3;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Generate platforms
		 *
		 */
		protected function genHoles():void
		{
			var randomTarget:int = int(Math.random() * 10);
			
			for (var x :int = 2; x < levelMap.widthInTiles - 2; x++)
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
				
				if(x < levelMap.widthInTiles - 2)
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
								mcLumberer.acquireTarget(mcHero);
								enemyPoints -= 5;
							}
							else if (enemyPoints >= 3)
							{
								var mcSpider :Spider = new Spider(x * 32, y * 32);
								this._enemyGroup.add(mcSpider);
								add(mcSpider);
								mcSpider.acquireTarget(mcHero);
								enemyPoints -= 3;
							}
							else
							{
								var mcBat :Bat = new Bat(x * 32, y * 32);
								this._enemyGroup.add(mcBat);
								add(mcBat);
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
