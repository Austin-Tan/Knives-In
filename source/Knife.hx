package;

import nape.callbacks.CbType;
import nape.dynamics.InteractionFilter;
import haxe.zip.InflateImpl;
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
   var initialSpeed:Float = 500;

   var COLLISION_GROUP:Int = 1;
   var COLLISION_MASK:Int = ~7;
   var SENSOR_GROUP:Int = 1;
   var SENSOR_MASK:Int = ~1;

   public function new(x:Float, y:Float, angle:Float) {
      super(x, y, "assets/images/knife.png");
      this.visible = false;
      this.initX = x;
      this.initY = y;
      this.setBodyMaterial(0.05);
      this.body.rotate(new Vec2(x, y), angle);
      this.body.velocity.set(new Vec2(initialSpeed * Math.cos(angle), initialSpeed * Math.sin(angle)));
      this.body.setShapeFilters(new InteractionFilter(COLLISION_GROUP, COLLISION_MASK));
   }

   override public function update(elapsed:Float):Void {
      super.update(elapsed);

      if (body.position.x > FlxG.width || body.position.y > FlxG.height || body.position.x < 0 || body.position.y < 0) {
         // remove object
      }
   }
}