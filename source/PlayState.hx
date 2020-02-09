package;

import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import haxe.Template;
import flixel.FlxState;

class PlayState extends FlxState
{
	override public function create():Void
	{
		super.create();
		
		// Welcome text
		var text = new flixel.text.FlxText(0, 0, 0, "Level 0", 64);
		text.screenCenter();
		add(text);

		// TODO: create a helper method for initialize a new level?
		// TODO: add tilemap
		// TODO: add sprites

	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
