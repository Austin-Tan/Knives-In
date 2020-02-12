package;

import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import haxe.Template;
import flixel.FlxState;

class PlayState extends FlxState
{
	var knife:Knife;
	var thrown:Bool;
	var curLevel:Int;
	var target:Target;

	override public function create():Void {
		super.create();

		this.bgColor = FlxColor.WHITE;

		curLevel = 0;
		initLevel(curLevel);
	}

	public function initLevel(level:Int) {
		thrown = false;

		// Welcome text
		var text = getLevelMenu(level);
		add(text);

		// TODO: find a way to store the initial setup of each level
		var x:Int = 150;
		var y:Int = 150;
		knife = new Knife(x, y, FlxColor.BLUE);
		add(knife);
		
		// target = new Target(FlxG.width - target.width, FlxG.height - target.height);
		// add(target);
	}
	
	public function getLevelMenu(level:Int):flixel.text.FlxText {
		var text = new flixel.text.FlxText(0, 0, 0, "Level " + level, 64);
		text.color = FlxColor.BLACK;
		text.screenCenter(flixel.util.FlxAxes.X);
		return text;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
