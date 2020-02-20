package;

import js.Cookie;
import flixel.FlxGame;
import openfl.display.Sprite;
import flixel.FlxG;

class Main extends Sprite
{
	public static var passedLevel:Int = 0;

	public static var expireDelay:Int = 2628000;
	public function new()
	{
		super();
		if(!Cookie.exists("MaxLevel")) {
			Cookie.set("MaxLevel", "0", expireDelay);
		}
		// addChild(new FlxGame(0, 0, LevelSelect));
      	addChild(new FlxGame(0, 0, MenuState));
		// addChild(new FlxGame(0, 0, PlayState));
		FlxG.sound.volume = 0.5;
	}
}
