package;

import flixel.addons.nape.FlxNapeSpace;
import flixel.tile.FlxTilemap.GraphicAuto;
import flixel.addons.nape.FlxNapeTilemap;
import flixel.graphics.FlxGraphic;
import nape.callbacks.InteractionCallback;
import nape.callbacks.CbType;
import nape.callbacks.OptionType;
import nape.callbacks.InteractionType;
import nape.callbacks.CbEvent;
import nape.callbacks.InteractionListener;
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
	var knives:Array<Knife>;

	var activeTargets:Array<Target>;
	var hitTargets:Array<Target>;
	var numTargetsLeft:Int;

	// Menu
	var levelText:flixel.text.FlxText;
	var targetsLeftText:flixel.text.FlxText;
	var knivesLeftText:flixel.text.FlxText;

	var knifeType:CbType;
	var targetType:CbType;
	var wallType:CbType;
	var listener:InteractionListener;
	var knifeHitOption:OptionType;
	var listener2:InteractionListener;

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
		initializeListeners();
		loadBackground();
		loadItems();
	}

	public function initializeListeners():Void {
		knifeType = new CbType();
	   targetType = new CbType();
	   wallType = new CbType();
		knifeHitOption = new OptionType([targetType, wallType]);
		listener = new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, new OptionType(knifeType), knifeHitOption, knifeHit);
		listener2 = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, new OptionType(targetType), new OptionType(targetType), knifeHit);
	}

	public function knifeHit(cb:InteractionCallback):Void {
		trace("Knife hit?");
	}
	
	public function createLevelMenu():Void {
		remove(levelText);
		remove(targetsLeftText);
		remove(knivesLeftText);

		this.levelText = new flixel.text.FlxText(0, 10, 0, "Level " + this.curLevel, 30);
		levelText.color = FlxColor.BLACK;
		levelText.screenCenter(flixel.util.FlxAxes.X);
		add(levelText);

		var x:Int = 10;
		var y:Int = 10;
		this.targetsLeftText = new flixel.text.FlxText(x, y, 0, "Targets: " + this.numTargetsLeft, 12);
		this.knivesLeftText = new flixel.text.FlxText(x, y + 20, 0, "Knives: Infinity", 12);
		targetsLeftText.color = FlxColor.BLACK;
		knivesLeftText.color = FlxColor.BLACK;
		add(targetsLeftText);
		add(knivesLeftText);
	}

	public function loadItems():Void {
		remove(this.thrower);

		if (this.activeTargets != null) {
			for (target in this.hitTargets) {
				remove(target);
			}
		}

		if (this.knives != null) {
			for (knife in this.knives) {
				remove(knife);
			}
		}

		this.thrower = Level.getThrower(this.curLevel);
		add(thrower);
		this.cooldown = 0;

		this.hitTargets = new Array<Target>();
		this.activeTargets = Level.getTargets(this.curLevel);
		this.numTargetsLeft = this.activeTargets.length;

		for (target in this.activeTargets) {
			target.body.space = FlxNapeSpace.space;
			target.body.cbTypes.add(targetType);
			add(target);
		}
		knives = new Array<Knife>();
	}
	
	public function loadBackground():Void {
		if(FlxNapeSpace.space != null) {	// this clears old bodies
			FlxNapeSpace.space.clear();
		}
		FlxNapeSpace.init();
		FlxNapeSpace.space.gravity.setxy(0, 200);

		var platforms:Array<Platform> = Level.getPlatforms(curLevel, wallType);//new Platform(0, FlxG.height - 20, FlxG.width, 5, wallType);
		for (platform in platforms) {
			add(platform);
		}

	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		if (FlxG.keys.pressed.R) {
         FlxG.switchState(new PlayState());
		}
		
		for (target in activeTargets) {
			if (target.hit) {
				hitTargets.push(target);
				activeTargets.remove(target);
				numTargetsLeft --;
			}
		}

		if (numTargetsLeft == 0) {
			curLevel += 1;
			initializeLevel();
		}
		
		// throw knife
		if (FlxG.keys.pressed.SPACE && cooldown <= 0) {
			this.thrower.visible = false;
			this.cooldown = 0.5;

			var newKnife = new Knife(thrower.x + 12, thrower.y + 9, Math.PI * (thrower.angle) / 180);
			newKnife.body.space = FlxNapeSpace.space;
			newKnife.visible = true;
			newKnife.body.cbTypes.add(knifeType);
			knives.push(newKnife);
			add(newKnife);
		}

		if(cooldown > 0) {
			cooldown -= elapsed;
		}
		if(cooldown <= 0) {
			thrower.visible = true;
		}

	  	FlxNapeSpace.space.step(elapsed);
		this.targetsLeftText.text = "Targets: " + this.numTargetsLeft;
	}
}
