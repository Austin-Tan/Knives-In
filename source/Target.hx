package;

import flixel.util.FlxColor;
import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxGame;
import flixel.FlxSprite;
import flixel.FlxG;
import nape.geom.Vec2;

class Target extends FlxNapeSprite {

    public function new(x:Float, y:Float) {
        super(x, y);
  
        loadGraphic("assets/images/Target1.png", true, 26, 32);
     }

     override public function update(elapsed:Float):Void {
        super.update(elapsed);  
     }
}