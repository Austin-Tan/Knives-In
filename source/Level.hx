import haxe.Timer;
import flixel.FlxG;
import flixel.math.FlxRandom;

class Level {

   public static function getStageId(level:Int, stage:Int):Int {
      var id:Int = 0;
      for (i in 0...level) {
         id += getNumStages(level);
      }
      id += stage;
      return id;
   }

   static var rand:FlxRandom = new FlxRandom();
   static var THROWER_WIDTH:Int = 64;
   static var THROWER_HEIGHT:Int = 40;
   public static function getThrower(level:Int):Thrower {
      switch (level) {
         case 1: 
            return new Thrower((FlxG.width / 2) - (THROWER_WIDTH / 2),  (FlxG.height / 2) - (THROWER_HEIGHT / 2));
         case 2:
            return new Thrower(300, 200);
         default: 
            return new Thrower((FlxG.width / 2) - (THROWER_WIDTH / 2), (FlxG.height / 2) - (THROWER_HEIGHT / 2));
      }
   }

   static var HALF_TARGET_WIDTH:Int = 16;
   static var HALF_TARGET_HEIGHT:Int = 32;
   public static function targetCoordinate(x:Int, y:Int):Array<Int> {
      return [cast(x - HALF_TARGET_WIDTH, Int), cast(y - HALF_TARGET_HEIGHT, Int)];
   }

   public static function coordinateCenterOffset(x:Int, y:Int, isTarget:Bool=true):Array<Int> {
      // include the pixel offset
      if(isTarget) {
         return targetCoordinate(cast((FlxG.width / 2) + x, Int), cast((FlxG.height / 2)+ y, Int));
      } else {
         return [cast(FlxG.width / 2) + x, cast(FlxG.height / 2) + y];
      }
   }

   public static function polarCoordinate(r:Float, angle:Float, isTarget:Bool=true):Array<Int> {
      var x:Int = Std.int((FlxG.width / 2) + r * Math.cos(angle * 2 * Math.PI / 360));
      var y:Int = Std.int((FlxG.height / 2) + r * Math.sin(angle * 2 * Math.PI / 360));
      trace(x, y);
      if (isTarget) {
         return targetCoordinate(x, y);
      } else {
         return [x, y];
      }
   }

   public static function getLevelStats(level:Int):LevelStats {
      // format LevelStats(#Stages, Knives Par, Time(Seconds) Par)
      switch(level) {
         case 1:
            return new LevelStats(3, 15, 15);
         default:
            return new LevelStats(1, 1, 3);
      }
   }

   public static function getNumStages(level:Int):Int {
      switch(level) {
         case 1:
            return 3;
         default:
            return 1;
      }
   }
   
   public static function getTargets(level:Int, stage:Int):Array<Target> {
      stage = stage - 1;

      var coordinates:Array<Array<Array<Int>>>;
      var rotations:Array<Array<Int>>;
      switch (level) {
         case 1: 
            coordinates = 
                           // stage 1
                           [[coordinateCenterOffset(-104, -60), coordinateCenterOffset(104, -60), coordinateCenterOffset(0, 120)],
                           // stage 2
                           [coordinateCenterOffset(0, -130), coordinateCenterOffset(130, 0), coordinateCenterOffset(0, 130), coordinateCenterOffset(-130, 0)],
                           // stage 3
                           [polarCoordinate(150, 0), polarCoordinate(150, 72), polarCoordinate(150, 72 * 2), polarCoordinate(150, 72 * 3), polarCoordinate(150, 72*4)]];
            rotations = 
                           // stage 1
                           [[210, -30, 90],
                           // stage 2
                           [-90, 0, 90, 180],
                           //stage 3
                           [0, 72, 72 * 2, 72 * 3, 72 * 4]];
         case 2: 
            coordinates = 
                           // stage 1
                           [[coordinateCenterOffset(-104, -60), coordinateCenterOffset(104, -60), coordinateCenterOffset(0, 120)],
                           // stage 2
                           [coordinateCenterOffset(0, -130), coordinateCenterOffset(130, 0), coordinateCenterOffset(0, 130), coordinateCenterOffset(-130, 0)],
                           // stage 3
                           [polarCoordinate(150, 0), polarCoordinate(150, 72), polarCoordinate(150, 72 * 2), polarCoordinate(150, 72 * 3), polarCoordinate(150, 72*4)]];
            rotations = 
                           // stage 1
                           [[210, -30, 90],
                           // stage 2
                           [-90, 0, 90, 180],
                           //stage 3
                           [0, 72, 72 * 2, 72 * 3, 72 * 4]];

         default:
            coordinates = [[coordinateCenterOffset(0, -100)]];
            rotations = [[-90]];
      }

      var targets:Array<Target> = new Array<Target>();

      trace("for loop, level is " + level + " and stage is " + stage);
      for (i in 0...coordinates[stage].length) {
         var whichImg:String = "1";
         var angle:Int = 0;
         if(rand.float() < 0.33) {
            whichImg = "1";
         } else if (rand.float() < 0.66) {
            whichImg = "2";
         } else { // rand.float() < 1
            whichImg = "3";
         }
         angle = 0;
         if (i < rotations[stage].length) {
            angle = rotations[stage][i];
         }
         targets.push(new Target(coordinates[stage][i][0], coordinates[stage][i][1], whichImg, angle));
      }
      trace("post loop");

      return targets;
   }

   public static function getPlatforms(level:Int):Array<Platform> {
      // x, y, width, height
      var properties:Array<Array<Int>>;
      switch (level) {
         case 1:
            properties = [];
         case 2:
            properties = [[320, 240, 50, 5]];
         default:
            properties = [];
      }
      
      // Wall
      properties.push([0, 0, FlxG.width, 5]);
      properties.push([0, FlxG.height - 5, FlxG.width, 5]);
      properties.push([0, 0, 5, FlxG.height]);
      properties.push([FlxG.width - 5, 0, 5, FlxG.height]);

      var platforms:Array<Platform> = new Array<Platform>();

      for (i in 0...properties.length) {
         platforms.push(new Platform(properties[i][0], properties[i][1], properties[i][2], properties[i][3]));
      }

      return platforms;
   }
      
}