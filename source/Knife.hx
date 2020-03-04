package;

import nape.phys.Material;
import nape.phys.BodyType;
import nape.phys.Body;
import nape.constraint.WeldJoint;
import nape.constraint.PivotJoint;
import flixel.system.FlxSound;
import nape.callbacks.InteractionType;
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
   var initialSpeed:Float = 2000;
   public var stuck:Bool = false;  // if this has stuck into an object

   var COLLISION_GROUP:Int = 1;
   var COLLISION_MASK:Int = ~7;
   var SENSOR_GROUP:Int = 1;
   var SENSOR_MASK:Int = ~3;

   #if flash
      var metal_sound:FlxSound = FlxG.sound.load("assets/sounds/knife_metal.mp3");
      var wood_sound:FlxSound = FlxG.sound.load("assets/sounds/knife_wood.mp3");
   #else
      public var metal_sound:FlxSound = FlxG.sound.load("assets/sounds/knife_metal.wav");
      var wood_sound:FlxSound = FlxG.sound.load("assets/sounds/knife_wood.wav");
   #end

   public function new(x:Float, y:Float, angle:Float) {
      super(x, y, "assets/images/knife.png");
      this.visible = false;
      this.initX = x;
      this.initY = y;
      this.scale.set(2, 2);
      updateHitbox();
      updateFramePixels();
      this.body.rotate(new Vec2(x, y), angle);
      this.body.velocity.set(new Vec2(initialSpeed * Math.cos(angle), initialSpeed * Math.sin(angle)));
      this.body.setShapeFilters(new InteractionFilter(COLLISION_GROUP, COLLISION_MASK, SENSOR_GROUP, SENSOR_MASK));
      this.body.setShapeMaterials(new Material(0, 1.0, 1.0, 1, 0));
      this.body.shapes.at(0).sensorEnabled = true;
      this.body.name = 1; // 1 for knife
   }

   public function stickTarget(target:Target):Void {
      this.stuck = true;
      wood_sound.play(true);
   }

   override public function update(elapsed:Float):Void {
      super.update(elapsed);

      if(!stuck) {
         var list = this.body.interactingBodies(InteractionType.SENSOR);
         if(list.length > 0) {
            for (body in list) {
               if(body.name == 1) {
                  continue; // hit something else instead, this is a knife
               }
   
               // this is a wall
               if(body.name == 2) {
                  metal_sound.play(true);
                  this.body.space = null;
                  this.setSize(0, 0); // nulling the hitbox
                  stuck = true;
                  this.body.shapes.at(0).sensorEnabled = false;
   
               }
            }
         }
      }
   }
}