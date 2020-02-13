package;

import flixel.FlxSprite;

class Thrower extends FlxSprite {

    // public var thrownAngle:Float;
    override public function new(x:Float, y:Float) {
        super(x, y, "assets/images/knife.png");
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        this.angle += 160 * elapsed;
        // thrownAngle = this.angle;
    }
}