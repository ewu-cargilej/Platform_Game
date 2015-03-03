package com.gauntlet.states
{
	import org.flixel.*;

	/**
	 * Credit work and resources used.
	 * 
	 * @author Casey Sliger
	 */
	public class CreditsState extends FlxState
	{
		/**
		 * Set up the state.
		 */
		override public function create():void
		{
			var t:FlxText;
			t = new FlxText(0, FlxG.height / 2 - 32, FlxG.width, "Credits");
			t.size = 64;
			t.alignment = "center";
			add(t);
			
			
			t = new FlxText(FlxG.width/2-100,FlxG.height-100,200,"click to exit");
			t.size = 24;
			t.alignment = "center";
			add(t);
			
			FlxG.mouse.show();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		

		/**
		 * Called every frame.
		 * 
		 */
		override public function update():void
		{
			super.update();

			if(FlxG.mouse.justPressed())
				FlxG.switchState(new TitleState());
		}
	}
}
