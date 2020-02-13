package;

import nape.shape.Polygon;
import nape.phys.BodyType;
import nape.geom.Vec2;
import lime.math.Vector2;
import openfl.geom.Vector3D;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import haxe.Template;
import flixel.FlxState;
import flixel.group.FlxGroup;
import nape.space.Space;
import nape.phys.Body;

class PlayState extends FlxState
{
	var curLevel:Int;

	var knife:Knife;
	var target:Target;
	var target2:Target;
	var targets:Array<Target>;
	var space:Space;

	var floorBody:Body = new Body(BodyType.STATIC);
	var floorShape:Polygon = new Polygon(Polygon.rect(0, FlxG.height, FlxG.width, 1));
	var platformBody:Body = new Body(BodyType.STATIC);
	var platformShape:Polygon = new Polygon(Polygon.rect(300, 240, 50, 1));

	var thrower:Thrower;
	var targetsLeft:Int;
	var targetsLeftText:flixel.text.FlxText;
	var knivesLeft:Int;
	var knivesLeftText:flixel.text.FlxText;

	override public function create():Void {
		super.create();

		this.bgColor = FlxColor.WHITE;

		curLevel = 0;
		initLevel(curLevel);
	}

	public function initLevel(level:Int) {

		// Display Level
		createLevelMenu(level);

		// TODO: find a way to store the initial setup of each level
		var x:Int = 150;
		var y:Int = 150;
		// knife = new Knife(x, y, FlxColor.BLUE);
		// add(knife);
		thrower = new Thrower(x, y);
		add(thrower);

		space = new Space(new Vec2(0, 200));
		
		target = new Target(20, 20);
		target2 = new Target(320, 200);
		this.targetsLeft = 2;
		target.body.space = space;
		target2.body.space = space;

		target2.body.shapes.at(0).sensorEnabled = true;
		targets = new Array<Target>();
		targets.push(target);
		targets.push(target2);
		for(targ in targets) {
			add(targ);
		}
		platformBody.shapes.add(platformShape);
		space.bodies.add(platformBody);

		floorBody.shapes.add(floorShape);
		space.bodies.add(floorBody);
	}
	
	var cooldown:Float;
	public function createLevelMenu(level:Int):Void {

		var text = new flixel.text.FlxText(0, 0, 0, "Level " + level, 30);
		text.color = FlxColor.BLACK;
		text.screenCenter(flixel.util.FlxAxes.X);
		add(text);

		var x:Int = 10;
		var y:Int = 10;
		this.targetsLeftText = new flixel.text.FlxText(x, y, 0, "Targets: " + this.targetsLeft, 12);
		this.knivesLeftText = new flixel.text.FlxText(x, y + 20, 0, "Knives: infinity", 12);
		targetsLeftText.color = FlxColor.BLACK;
		knivesLeftText.color = FlxColor.BLACK;
		add(targetsLeftText);
		add(knivesLeftText);

		cooldown = 0;
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		if (FlxG.keys.pressed.FIVE) {
         FlxG.switchState(new PlayState());
		}

		// throw knife
		if (FlxG.keys.pressed.SPACE && cooldown <= 0) {
			thrower.visible = false;
			var newKnife = new Knife(thrower.x + 12, thrower.y + 9, Math.PI * (thrower.angle) / 180);
			cooldown = 0.5;
			newKnife.body.space = space;
			add(newKnife);
			newKnife.visible = true;
		}
		if(cooldown > 0) {
			cooldown -= elapsed;
		}
		if(cooldown <= 0) {
			thrower.visible = true;
		}
	  	space.step(elapsed);
		this.targetsLeftText.text = "Targets: " + this.targetsLeft;
	}
}
