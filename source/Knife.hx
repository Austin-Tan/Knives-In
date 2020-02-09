package;

import flixel.util.FlxColor;
import flixel.FlxGame;
import flixel.FlxSprite;

class Knife extends FlxSprite {

   var knifeColor:FlxColor;

   public function new(x:Float, y:Float, knifeColor:FlxColor) {
      super(x, y);
      this.knifeColor = knifeColor;

      // make the knife spin...
      loadRotatedGraphic("assets/images/knife.jpeg", 16, 2);
   }
}