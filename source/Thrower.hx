package;

import flixel.FlxSprite;

class Thrower extends FlxSprite {

    // public var thrownAngle:Float;
    override public function new(x:Float, y:Float) {
        super(x, y, "assets/images/knife.png");
        this.scale.set(2, 2);
        curSpeed = 0;
    }

    public static var minSpeed:Float = 185;
    public static var maxSpeed:Float = 250;
    public static var baseSpeed:Float = 225;
    public static var speed:Float = 225;
    var curSpeed:Float;
    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        if(this.visible) {
            this.angle += curSpeed * elapsed;
            if (curSpeed < speed) {
                curSpeed += 150 * elapsed;
            } else if (curSpeed > speed) {
                curSpeed -= 150 * elapsed;
            }
        } else {
            this.angle -= 4 * elapsed;
        }
    }
}