import haxe.Timer;
import flixel.FlxG;
import flixel.math.FlxRandom;

class Level {

   static var rand:FlxRandom = new FlxRandom();
   static var THROWER_WIDTH:Int = 32;
   static var THROWER_HEIGHT:Int = 16;
   public static function getThrower(level:Int):Thrower {
      switch (level) {
         case 0: 
            return new Thrower(FlxG.width / 2, FlxG.height / 2);
         case 1:
            return new Thrower(300, 200);
         default: 
            return new Thrower((FlxG.width / 2) - THROWER_WIDTH, (FlxG.height / 2) - THROWER_HEIGHT);
      }
   }

   static var HALF_TARGET_WIDTH:Int = 8;
   static var HALF_TARGET_HEIGHT:Int = 16;
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

   public static function getLevelStats(level:Int):LevelStats {
      switch(level) {
         case 0:
            return new LevelStats(3, 15, 20);
         default:
            return new LevelStats(1, 1, 5);
      }
   }

   public static function getNumStages(level:Int):Int {
      switch(level) {
         case 0:
            return 3;
         default:
            return 1;
      }
   }
   
   public static function getTargets(level:Int, stage:Int):Array<Target> {
      var coordinates:Array<Array<Array<Int>>>;
      var rotations:Array<Array<Int>>;
      switch (level) {
         case 0: 
            coordinates = 
                           // stage 1
                           [[coordinateCenterOffset(-60, -60), coordinateCenterOffset(60, -60), coordinateCenterOffset(0, 80)],
                           // stage 2
                           [coordinateCenterOffset(0, -120), coordinateCenterOffset(120, 0), coordinateCenterOffset(0, 120), coordinateCenterOffset(-120, 0)],
                           // stage 3
                           [coordinateCenterOffset(0, -120), coordinateCenterOffset(100, 0), coordinateCenterOffset(-120, 0), coordinateCenterOffset(100, 80), coordinateCenterOffset(-100, 80)]];
            rotations = 
                           // stage 1
                           [[-135, -45, 90],
                           // stage 2
                           [-90, 0, 90, 180],
                           //stage 3
                           [-90, 0, 180, 20, 160]];
         // case 1:
         //    coordinates = [[300, 50], [200, 50], [150, 50]];
         //    rotations = [20, 20];
         default:
            coordinates = [[coordinateCenterOffset(0, -100)]];
            rotations = [[-90]];
      }

      var targets:Array<Target> = new Array<Target>();

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
         if (i < rotations.length ) {
            angle = rotations[stage][i];
         }
         targets.push(new Target(coordinates[stage][i][0], coordinates[stage][i][1], whichImg, angle));
      }

      return targets;
   }

   public static function getPlatforms(level:Int):Array<Platform> {
      // x, y, width, height
      var properties:Array<Array<Int>>;
      switch (level) {
         case 0:
            properties = [];
         case 1:
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