package;

import flixel.FlxGame;
import openfl.display.Sprite;
import flixel.FlxG;

class Main extends Sprite
{
	public static var passedLevel:Int = 0;

	public function new()
	{
		super();
		// addChild(new FlxGame(0, 0, LevelSelect));
      	addChild(new FlxGame(0, 0, MenuState));
		// addChild(new FlxGame(0, 0, PlayState));
		FlxG.sound.volume = 0.5;
	}
}
