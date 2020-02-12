package;

import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.FlxState;

class MenuState extends FlxState
{
	override public function create():Void
	{
		super.create();
		
		// Welcome text
		var text = new flixel.text.FlxText(0, 0, 0, "Knives In", 64);
		text.screenCenter();
		add(text);

		// Start button
		var playButton = new FlxButton(280, 300, "Play", clickPlay);
		add(playButton);
		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	function clickPlay():Void {
		FlxG.switchState(new PlayState());
	}
}
