package;

import flixel.util.FlxColor;
import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxGame;
import flixel.FlxSprite;
import flixel.FlxG;
import nape.geom.Vec2;

class Knife extends FlxNapeSprite {

   var thrownVelocity:Float;
   var initX:Float;
   var initY:Float;
   var initialSpeed:Float = 12;

   public function new(x:Float, y:Float, angle:Float) {
      super(x, y, "assets/images/knife.png");
      this.angle = angle;
      this.initX = x;
      this.initY = y;
      this.setBodyMaterial(0.05);
   }

   override public function update(elapsed:Float):Void {
      super.update(elapsed);
      // body.position.x = body.position.x + initialSpeed * Math.cos(this.angle);
      // body.position.y = body.position.y + initialSpeed * Math.sin(this.angle);

      if (body.position.x > FlxG.width || body.position.y > FlxG.height || body.position.x < 0 || body.position.y < 0) {
         // remove object
      }
   }
}