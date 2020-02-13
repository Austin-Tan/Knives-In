package;

import flixel.FlxSprite;

class Thower extends FlxSprite {

    override public function new(?X:Float = 0, ?Y:Float = 0) {
        super(X, Y, "assets/images/knife.png");
    }

    override public function update(elapsed:Float):Void
        {
            super.update(elapsed);
            updateAnimation(elapsed);
        }
}