package;

import nape.phys.Compound;
import nape.geom.Vec2;
import nape.constraint.WeldJoint;
import js.Cookie;
import flixel.text.FlxText;
import haxe.Timer;
import flixel.FlxSprite;
import flixel.addons.nape.FlxNapeSpace;
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
	var curStage:Int;
	var levelStats:LevelStats;
	var timer:Float;

	// Level Stats
	var knivesPar:Int;
	var timePar:Float;
	var victory:Bool = false;

	// Sprites
	var thrower:Thrower;
	// var cooldown:Float;

	var knife:Knife;
	var knivesThrown:Int = 0;
	var knives:Array<Knife>;
	var unstuckKnives:Array<Knife>;

	var platforms:Array<Platform>;
	var activeTargets:Array<Target>;
	var hitTargets:Array<Target>;
	var numTargetsLeft:Int;

	// Menu
	var levelText:flixel.text.FlxText;
	var targetsLeftText:flixel.text.FlxText;
	var knivesLeftText:flixel.text.FlxText;
	var timerText:flixel.text.FlxText;
	var timeIcon:FlxSprite;
	var menuX:Int = 10;
	var menuY:Int = 10;
	var pressR:FlxSprite;
	var pressRText:FlxText;
	var pressP:FlxSprite;
	var pressPText:FlxText;

	// Pause screen
	var holdingSpace:Bool = false;
	var paused:Bool = false;
	var selectButton:FlxButton;
	var pauseText:flixel.text.FlxText;

	// Tutorial
	var pressSpace:FlxSprite;

	// Victory Screen
	var winnerText:flixel.text.FlxText;
	var timeText:flixel.text.FlxText;
	var knivesText:flixel.text.FlxText;
	var pressEnterText:flixel.text.FlxText;

	var completeStar:FlxSprite;
	var knivesStar:FlxSprite;
	var timeStar:FlxSprite;
	var timeIconVictory:FlxSprite;

	override public function create():Void {
		super.create();
		this.bgColor = FlxColor.WHITE;

		this.curLevel = Main.passedLevel;
		this.curStage = 1;

		initializePauseScreen();

		initializeLevel();
	}

	public function initializePauseScreen() {
		this.pauseText =  new flixel.text.FlxText(0, 0, 0, "PAUSED", 45);
		this.pauseText.color = FlxColor.BLACK;
		this.pauseText.screenCenter();
		this.pauseText.y -= 90;
		
		this.selectButton = new FlxButton(280, 320, "Level Select", ()->{FlxG.switchState(new LevelSelect());});
		this.selectButton.screenCenter();
	}

	// to be called when loading a new level
	public function initializeLevel() {
		trace("Level: " + curLevel + ". Stage: " + curStage);
		Main.LOGGER.logLevelStart(curLevel, {
			level: curLevel,
			stage: curStage}
		);

		if(FlxNapeSpace.space != null) {	// this clears old bodies
			FlxNapeSpace.space.clear();
		}
		holdingSpace = FlxG.keys.pressed.SPACE;
		this.levelStats = Level.getLevelStats(this.curLevel);
		victory = false;
		
		// Display Level
		createLevelMenu();

		// Must load background before targets
		loadBackground();
		loadItems();

		// tutorial
		if (this.curLevel == 1 && this.curStage == 1) {
			showTutorial();
		}
		if (pressSpace != null) {
			remove(pressSpace);
		}
	}

	public function showTutorial() {
		pressSpace = new FlxSprite(FlxG.width - 256, FlxG.height - 64);
		pressSpace.loadGraphic("assets/images/pressSpace.png", true, 32, 32);
		pressSpace.scale.set(3, 3);
		pressSpace.animation.add("static", [0, 1], 1);
		pressSpace.animation.play("static");
		add(pressSpace);
	}
	
	public function createLevelMenu():Void {
		remove(winnerText);
		remove(timeText);
		remove(knivesText);
		remove(pressEnterText);
		remove(completeStar);
		remove(knivesStar);
		remove(timeStar);
		remove(timeIconVictory);

		remove(levelText);
		remove(targetsLeftText);
		remove(knivesLeftText);
		remove(timeIcon);
		remove(timerText);

		remove(pressR);
		remove(pressRText);
		remove(pressP);
		remove(pressPText);

		// reset tracked statistics
		if(this.curStage == 1) {
			knivesThrown = 0;
			timer = 0;
		}

		this.levelText = new flixel.text.FlxText(0, 10, 0, "Level " + (this.curLevel) + " - " + (this.curStage), 30);
		levelText.color = FlxColor.BLACK;
		levelText.screenCenter(flixel.util.FlxAxes.X);
		add(levelText);

		this.targetsLeftText = new flixel.text.FlxText(menuX, menuY, 0, "", 12);
		this.knivesLeftText = new flixel.text.FlxText(menuX, menuY + 20, 0, "Knives Thrown: 0" , 12);
		this.timerText = new flixel.text.FlxText(menuX, menuY + 45, 0, "      : " + timer);
		this.timeIcon = new FlxSprite(0 + 18, 10 + 48, "assets/images/stopwatch.png");
		timeIcon.scale.set(2, 2);

		targetsLeftText.color = FlxColor.BLACK;
		knivesLeftText.color = FlxColor.BLACK;
		timerText.color = FlxColor.BLACK;
		timerText.size += 10;
		add(targetsLeftText);
		add(knivesLeftText);
		add(timerText);
		add(timeIcon);

		pressR = new FlxSprite(FlxG.width - 100, menuY);
		pressR.loadGraphic("assets/images/RButton-2.png", false, 32, 32);
		add(pressR);
		pressRText = new flixel.text.FlxText(FlxG.width - 83, menuY, " Restart", 12);
		pressRText.color = FlxColor.BLACK;
		add(pressRText);

		pressP = new FlxSprite(FlxG.width - 100, menuY + 20);
		pressP.loadGraphic("assets/images/PButton.png", false, 32, 32);
		add(pressP);
		pressPText = new flixel.text.FlxText(FlxG.width - 83, menuY + 20, " Pause", 12);
		pressPText.color = FlxColor.BLACK;
		add(pressPText);
	}

	public function loadItems():Void {
		remove(this.thrower);

		if (this.hitTargets != null) {
			for (target in this.hitTargets) {
				remove(target);
			}
		}

		if (this.activeTargets != null) {
			for (target in this.activeTargets) {
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
		// this.cooldown = 0;

		this.hitTargets = new Array<Target>();
		trace("In playstate, curStage is " + this.curStage);
		this.activeTargets = Level.getTargets(this.curLevel, this.curStage);

		// game status
		this.numTargetsLeft = this.activeTargets.length;
		this.targetsLeftText.text = "Targets: " + this.numTargetsLeft;
		this.knivesLeftText.text = "Knives Thrown: " + this.knivesThrown;

		for (target in this.activeTargets) {
			target.body.space = FlxNapeSpace.space;
			add(target);
		}
		knives = new Array<Knife>();
		unstuckKnives = new Array<Knife>();
	}
	
	public function loadBackground():Void {
		FlxNapeSpace.init();
		FlxNapeSpace.space.gravity.setxy(0, 400);
		
		if(this.platforms != null) {
			for (platform in this.platforms) {
				remove(platform);
			}
		}

		platforms = Level.getPlatforms(curLevel);
		for (platform in platforms) {
			add(platform);
		}

	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		if(FlxG.keys.justReleased.SPACE) {
			holdingSpace = false;
		}
		if(victory) {
			if (FlxG.keys.pressed.ENTER) {
				curStage = 1;
				curLevel ++;
				initializeLevel();
			}
			return;
		}

		// pause menu
		if (FlxG.keys.justPressed.P || FlxG.keys.justPressed.ESCAPE) {
			paused = !paused;
			if (paused) {
				add(pauseText);
				add(selectButton);
				thrower.visible = false;
				FlxNapeSpace.space.gravity.setxy(0, 0);
			} else {
				remove(pauseText);
				remove(selectButton);
				thrower.visible = true;
				FlxNapeSpace.space.gravity.setxy(0, 400);
			}
		}
		if (paused) {
			return;
		}

		// restart level
		if (FlxG.keys.justPressed.R) {
			this.curStage = 1;
			initializeLevel();
		}

		for (knife in unstuckKnives) {
			if (knife.stuck) {
				continue;
			}
			for (target in activeTargets) {
				if (FlxG.pixelPerfectOverlap(knife, target, 0)) {
					unstuckKnives.remove(knife);
					hitTargets.push(target);
					// activeTargets.remove(target);
					if (!target.hit) {
						numTargetsLeft --;
						target.hit = true;
					}
					updateTexts();
					
					var anchor1:Vec2 = knife.body.worldPointToLocal(knife.body.position);
					var anchor2:Vec2 = target.body.worldPointToLocal(knife.body.position);
					var phase:Float = knife.body.rotation - target.body.rotation;
					var pivotJoint = new WeldJoint(knife.body, target.body, anchor1, anchor2, phase);
					FlxNapeSpace.space.constraints.add(pivotJoint);
					knife.stickTarget(target);

					
				// logging: 2 for hitting target
				Main.LOGGER.logLevelAction(2, {
					targetsLeft: numTargetsLeft,
					knivesThrown: knivesThrown,
					time: timer 
				});
				}
			}
		}

		if (numTargetsLeft == 0) {
			Main.LOGGER.logLevelEnd({
				knivesThrown: knivesThrown,
				time: timer
			});
			if(curStage != levelStats.numStages) {
				curStage ++;
				initializeLevel();
			} else {
				showVictoryScreen();
			}
		}
		
		// update knife
		if (!victory && FlxG.keys.justPressed.SPACE && !holdingSpace) {
			// this.thrower.visible = false;
			// this.cooldown = 0.5;

			var newKnife = new Knife(thrower.x + 12, thrower.y + 9, Math.PI * (thrower.angle - 2) / 180);
			newKnife.body.space = FlxNapeSpace.space;
			newKnife.visible = true;
			knives.push(newKnife);
			unstuckKnives.push(newKnife);
			add(newKnife);

			knivesThrown += 1;

			// 1 for throwing knife
			Main.LOGGER.logLevelAction(1, {
				targetsLeft: numTargetsLeft,
				knivesThrown: knivesThrown,
				time: timer 
			});
		}

		// if(cooldown > 0) {
		// 	cooldown -= elapsed;
		// }
		// if(cooldown <= 0) {
		// 	thrower.visible = true;
		// }

		timer += elapsed;

		updateTexts();
	}
	
	function showVictoryScreen() {
		victory = true;
		winnerText = new flixel.text.FlxText((FlxG.width / 2)- 250, (FlxG.height / 2) - 80, 0, "Level " + (this.curLevel) + " Complete!", 45);
		timeText = new flixel.text.FlxText((FlxG.width / 2)- 252, (FlxG.height / 2), 0, "    : " + Std.int(this.timer) + "s. Par: " + Std.int(this.levelStats.timePar) + " s.", 30);
		knivesText = new flixel.text.FlxText((FlxG.width / 2)- 250, (FlxG.height / 2) + 40, 0, "Knives Thrown: " + this.knivesThrown + ". Par: " + this.levelStats.knivesPar + ".", 30);
		pressEnterText = new flixel.text.FlxText((FlxG.width / 2) - 250, (FlxG.height / 2) + 100, 0, "Press Enter to continue", 25);
		winnerText.color = FlxColor.BLACK;
		timeText.color = FlxColor.BLACK;
		knivesText.color = FlxColor.BLACK;
		pressEnterText.color = FlxColor.BLACK;

		completeStar = new FlxSprite(0, (FlxG.height / 2) - 64, "assets/images/star.png");
		knivesStar = new FlxSprite(0, (FlxG.height / 2) + 50, "assets/images/star.png");
		timeStar = new FlxSprite(0, (FlxG.height / 2) + 10, "assets/images/star.png");
		timeIconVictory = new FlxSprite((FlxG.width / 2)- 240, (FlxG.height / 2) + 10, "assets/images/stopwatch.png");
	
		completeStar.x = 15 + winnerText.x + winnerText.width;
		knivesStar.x = 15 + knivesText.x + knivesText.width;
		timeStar.x = 15 + timeText.x + timeText.width;

		completeStar.scale.set(2, 2);
		knivesStar.scale.set(2, 2);
		timeStar.scale.set(2, 2);
		timeIconVictory.scale.set(2, 2);

		add(winnerText);
		add(timeText);
		add(knivesText);
		add(pressEnterText);

		add(completeStar);
		var maxLevel:Int = Std.parseInt(Cookie.get("MaxLevel"));
		if(curLevel >= maxLevel) {
			Cookie.set("MaxLevel", "" + (curLevel + 1), Main.expireDelay);
		}
		if (Std.int(this.timer) <= Std.int(this.levelStats.timePar)) {
			add(timeStar);
			Cookie.set(curLevel + "T", "", Main.expireDelay);
		}
		if (this.knivesThrown <= this.levelStats.knivesPar) {
			add(knivesStar);
			Cookie.set(curLevel + "K", "", Main.expireDelay);
		}
		add(timeIconVictory);
	}

	function updateTexts() {
		knivesLeftText.text = "Knives Thrown: " + this.knivesThrown;
		this.targetsLeftText.text = "Targets: " + this.numTargetsLeft;
		timerText.text = "      : " + Std.int(timer);
	}
}


