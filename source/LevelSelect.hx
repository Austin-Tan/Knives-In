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
        var i = 0;
        var buttonX:Int = leftButtonX;
        var buttonY:Int = -150;
        while (i < 25) {
            var x = i;
            if(i % 5 == 0) {
                buttonY += 50;
                buttonX = leftButtonX;
            }
            buttonX += 100;
            var playButton = new FlxButton((FlxG.width / 2 + buttonX), (FlxG.height / 2) + buttonY, "Level " + (i + 1), ()->{clickPlay(x);});
            add(playButton);

            trace("X: " + buttonX + " Y: " + buttonY);
            var j:Int = 0;
            while (j < 3) {
                // if (j == 0 && levelcomplete(i)) {
                    var star:FlxSprite = new FlxSprite(playButton.x + 4 + (25 * j), playButton.y - 15, "assets/images/star.png");
                    add(star);
                // } else if (j == 1 && onTimePar(i)) {
                //     var star:FlxSprite = new FlxSprite(playButton.x + 4 + (25 * j), playButton.y - 15, "assets/images/star.png");
                //     add(star);
                // } else if (j == 2 && onKnivesPar(i)) {
                //     var star:FlxSprite = new FlxSprite(playButton.x + 4 + (25 * j), playButton.y - 15, "assets/images/star.png");
                //     add(star);
                // } else {
                //     var star:FlxSprite = new FlxSprite(playButton.x + 4 + (25 * j), playButton.y - 15, "assets/images/grayStar.png");
                //     add(star);
                // }
                j++;
            }
            i++;
        }
    }

    override public function update(elapsed:Float):Void {
            super.update(elapsed);
    }
    
    function clickPlay(level:Int):Void {
        Main.passedLevel = level;
        trace(Main.passedLevel);
        FlxG.switchState(new PlayState());
    }
}