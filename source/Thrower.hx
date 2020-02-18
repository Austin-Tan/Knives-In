package;

import flixel.FlxSprite;

class Thrower extends FlxSprite {

    // public var thrownAngle:Float;
    override public function new(x:Float, y:Float) {
        super(x, y, "assets/images/knife.png");
        this.scale.set(2, 2);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        if(this.visible) {
            this.angle += 240 * elapsed;
        } else {
            this.angle -= 4 * elapsed;
        }
        // thrownAngle = this.angle;
    }
}