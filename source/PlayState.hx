package;

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

	// Level Stats
	var knivesPar:Int;
	var timePar:Float;
	var victory:Bool = false;

	// Sprites
	var thrower:Thrower;
	var cooldown:Float;

	var knife:Knife;
	var knivesThrown:Int;
	var knives:Array<Knife>;

	var platforms:Array<Platform>;
	var activeTargets:Array<Target>;
	var hitTargets:Array<Target>;
	var numTargetsLeft:Int;

	// Menu
	var levelText:flixel.text.FlxText;
	var targetsLeftText:flixel.text.FlxText;
	var knivesLeftText:flixel.text.FlxText;
	var timerText:flixel.text.FlxText;
	var menuX:Int = 10;
	var menuY:Int = 10;
	var pressR:FlxSprite;
	var pressRText:FlxText;
	var pressP:FlxSprite;
	var pressPText:FlxText;

	var holdingSpace:Bool = false;
	var paused:Bool = false;
	var selectButton = new FlxButton(280, 320, "Level Select", ()->{FlxG.switchState(new LevelSelect());});
	override public function create():Void {
		super.create();
		this.bgColor = FlxColor.WHITE;
		this.pauseText.color = FlxColor.BLACK;
		this.pauseText.screenCenter();
		this.selectButton.screenCenter();
		this.pauseText.y -= 90;
		this.pauseText2.color = FlxColor.BLACK;
		this.pauseText2.screenCenter();
		this.pauseText2.y -= 40;

		this.curLevel = Main.passedLevel;
		this.curStage = 0;

		knivesStar.scale.set(2, 2);
		completeStar.scale.set(2, 2);
		timeStar.scale.set(2, 2);
		timeIcon.scale.set(2, 2);
		timeIconVictory.scale.set(2, 2);
		initializeLevel();
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
	}

	// only needed for one call and remove later
	var pressSpace:FlxSprite;

	var timer:Float;
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

		this.levelText = new flixel.text.FlxText(0, 10, 0, "Level " + (this.curLevel + 1) + " - " + (this.curStage + 1), 30);
		levelText.color = FlxColor.BLACK;
		levelText.screenCenter(flixel.util.FlxAxes.X);
		add(levelText);

		// reset tracked statistics
		if(this.curStage == 0) {
			knivesThrown = 0;
			timer = 0;
		}

		this.targetsLeftText = new flixel.text.FlxText(menuX, menuY, 0, "", 12);
		this.knivesLeftText = new flixel.text.FlxText(menuX, menuY + 20, 0, "Knives Thrown: " + knivesThrown, 12);
		this.timerText = new flixel.text.FlxText(menuX, menuY + 45, 0, "      : " + timer);
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
		pressRText = new flixel.text.FlxText(FlxG.width - 83, menuY, "Restart", 12);
		pressRText.color = FlxColor.BLACK;
		add(pressRText);

		pressP = new FlxSprite(FlxG.width - 100, menuY + 20);
		pressP.loadGraphic("assets/images/PButton.png", false, 32, 32);
		add(pressP);
		pressPText = new flixel.text.FlxText(FlxG.width - 83, menuY + 20, "Pause", 12);
		pressPText.color = FlxColor.BLACK;
		add(pressPText);

		// special cases:
		// tutorial
		if (this.curLevel == 0 && this.curStage == 0) {
			if (pressSpace != null) {
				remove(pressSpace);
			}
			pressSpace = new FlxSprite(FlxG.width - 256, FlxG.height - 64);
			pressSpace.loadGraphic("assets/images/pressSpace.png", true, 32, 32);
			pressSpace.scale.set(3, 3);
			pressSpace.animation.add("static", [0, 1], 1);
			pressSpace.animation.play("static");
			add(pressSpace);
		} else if (this.curLevel == 0 && this.curStage == 1) {
			if (pressSpace != null) {
				remove(pressSpace);
			}
		}
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
		this.cooldown = 0;

		this.hitTargets = new Array<Target>();
		this.activeTargets = Level.getTargets(this.curLevel, this.curStage);
		this.numTargetsLeft = this.activeTargets.length;
		targetsLeftText.text = "Targets: " + this.numTargetsLeft;

		for (target in this.activeTargets) {
			target.body.space = FlxNapeSpace.space;
			add(target);
		}
		knives = new Array<Knife>();
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

	var pauseText:flixel.text.FlxText = new flixel.text.FlxText(0, 0, 0, "PAUSED", 45);
	var pauseText2:flixel.text.FlxText = new flixel.text.FlxText(0, 0, 0, "Press P or ESC to resume", 45);
	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		if(FlxG.keys.justReleased.SPACE) {
			holdingSpace = false;
		}
		if(victory) {
			if (FlxG.keys.pressed.ENTER) {
				curStage = 0;
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
		if (FlxG.keys.justPressed.R) {
			curStage = 0;
			initializeLevel();
		}
		
		for (target in activeTargets) {
			if (target.hit) {
				hitTargets.push(target);
				activeTargets.remove(target);
				numTargetsLeft --;
				this.targetsLeftText.text = "Targets: " + this.numTargetsLeft;

				// 2 for hitting target
				Main.LOGGER.logLevelAction(2, {
					targetsLeft: numTargetsLeft,
					knivesThrown: knivesThrown,
					time: timer 
				});
			}
		}

		if (numTargetsLeft == 0) {
			Main.LOGGER.logLevelEnd({
				knivesThrown: knivesThrown,
				time: timer
			});
			if(curStage < (levelStats.numStages - 1)) {
				curStage ++;
				initializeLevel();
			} else {
				victoryScreen();
			}
		}
		
		// throw knife
		if (!victory && FlxG.keys.justPressed.SPACE && !holdingSpace) {
			// this.thrower.visible = false;
			// this.cooldown = 0.5;

			var newKnife = new Knife(thrower.x + 12, thrower.y + 9, Math.PI * (thrower.angle - 2) / 180);
			newKnife.body.space = FlxNapeSpace.space;
			newKnife.visible = true;
			knives.push(newKnife);
			add(newKnife);
			updateTexts(elapsed);

			// 1 for throwing knife
			Main.LOGGER.logLevelAction(1, {
				targetsLeft: numTargetsLeft,
				knivesTrhown: knivesThrown,
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
		timerText.text = "      : " + Std.int(timer);
	}


	var winnerText:flixel.text.FlxText;
	var timeText:flixel.text.FlxText;
	var knivesText:flixel.text.FlxText;
	var pressEnterText:flixel.text.FlxText;

	var completeStar:FlxSprite = new FlxSprite(0, (FlxG.height / 2) - 64, "assets/images/star.png");
	var knivesStar:FlxSprite = new FlxSprite(0, (FlxG.height / 2) + 50, "assets/images/star.png");
	var timeStar:FlxSprite = new FlxSprite(0, (FlxG.height / 2) + 10, "assets/images/star.png");
	var timeIcon:FlxSprite = new FlxSprite(0 + 18, 10 + 48, "assets/images/stopwatch.png");
	var timeIconVictory:FlxSprite = new FlxSprite((FlxG.width / 2)- 240, (FlxG.height / 2) + 10, "assets/images/stopwatch.png");
	function victoryScreen() {
		victory = true;
		winnerText = new flixel.text.FlxText((FlxG.width / 2)- 250, (FlxG.height / 2) - 80, 0, "Level " + (this.curLevel + 1) + " Complete!", 45);
		timeText = new flixel.text.FlxText((FlxG.width / 2)- 252, (FlxG.height / 2), 0, "    : " + Std.int(this.timer) + "s. Par: " + Std.int(this.levelStats.timePar) + " s.", 30);
		knivesText = new flixel.text.FlxText((FlxG.width / 2)- 250, (FlxG.height / 2) + 40, 0, "Knives Thrown: " + this.knivesThrown + ". Par: " + this.levelStats.knivesPar + ".", 30);
		pressEnterText = new flixel.text.FlxText((FlxG.width / 2) - 250, (FlxG.height / 2) + 100, 0, "Press Enter to continue", 25);
		winnerText.color = FlxColor.BLACK;
		timeText.color = FlxColor.BLACK;
		knivesText.color = FlxColor.BLACK;
		pressEnterText.color = FlxColor.BLACK;
		completeStar.x = 15 + winnerText.x + winnerText.width;
		knivesStar.x = 15 + knivesText.x + knivesText.width;
		timeStar.x = 15 + timeText.x + timeText.width;

		add(winnerText);
		add(timeText);
		add(knivesText);
		add(pressEnterText);

		add(timeIconVictory);
		
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
	}

	function updateTexts(elapsed:Float) {
		knivesThrown ++;
		knivesLeftText.text = "Knives Thrown: " + knivesThrown;
	}
}


