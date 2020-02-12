package;

import nape.geom.Vec2;
import lime.math.Vector2;
import openfl.geom.Vector3D;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import haxe.Template;
import flixel.FlxState;
import nape.space.Space;

class PlayState extends FlxState
{
	var knife:Knife;
	var curLevel:Int;
	var target:Target;
	var target2:Target;
	var targets:Array<Target>;
	var space:Space;

	override public function create():Void {
		super.create();

		this.bgColor = FlxColor.WHITE;

		curLevel = 0;
		initLevel(curLevel);
	}

	public function initLevel(level:Int) {

		// Welcome text
		var text = getLevelMenu(level);
		add(text);

		// TODO: find a way to store the initial setup of each level
		var x:Int = 150;
		var y:Int = 150;
		knife = new Knife(x, y, FlxColor.BLUE);
		add(knife);

		space = new Space(new Vec2(0, 400));
		
		target = new Target(20, 20);
		target2 = new Target(200, 200);
		target.body.space = space;
		// knife.body.space = space;
		target2.body.space = space;
		targets = new Array<Target>();
		targets.push(target);
		targets.push(target2);
		for(targ in targets) {
			add(targ);
		}
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
		if (FlxG.keys.pressed.ESCAPE) {
         FlxG.switchState(new PlayState());
	  }
	  space.step(elapsed);
	}
}
