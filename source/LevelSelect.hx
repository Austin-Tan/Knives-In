import js.Cookie;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.FlxState;

class LevelSelect extends FlxState {

    var leftButtonX:Int = -350;
    override public function create():Void {
        super.create();
        this.bgColor = FlxColor.BLACK;
        
		// Welcome text
		var text = new flixel.text.FlxText(0, 0, 0, "Level Select", 64);
        text.screenCenter();
        text.y -= 200;
		add(text);

        // Buttons to Select
        var i = 1;
        var buttonX:Int = leftButtonX;
        var buttonY:Int = -150;
        var maxLevel:Int = Std.parseInt(Cookie.get("MaxLevel"));
        while (i < 25 && i <= maxLevel && i <= Level.MAX_LEVEL) {
            var x = i;
            if(i % 5 == 0) {
                buttonY += 50;
                buttonX = leftButtonX;
            }
            buttonX += 100;
            var playButton = new FlxButton((FlxG.width / 2 + buttonX), (FlxG.height / 2) + buttonY, "Level " + (i), ()->{clickPlay(x);});
            add(playButton);

            var j:Int = 0;
            while (j < 3) {
                if (maxLevel == i) {

                } else if (j == 0 && maxLevel > i) {
                    var star:FlxSprite = new FlxSprite(playButton.x + 4 + (25 * j), playButton.y - 15, "assets/images/star.png");
                    add(star);
                } else if (j == 1 && Cookie.exists(i + "T")) {
                    var star:FlxSprite = new FlxSprite(playButton.x + 4 + (25 * j), playButton.y - 15, "assets/images/star.png");
                    add(star);
                } else if (j == 2 && Cookie.exists(i + "K")) {
                    var star:FlxSprite = new FlxSprite(playButton.x + 4 + (25 * j), playButton.y - 15, "assets/images/star.png");
                    add(star);
                } else {
                    var star:FlxSprite = new FlxSprite(playButton.x + 4 + (25 * j), playButton.y - 15, "assets/images/grayStar.png");
                    add(star);
                }
                j++;
            }
            i++;
        }

        var clearButton = new FlxButton(FlxG.width - 60, FlxG.height - 30, "Clear all data", clearData);
        add(clearButton);
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