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
		[Embed(source = '../../../../embeded_resources/Credits_Screen/Credits.png')]private static var ImgCredits:Class;
		
		/**
		 * Set up the state.
		 */
		override public function create():void
		{
			var image :FlxSprite = new FlxSprite(0, 0, ImgCredits);
			add(image);
			
			var text:FlxText;
			text = new FlxText(FlxG.width/2-100,FlxG.height-100,200,"click to exit");
			text.size = 24;
			text.alignment = "center";
			add(text);
			
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
