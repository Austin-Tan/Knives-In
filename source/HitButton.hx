package;

import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.FlxSprite;

class HitButton extends FlxSprite {

    public var gate:Gate;

    var timed:Bool;
    var timer:Float;    // resets after certain time

    var shutMe:Bool = false;
    var counter:Float;

    public var addMe:Bool = false; // to add back to active buttons
    public var button_sound:FlxSound = FlxG.sound.load("assets/sounds/button.wav");
    override public function new(x:Float, y:Float, gateX:Float, gateY:Float, angle:Float, timer:Float = 0, rotateGate:Bool=false) {
        super(x, y);
        trace('timer ' + timer);
        if (timer == 0) {
		    loadGraphic("assets/images/yellow-button.png", true, 64, 40);
        } else {
            loadGraphic("assets/images/button.png", true, 64, 40);
        }
        this.animation.add("unpressed", [0], 0, false);
        this.animation.add("pressed", [1], 0, false);
        this.animation.play("unpressed");
        this.angle = angle;

        if (timer != 0) {
            timed = true;
            this.timer = timer;
        }

        gate = new Gate(gateX, gateY, this, this.timer, rotateGate);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        if (shutMe) {
            if (counter > 0) {
                counter -= elapsed;
            } else {
                shutMe = false;
                button_sound.play();
                this.animation.play("unpressed");
                gate.toggleGate();
                addMe = true;
            }
        }
    }
    
    public function startTimer():Void {
        if (timed) {
            shutMe = true;
            counter = timer;
        }
    }
}