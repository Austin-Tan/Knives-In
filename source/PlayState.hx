package;

import haxe.Template;
import flixel.FlxState;

class PlayState extends FlxState
{
	override public function create():Void
	{
		super.create();

		// Welcome text
		var text = new flixel.text.FlxText(0, 0, 0, "Hello World", 64);
		text.screenCenter();
		add(text);

		// TODO: add start menu

		// TODO: add tilemap

		// TODO: add sprites
		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
