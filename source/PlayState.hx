package;

import flixel.util.FlxSpriteUtil;
import flixel.FlxObject;
import nape.phys.BodyType;
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
	var activeButtons:Array<HitButton>;
	var pressedButtons:Array<HitButton> = new Array<HitButton>();

	var activeTargets:Array<Target>;
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
	var pressRButton:FlxButton;
	var pressP:FlxSprite;
	var pressPButton:FlxButton;
	var muteMusicIcon:FlxSprite;
	var muteMusicButton:FlxButton;
	var muteSoundIcon:FlxSprite;
	var muteSoundButton:FlxButton;
	var timeTutorialText:FlxText;
	var mashTutorialText:FlxText;


	// Pause screen
	var holdingSpace:Bool = false;
	var paused:Bool = false;
	var selectButton:FlxButton;
	var resumeButton:FlxButton;
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
	var continueButton:FlxButton;
	var grayKnivesStar:FlxSprite;
	var grayTimeStar:FlxSprite;

	// Congrats Screen
	var congratsText1:flixel.text.FlxText;
	var congratsText2:flixel.text.FlxText;
	var selectButton2:FlxButton;

	override public function create():Void {
		super.create();
		this.bgColor = FlxColor.WHITE;

		this.curLevel = Main.passedLevel;
		this.curStage = 1;

		initializePauseScreen();

		initializeLevel();
	}

	public function showCongratsScreen() {
		this.congratsText1 =  new flixel.text.FlxText(0, 0, 0, "CONGRATS!", 30);
		this.congratsText1.color = FlxColor.BLACK;
		this.congratsText1.screenCenter();
		this.congratsText1.y -= 50;
		add(congratsText1);

		this.congratsText2 =  new flixel.text.FlxText(0, 0, 0, "YOU HAVE COMPLETED THE GAME\n\t\t\tDid you get all the stars?", 30);
		this.congratsText2.color = FlxColor.GRAY;
		this.congratsText2.screenCenter();
		add(congratsText2);


		this.selectButton2 = new FlxButton(280, 320, "Level Select", ()->{FlxG.switchState(new LevelSelect());});
		this.selectButton2.screenCenter();
		this.selectButton2.y += 50;
		add(selectButton2);
	}

	public function initializePauseScreen() {
		this.pauseText =  new flixel.text.FlxText(0, 0, 0, "PAUSED", 45);
		this.pauseText.color = FlxColor.BLACK;
		this.pauseText.screenCenter();
		this.pauseText.y -= 90;
		
		this.selectButton = new FlxButton(280, 320, "Level Select", ()->{FlxG.switchState(new LevelSelect());});
		this.selectButton.screenCenter();
		this.selectButton.y += 5;
		this.resumeButton = new FlxButton(0, 0, "Resume", pauseGame);
		this.resumeButton.screenCenter();
		this.resumeButton.y -= 30;
	}

	// to be called when loading a new level
	public function initializeLevel() {

		if (curLevel > Level.MAX_LEVEL) {
			removeTextItems();
			removeItems();
			showCongratsScreen();
			return;
		}
		
		Main.LOGGER.logLevelStart(Level.getStageId(curLevel, curStage), {
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

		if (pressSpace != null) {
			remove(pressSpace);
			pressSpace = null;
		}
		if (timeTutorialText != null) {
			remove(timeTutorialText);
			timeTutorialText = null;
		}
		if (mashTutorialText != null) {
			remove(mashTutorialText);
			mashTutorialText = null;
		}

		// tutorial
		if (this.curLevel == 1 && this.curStage == 1) {
			showTutorial();
		} else if (this.curLevel == 4 && this.curStage == 2) {
			showTimeTutorial();
		} else if (this.curLevel == 2 && this.curStage == 1) {
			showMashTutorial();
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
	public function showTimeTutorial() {
		this.timeTutorialText = new flixel.text.FlxText(FlxG.width - 350, FlxG.height - 100, 0, "Some buttons\nare timed!", 22);
		timeTutorialText.color = FlxColor.BLACK;
		add(timeTutorialText);
	}
	public function showMashTutorial() {
		this.mashTutorialText = new flixel.text.FlxText(FlxG.width - 550, FlxG.height - 100, 0, "Blue buttons take several hits to knock down,\ntry rapidly mashing space and clicking\nto destroy them quickly!", 16);
		mashTutorialText.color = FlxColor.BLACK;
		add(mashTutorialText);
	}

	public function removeTextItems() {
		remove(congratsText1);
		remove(congratsText2);
		remove(selectButton2);

		remove(winnerText);
		remove(timeText);
		remove(knivesText);
		remove(pressEnterText);
		remove(continueButton);
		remove(completeStar);
		remove(knivesStar);
		remove(timeStar);
		remove(timeIconVictory);
		remove(grayKnivesStar);
		remove(grayTimeStar);

		remove(levelText);
		remove(targetsLeftText);
		remove(knivesLeftText);
		remove(timeIcon);
		remove(timerText);

		remove(pressR);
		remove(pressRButton);
		remove(pressP);
		remove(pressPButton);
		remove(muteMusicButton);
		remove(muteMusicIcon);
		remove(muteSoundButton);
		remove(muteSoundIcon);
	}

	public function createLevelMenu():Void {
		removeTextItems();

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

		pressR = new FlxSprite(FlxG.width - 120, menuY);
		pressR.loadGraphic("assets/images/RButton-2.png", false, 32, 32);
		add(pressR);
		pressRButton = new FlxButton(FlxG.width - 100, menuY, "Restart", ()->{this.curStage = 1;initializeLevel();});
		add(pressRButton);

		pressP = new FlxSprite(FlxG.width - 120, menuY + 30);
		pressP.loadGraphic("assets/images/PButton.png", false, 32, 32);
		add(pressP);
		pressPButton = new FlxButton(FlxG.width - 100, menuY + 30, "Pause", pauseGame);
		add(pressPButton);

		muteMusicIcon = new FlxSprite(FlxG.width - 120, menuY + 60);
		muteMusicIcon.loadGraphic("assets/images/musicIcon.png", false, 32, 32);
		add(muteMusicIcon);
		muteMusicButton = new FlxButton(FlxG.width - 100, menuY + 60, "Music", muteMusic);
		add(muteMusicButton);

		muteSoundIcon = new FlxSprite(FlxG.width - 120, menuY + 90);
		muteSoundIcon.loadGraphic("assets/images/soundIcon.png", false, 32, 32);
		add(muteSoundIcon);
		muteSoundButton = new FlxButton(FlxG.width - 100, menuY + 90, "All Sound", muteSound);
		add(muteSoundButton);
	}

	public function muteMusic():Void {
		if (Main.blippy.playing) {
			Main.blippy.pause();
		} else {
			Main.blippy.resume();
		}
	}
	
	public function muteSound():Void {
		FlxG.sound.toggleMuted();
	}

	public function removeItems():Void {
		if(this.platforms != null) {
			for (platform in this.platforms) {
				remove(platform);
			}
		}

		remove(this.thrower);

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

		if (this.activeButtons != null) {
			for (button in this.activeButtons) {
				remove(button);
				remove(button.gate);
			}
		}
		
		if (this.pressedButtons != null) {
			for (button in this.pressedButtons) {
				remove(button);
				remove(button.gate);
				pressedButtons.remove(button);
			}
		}

	}

	public function loadItems():Void {
		remove(this.thrower);

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
		FlxNapeSpace.space.gravity.setxy(0, 750);
		
		if(this.platforms != null) {
			for (platform in this.platforms) {
				remove(platform);
			}
		}

		this.platforms = Level.getPlatforms(curLevel, curStage);
		for (platform in this.platforms) {
			add(platform);
		}

		if (this.activeButtons != null) {
			for (button in this.activeButtons) {
				remove(button);
				remove(button.gate);
			}
		}
		
		if (this.pressedButtons != null) {
			for (button in this.pressedButtons) {
				remove(button);
				remove(button.gate);
				pressedButtons.remove(button);
			}
		}

		activeButtons = Level.getButtons(curLevel, curStage);
		for (button in activeButtons) {
			add(button);
			add(button.gate);

		}
	}

	function pauseGame():Void {
		paused = !paused;
		if (paused) {
			add(pauseText);
			add(resumeButton);
			add(selectButton);
			thrower.visible = false;
			FlxNapeSpace.space.gravity.setxy(0, 0);
		} else {
			remove(pauseText);
			remove(resumeButton);
			remove(selectButton);
			thrower.visible = true;
			FlxNapeSpace.space.gravity.setxy(0, 400);
		}
		for (target in activeTargets) {
			target.pauseMe(paused);
		}
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		if(FlxG.keys.justReleased.SPACE) {
			holdingSpace = false;
		}
		if (FlxG.keys.justPressed.M) {
			muteSound();
		}
		// restart level
		if (FlxG.keys.justPressed.R) {
			this.curStage = 1;
			initializeLevel();
		}
		if(victory) {
			if (FlxG.keys.pressed.ENTER) {
				curStage = 1;
				curLevel ++;
				initializeLevel();
			}
			return;
		}
		if (pressRButton.pressed || pressPButton.pressed || muteSoundButton.pressed || muteMusicButton.pressed) {
			return;
		}

		// pause menu
		if (FlxG.keys.justPressed.P || FlxG.keys.justPressed.ESCAPE) {
			pauseGame();
		}
		if (paused) {
			return;
		}

		for (knife in unstuckKnives) {
			if (knife.stuck) {
				continue;
			}
			for (target in activeTargets) {
				if (target.isBig ? FlxG.pixelPerfectOverlap(knife, target, 10) : FlxG.pixelPerfectOverlap(knife, target, 0)) {
					unstuckKnives.remove(knife);

					if (!target.hit) {
						target.hp --;
						if (target.hp == 0) {
							target.hit = true;
							numTargetsLeft --;
      						target.body.type = BodyType.DYNAMIC;
						}
						if (target.isBig) {
							target.animation.play("" + target.hp);
						}
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
					break;
				}
			}
			for (button in activeButtons) {
				if (FlxG.pixelPerfectOverlap(knife, button, 0)) {
					unstuckKnives.remove(knife);
					knife.stuck = true;
					knife.body.type = BodyType.STATIC;
					knife.body.space = null;
					button.button_sound.play();
					activeButtons.remove(button);
					pressedButtons.push(button);
					button.animation.play("pressed");
					button.gate.toggleGate();
					button.startTimer();
				} else if (!button.gate.open && FlxG.pixelPerfectOverlap(knife, button.gate, 2)) {
					trace("hit detected on gate");
					unstuckKnives.remove(knife);
					button.gate.embedKnife(knife);

				}
			}
		}
		for (button in pressedButtons) {
			if (button.addMe) { 
				button.addMe = false;
				activeButtons.push(button);
				pressedButtons.remove(button);
			}
		}

		if (numTargetsLeft == 0) {
			if(curStage != levelStats.numStages) {
				curStage ++;
				initializeLevel();
				Main.LOGGER.logLevelEnd({
					knivesThrown: knivesThrown,
					time: timer
				});
			} else {
				showVictoryScreen();
				Main.LOGGER.logLevelEnd({
					knivesThrown: knivesThrown,
					time: timer,
					completeStar: true,
					timeStar: Std.int(this.timer) <= Std.int(this.levelStats.timePar),
					knivesStar: this.knivesThrown <= this.levelStats.knivesPar
				});
			}
		}
		
		// update knife
		if (!victory && (FlxG.keys.justPressed.SPACE || FlxG.mouse.justPressed) && !holdingSpace) {

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

		// targets
		for (target in activeTargets) {
			// ceiling
			if (FlxG.overlap(target, platforms[0])) {
				target.collide(1, -1);
			}
			// floor
			if (FlxG.overlap(target, platforms[1])) {
				target.collide(1, -1);
			}

			// left wall
			if (FlxG.overlap(target, platforms[2])) {
				target.collide(-1, 1);
			}
			// right wall
			if (FlxG.overlap(target, platforms[3])) {
				target.collide(-1, 1);
			}
		}

		timer += elapsed;

		updateTexts();
	}
	
	function showVictoryScreen() {
		victory = true;
		winnerText = new flixel.text.FlxText((FlxG.width / 2)- 250, (FlxG.height / 2) - 130, 0, "Level " + (this.curLevel) + " Complete!", 45);
		timeText = new flixel.text.FlxText((FlxG.width / 2)- 252, (FlxG.height / 2) - 70, 0, "    : " + Std.int(this.timer) + "s. Par: " + Std.int(this.levelStats.timePar) + " s.", 30);
		knivesText = new flixel.text.FlxText((FlxG.width / 2)- 250, (FlxG.height / 2) - 30, 0, "Knives Thrown: " + this.knivesThrown + ". Par: " + this.levelStats.knivesPar + ".", 30);
		pressEnterText = new flixel.text.FlxText((FlxG.width / 2) - 230, (FlxG.height / 2) + 25, 0, "\t\t\t\t\t\tOr press ENTER", 25);
		continueButton = new FlxButton((FlxG.width / 2) - 260, (FlxG.height / 2) + 30, "CONTINUE", ()->{curStage = 1;curLevel ++;initializeLevel();});
		winnerText.color = FlxColor.BLACK;
		timeText.color = FlxColor.BLACK;
		knivesText.color = FlxColor.BLACK;
		pressEnterText.color = FlxColor.BLACK;

		completeStar = new FlxSprite(0, (FlxG.height / 2) - 110, "assets/images/star.png");
		knivesStar = new FlxSprite(0, (FlxG.height / 2) - 20, "assets/images/star.png");
		grayKnivesStar = new FlxSprite(0, (FlxG.height / 2) - 20, "assets/images/grayStar.png");
		timeStar = new FlxSprite(0, (FlxG.height / 2) - 60, "assets/images/star.png");
		grayTimeStar = new FlxSprite(0, (FlxG.height / 2) - 60, "assets/images/grayStar.png");
		timeIconVictory = new FlxSprite((FlxG.width / 2)- 240, (FlxG.height / 2) - 60, "assets/images/stopwatch.png");
	
		completeStar.x = 15 + winnerText.x + winnerText.width;
		knivesStar.x = 15 + knivesText.x + knivesText.width;
		grayKnivesStar.x = 15 + knivesText.x + knivesText.width;
		timeStar.x = 15 + timeText.x + timeText.width;
		grayTimeStar.x = 15 + timeText.x + timeText.width;

		completeStar.scale.set(2, 2);
		knivesStar.scale.set(2, 2);
		timeStar.scale.set(2, 2);
		timeIconVictory.scale.set(2, 2);
		grayKnivesStar.scale.set(2, 2);
		grayTimeStar.scale.set(2, 2);

		add(continueButton);
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
		} else {
			add(grayTimeStar);
		}
		if (this.knivesThrown <= this.levelStats.knivesPar) {
			add(knivesStar);
			Cookie.set(curLevel + "K", "", Main.expireDelay);
		} else {
			add(grayKnivesStar);
		}
		add(timeIconVictory);
	}

	function updateTexts() {
		knivesLeftText.text = "Knives Thrown: " + this.knivesThrown;
		this.targetsLeftText.text = "Targets: " + this.numTargetsLeft;
		timerText.text = "      : " + Std.int(timer);
	}
}


