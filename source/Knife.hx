package;

import flixel.util.FlxColor;
import flixel.FlxGame;
import flixel.FlxSprite;
import flixel.FlxG;

class Knife extends FlxSprite {

   var knifeColor:FlxColor;
   var thrownVelocity:Float;
   var thrown:Bool;
   public function new(x:Float, y:Float, knifeColor:FlxColor) {
      super(x, y);
      this.knifeColor = knifeColor;

      // make the knife spin...
      loadGraphic("assets/images/knife.png");
   }

   @override
   override public function update(elapsed:Float):Void
      {
         super.update(elapsed);     
         if(thrown) {
            x += thrownVelocity * elapsed * Math.cos(Math.PI * angle / 180);
            y += thrownVelocity * elapsed * Math.sin(Math.PI * angle / 180);
            if(thrownVelocity > (thrownVelocity / 2)) {
               thrownVelocity -= 300 * elapsed;
            }
         } else { // not thrown
            angle += 140 * elapsed;
         }
   
         if(FlxG.keys.pressed.ESCAPE || x > FlxG.width || x < 0 || y > FlxG.height || y < 0) {
            thrown = false;
            screenCenter();
         }
         if(FlxG.keys.pressed.SPACE && !thrown) {
            thrown = true;
            thrownVelocity = 750;
         }
      }
}