package com.gauntlet.loading
{
	import org.flixel.system.FlxPreloader;

	/**
	 * The hero for the game.
	 * 
	 * @author Casey Sliger
	 */
	public class Preloader extends FlxPreloader
	{
		/**
		 * Preload stuff.
		 */
		public function Preloader()
		{
			className = "Main";
			super();
		}
	}
}
