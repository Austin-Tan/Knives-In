package;

import flixel.util.FlxColor;
import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxGame;
import flixel.FlxSprite;
import flixel.FlxG;
import nape.geom.Vec2;

class Knife extends FlxNapeSprite {

   var knifeColor:FlxColor;
   var thrownVelocity:Float;
   var thrown:Bool;
   var init_x:Float;
   var init_y:Float;

   public function new(x:Float, y:Float, knifeColor:FlxColor) {
      super(x, y);

      this.knifeColor = knifeColor;
      this.init_x = x;
      this.init_y = y;
      this.thrown = false;

      loadGraphic("assets/images/knife.png", true, 32, 16);
   }

   override public function update(elapsed:Float):Void {
      super.update(elapsed);
      if(!thrown) {
         body.rotate(new Vec2(150, 150), 2 * Math.PI / 360);
      } else {
         body.applyImpulse(new Vec2(-10, 0));
      }
      
      
      if (FlxG.keys.pressed.SPACE && !thrown) {
         this.thrown = true;

         body.applyImpulse(new Vec2(-10, 0));
      }

   }
}