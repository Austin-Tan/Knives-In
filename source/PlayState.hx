package;

import nape.dynamics.InteractionFilter;
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
	var cooldown:Float;

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
		initializeLevel();
	}

	// to be called when loading a new level
	public function initializeLevel() {
		// Display Level
		createLevelMenu();

		// Must load background before targets
		loadBackground();
		loadItems();
	}
	
	public function createLevelMenu():Void {
		var text = new flixel.text.FlxText(0, 0, 0, "Level " + this.curLevel, 30);
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
	}

	public function loadItems():Void {
		this.thrower = Level.getThrower(this.curLevel);
		add(thrower);
		this.cooldown = 0;

		this.targets = Level.getTargets(this.curLevel);
		this.targetsLeft = this.targets.length;

		for (target in targets) {
			target.body.space = this.space;
			add(target);
		}
	}


	var COLLISION_GROUP:Int = 4;
	var COLLISION_MASK:Int = ~1;
	public function loadBackground():Void {
		space = new Space(new Vec2(0, 200));
		
		var floorShape:Polygon = new Polygon(Polygon.rect(0, FlxG.height, FlxG.width, 1));
		var platformShape:Polygon = new Polygon(Polygon.rect(320, 240, 50, 1));

		var floorBody:Body = new Body(BodyType.STATIC);
		var platformBody:Body = new Body(BodyType.STATIC);

		floorBody.shapes.add(floorShape);
		platformBody.shapes.add(platformShape);

		floorBody.setShapeFilters(new InteractionFilter(COLLISION_GROUP, COLLISION_MASK));
		platformBody.setShapeFilters(new InteractionFilter(COLLISION_GROUP, COLLISION_MASK));

		space.bodies.add(floorBody);
		space.bodies.add(platformBody);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		if (FlxG.keys.pressed.FIVE) {
         FlxG.switchState(new PlayState());
		}

		if (targetsLeft == 0) {
			curLevel += 1;
			initializeLevel();
		}

		// throw knife
		if (FlxG.keys.pressed.SPACE && cooldown <= 0) {
			this.thrower.visible = false;
			this.cooldown = 0.5;

			var newKnife = new Knife(thrower.x + 12, thrower.y + 9, Math.PI * (thrower.angle) / 180);
			newKnife.body.space = this.space;
			newKnife.visible = true;
			add(newKnife);
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
