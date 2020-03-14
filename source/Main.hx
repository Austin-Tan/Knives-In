package;

import flixel.system.FlxSound;
import js.Cookie;
import flixel.FlxGame;
import openfl.display.Sprite;
import flixel.FlxG;

class Main extends Sprite
{
	public static var passedLevel:Int = 1;

	public static var LOGGER:CapstoneLogger;
	
	public static var expireDelay:Int = 2628000;
	public static var blippy:FlxSound;

	public function new()
	{
		super();

		if (!Cookie.exists("version")) {
			var randomNum:Float = Math.random();
			if (randomNum <= 0.5) {
				Cookie.set("version", "1", expireDelay);
			} else {
				Cookie.set("version", "2", expireDelay);
			}
		}

		if(!Cookie.exists("MaxLevel")) {
			Cookie.set("MaxLevel", "1", expireDelay);
		}

		var gameId:Int = 202002;
		var gameKey:String = "74be16979710d4c4e7c6647856088456";
		var gameName:String = "knivesin";
		var categoryId:Int;

		if (Cookie.get("version") == "1") {
			categoryId = -1;
		} else if (Cookie.get("version") == "2") {
			categoryId = -2;
		} else {
			categoryId = 0;
		}

		Main.LOGGER = new CapstoneLogger(gameId, gameName, gameKey, categoryId);
		var userId:String = Main.LOGGER.getSavedUserId();
		if (userId == null) {
			userId = Main.LOGGER.generateUuid();
			Main.LOGGER.setSavedUserId(userId);
		}
		Main.LOGGER.startNewSession(userId, this.onSessionReady);

	}

	private function onSessionReady(sessionReceived:Bool):Void {
		addChild(new FlxGame(0, 0, MenuState));
		blippy = FlxG.sound.load("assets/sounds/blippy.ogg", 0.4, true);
		blippy.persist = true;
		blippy.play();
	}
}
