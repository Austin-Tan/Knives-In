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
import nape.space.Space;
import nape.phys.Body;

class PlayState extends FlxState
{
	var curLevel:Int;

	// Sprites
	var thrower:Thrower;
	var knife:Knife;
	var knivesLeft:Int;
	var targets:Array<Target>;
	var targetsLeft:Int;

	// Background
	var space:Space;

	// Menu
	var targetsLeftText:flixel.text.FlxText;
	var knivesLeftText:flixel.text.FlxText;

	override public function create():Void {
		super.create();

		this.bgColor = FlxColor.WHITE;

		this.curLevel = 0;
		initializeLevel(curLevel);
	}

	public function initializeLevel(level:Int) {

		// Display Level
		createLevelMenu(level);
		loadBackground(level);

		// TODO: find a way to store the initial setup of each level
		loadTargets(level);
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

	public function loadTargets(level:Int):Void {

		var x:Int = 150;
		var y:Int = 150;

		this.thrower = new Thrower(x, y);
		add(thrower);

		
		this.targets = new Array<Target>();
		this.targetsLeft = 2;
		var target:Target = new Target(20, 20);
		var target2:Target = new Target(240, 200);
		
		target.body.space = this.space;
		target2.body.space = this.space;
		
		targets.push(target);
		targets.push(target2);

		for(targ in targets) {
			add(targ);
		}
	}

	public function loadBackground(level:Int):Void {
		space = new Space(new Vec2(0, 200));
		
		var floorShape:Polygon = new Polygon(Polygon.rect(0, FlxG.height, FlxG.width, 1));
		var platformShape:Polygon = new Polygon(Polygon.rect(220, 240, 50, 1));

		var floorBody:Body = new Body(BodyType.STATIC);
		var platformBody:Body = new Body(BodyType.STATIC);

		platformBody.shapes.add(platformShape);
		floorBody.shapes.add(floorShape);

		space.bodies.add(platformBody);
		space.bodies.add(floorBody);
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
