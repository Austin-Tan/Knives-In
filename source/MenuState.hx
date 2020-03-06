package;

import flixel.FlxSprite;
import js.Cookie;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.FlxState;
import flixel.system.FlxSound;


class MenuState extends FlxState
{
	override public function create():Void {
		super.create();
		this.bgColor = FlxColor.BLACK;

		// Welcome text
		var text = new flixel.text.FlxText(0, 0, 0, "Knives In", 64);
		text.screenCenter();
		add(text);

		// Start button
		var playButton = new FlxButton(280, 300, "Play", clickPlay);
		add(playButton);
		
		var selectButton = new FlxButton(280, 320, "Level Select", ()->{FlxG.switchState(new LevelSelect());});
		add(selectButton);
		
		var credits = new flixel.text.FlxText(0, 0, 0, "Blippy Trance by Kevin MacLeod\nLink: https://incompetech.filmmusic.io/song/5759-blippy-trance\nLicense: http://creativecommons.org/licenses/by/4.0/");
		add(credits);
		credits.screenCenter();
		credits.y += 200;
		credits.x -= 140;

		var menuY = 10;
		var muteMusicIcon = new FlxSprite(FlxG.width - 120, menuY + 60);
		muteMusicIcon.loadGraphic("assets/images/musicIcon.png", false, 32, 32);
		add(muteMusicIcon);
		var muteMusicButton = new FlxButton(FlxG.width - 100, menuY + 60, "Music", muteMusic);
		add(muteMusicButton);

		var muteSoundIcon = new FlxSprite(FlxG.width - 120, menuY + 90);
		muteSoundIcon.loadGraphic("assets/images/soundIcon.png", false, 32, 32);
		add(muteSoundIcon);
		var muteSoundButton = new FlxButton(FlxG.width - 100, menuY + 90, "All Sound", muteSound);
		add(muteSoundButton);
	}

	function muteMusic():Void {
		if (Main.blippy.playing) {
			Main.blippy.pause();
		} else {
			Main.blippy.resume();
		}
	}
		
	public function muteSound():Void {
		FlxG.sound.toggleMuted();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	function clickPlay():Void {
		FlxG.switchState(new PlayState());
	}
}
