package;

import flixel.FlxSprite;

class HitButton extends FlxSprite {

    public var gate:Gate;

    var timed:Bool;
    var timer:Float;    // resets after certain time
    override public function new(x:Float, y:Float, gateX:Float, gateY:Float, angle:Float) {
        super(x, y);
		loadGraphic("assets/images/button.png", true, 32, 20);
        this.scale.set(2, 2);
        this.updateHitbox();
        this.animation.add("unpressed", [0], 0, false);
        this.animation.add("pressed", [1], 0, false);
        this.animation.play("unpressed");
        this.angle = angle;

        gate = new Gate(gateX, gateY, this);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
    }
}