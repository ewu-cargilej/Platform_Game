package com.gauntlet.objects.enemies
{
	import com.gauntlet.objects.enemies.BaseEnemy;
	import flash.display.Sprite;
	import org.flixel.FlxG;
	import org.osflash.signals.Signal;

	
	/**
	 * a play button enemy
	 * 
	 * @author Nicholas Valetnine
	 */
	public class PlayButtonEnemy extends BaseEnemy
	{
		[Embed(source = '../../../../../embeded_resources/Title_Screen/Button_Play.png')]private static var PlayButton:Class;
		public var playGameSignal :Signal = new Signal;
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the PlayButtonEnemy object.
		 */
		public function PlayButtonEnemy()
		{
			super(FlxG.width - 350, FlxG.height / 2, 1, 0, 0);
			this.loadGraphic(PlayButton);
			
		}
		
		override public function kill():void 
		{
			super.kill();
			this.playGameSignal.dispatch();
		}
		/* ---------------------------------------------------------------------------------------- */
		
	}
}

