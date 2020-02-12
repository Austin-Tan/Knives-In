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
   var initX:Float;
   var initY:Float;
   var curAngle:Float;

   public function new(x:Float, y:Float, knifeColor:FlxColor) {
      super(x, y);

      this.knifeColor = knifeColor;
      this.initX = x;
      this.initY = y;
      this.thrown = false;

      loadGraphic("assets/images/knife.png", false, 32, 16);
   }

   override public function update(elapsed:Float):Void {
      super.update(elapsed);

      var impulse:Float = 20;

      if (!thrown) {
         var newAngle:Float = 2 * Math.PI / 360;
         body.rotate(new Vec2(initX, initY), newAngle);
         curAngle += newAngle;
      } else {
         body.position.x = body.position.x + impulse * Math.cos(curAngle);
         body.position.y = body.position.y + impulse * Math.sin(curAngle);
      }
      
      if (FlxG.keys.pressed.SPACE && !thrown) {
         this.thrown = true;
      }

   }
}