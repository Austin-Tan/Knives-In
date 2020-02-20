package;

import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.FlxState;

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
		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	function clickPlay():Void {
		FlxG.switchState(new PlayState());
	}
}
