package;

import flixel.util.FlxColor;
import flixel.FlxGame;
import flixel.FlxSprite;

class Knife extends FlxSprite {

   var knifeColor:FlxColor;
   public var thrownVelocity:Float;
   public function new(x:Float, y:Float, knifeColor:FlxColor) {
      super(x, y);
      this.knifeColor = knifeColor;

      // make the knife spin...
      loadGraphic("assets/images/knife.jpeg");
   }
}