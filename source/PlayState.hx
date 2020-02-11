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
	override public function create():Void
	{
		super.create();
		this.bgColor = FlxColor.WHITE;
		thrown = false;

		// initialize to 0, 0, we'll center after
		knife = new Knife(0, 0, FlxColor.BLUE);
		knife.screenCenter();
		knife.setGraphicSize(50, 50);
		
		// Welcome text
		var text = new flixel.text.FlxText(0, 0, 0, "Level 0", 64);
		text.color = FlxColor.BLACK;
		text.screenCenter(flixel.util.FlxAxes.X);
		add(text);
		add(knife);

		// TODO: create a helper method for initialize a new level?
		// TODO: add tilemap
		// TODO: add sprites

	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		// knife.y += elapsed * 30;
		if(thrown) {
			knife.x += knife.thrownVelocity * elapsed * Math.sin(knife.angle);
			knife.y += knife.thrownVelocity * elapsed * Math.cos(knife.angle);
			if(knife.thrownVelocity > (knife.thrownVelocity / 2)) {
				knife.thrownVelocity -= 300 * elapsed;
			}
		} else { // not thrown
			knife.angle += elapsed * 120;
		}

		if(FlxG.keys.pressed.ESCAPE || knife.x > FlxG.width || knife.x < 0 || knife.y > FlxG.height || knife.y < 0) {
			thrown = false;
			knife.screenCenter();
		}
		if(FlxG.keys.pressed.SPACE && !thrown) {
			thrown = true;
			knife.thrownVelocity = 550;
		}
	}
}
