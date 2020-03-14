import js.Cookie;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.FlxState;


class CongratsScreen extends FlxState {

    var leftButtonX:Int = -350;

    var congratsText1:flixel.text.FlxText;
    var congratsText2:flixel.text.FlxText;
    var congratsText3:flixel.text.FlxText;
    var selectButton2:FlxButton;

    override public function create():Void {
        super.create();
        this.bgColor = FlxColor.WHITE;
        
		// Welcome text
        // var text = new flixel.text.FlxText(0, 0, 0, "Level Select", 64);
        // text.color = FlxColor.BLACK;
        // text.screenCenter();
        // text.y -= 200;
        // add(text);
        this.congratsText1 =  new flixel.text.FlxText(0, 0, 0, "CONGRATS!", 40);
		this.congratsText1.color = FlxColor.BLACK;
		this.congratsText1.screenCenter();
		this.congratsText1.y -= 200;
        add(congratsText1);

        this.congratsText3 =  new flixel.text.FlxText(0, 0, 0, "YOU HAVE COMPLETED THE GAME", 30);
		this.congratsText3.color = FlxColor.BLACK;
		this.congratsText3.screenCenter();
		this.congratsText3.y -= 155;
        add(congratsText3);
        
		this.congratsText2 =  new flixel.text.FlxText(0, 0, 0, "Did you get all the stars?", 30);
		this.congratsText2.color = FlxColor.GRAY;
		this.congratsText2.screenCenter();
		this.congratsText2.y -= 70;
		add(congratsText2);


		this.selectButton2 = new FlxButton(280, 320, "Level Select", ()->{FlxG.switchState(new LevelSelect());});
		this.selectButton2.screenCenter();
		this.selectButton2.y += 200;
		add(selectButton2);

        // Buttons to Select
        var i = 1;
        var buttonX:Int = leftButtonX;
        var buttonY:Int = -80;
        var maxLevel:Int = Std.parseInt(Cookie.get("MaxLevel"));
        while (i < 25 && i <= maxLevel && i <= Level.MAX_LEVEL) {
            var x = i;
            if((i - 1) % 5 == 0) {
                buttonY += 80;
                buttonX = leftButtonX;
            }
            buttonX += 100;
            var playButton = new FlxButton((FlxG.width / 2 + buttonX), (FlxG.height / 2) + buttonY, "Level " + (i), ()->{clickPlay(x);});

            var j:Int = 0;
            while (j < 4) {
                if (maxLevel == i) {
                } else if (j == 0 && Cookie.exists(i + "M")) {
                    var star:FlxSprite = new FlxSprite(playButton.x + 19, playButton.y + 3, "assets/images/kunai.png");
                    star.angle = 40;
                    star.scale.set(3, 3);
                    add(star);
                } else if (j == 1 && Cookie.exists(i + "C")) {
                    var star:FlxSprite = new FlxSprite(playButton.x + 4 + (25 * (j - 1)), playButton.y - 15, "assets/images/star.png");
                    add(star);
                } else if (j == 2 && Cookie.exists(i + "T")) {
                    var star:FlxSprite = new FlxSprite(playButton.x + 4 + (25 * (j - 1)), playButton.y - 15, "assets/images/star.png");
                    add(star);
                } else if (j == 3 && Cookie.exists(i + "K")) {
                    var star:FlxSprite = new FlxSprite(playButton.x + 4 + (25 * (j - 1)), playButton.y - 15, "assets/images/star.png");
                    add(star);
                } else if (j != 0) {
                    var star:FlxSprite = new FlxSprite(playButton.x + 4 + (25 * (j - 1)), playButton.y - 15, "assets/images/grayStar.png");
                    add(star);
                }
                j++;
            }
            i++;
            add(playButton);
        }

        // var clearButton = new FlxButton(FlxG.width - 120, FlxG.height - 30, "Clear all data", clearData);
        // add(clearButton);

        // var backButton = new FlxButton(0, 0, "Main Menu", ()->{FlxG.switchState(new MenuState());});
        // backButton.screenCenter();
        // backButton.y += 100;
        // add(backButton);
    }

    override public function update(elapsed:Float):Void {
            super.update(elapsed);
    }

    function clearData():Void {
        var cookies = Cookie.all();
        for (cookie in cookies.keys()) {
            Cookie.remove(cookie);
        }
        Cookie.set("MaxLevel", "1", Main.expireDelay);
        FlxG.switchState(new LevelSelect());
    }
    
    function clickPlay(level:Int):Void {
        Main.passedLevel = level;
        FlxG.switchState(new PlayState());
    }
}