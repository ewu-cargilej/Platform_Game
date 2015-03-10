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
		[Embed(source = '../../../../embeded_resources/Credits_Screen/CreditsScreen_ReturnButton.png')]private static var ImgReturnButton:Class;
		
		[Embed(source = '../../../../embeded_resources/SFX/Button_Click.mp3')]private static var ButtonClick:Class;
		
		/**
		 * Set up the state.
		 */
		override public function create():void
		{
			var tmpSprite :FlxSprite = new FlxSprite(0, 0, ImgCredits);
			add(tmpSprite);
			
			tmpSprite = new FlxSprite(FlxG.width / 2 - 141, FlxG.height - 150, ImgReturnButton);
			add(tmpSprite);
			
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

			if (FlxG.mouse.justPressed())
			{
				FlxG.play(ButtonClick, 1, false);
				FlxG.switchState(new TitleState());
			}
		}
	}
}
