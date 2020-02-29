import haxe.Timer;
import flixel.FlxG;
import flixel.math.FlxRandom;

class Level {
   public static var MAX_LEVEL:Int = 4;

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
   static var THROWER_HEIGHT:Int = 64; // why?

   public static function getThrower(level:Int):Thrower {
      switch (level) {
         case 1: 
            return new Thrower((FlxG.width / 2) - (THROWER_WIDTH / 2),  (FlxG.height / 2) - (THROWER_HEIGHT / 2));
         case 2:
            return new Thrower(100, (FlxG.height / 2) - (THROWER_HEIGHT / 2));
         case 3:
            return new Thrower((FlxG.width / 2) - (THROWER_WIDTH / 2),  (FlxG.height / 2) - (THROWER_HEIGHT / 2));
         case 4:
            return new Thrower((FlxG.width / 2) - (THROWER_WIDTH / 2),  (FlxG.height / 2) - (THROWER_HEIGHT / 2));
         default: 
            return new Thrower(50, 50);
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
            return new LevelStats(3, 16, 15);
         case 2:
            return new LevelStats(3, 24, 24);
         case 3:
            return new LevelStats(3, 15, 15);
         case 4:
            return new LevelStats(3, 15, 22);
         default:
            return new LevelStats(1, 2, 3);
      }
   }

   public static function getNumStages(level:Int):Int {
      switch(level) {
         case 1:
            return 3;
         case 2:
            return 3;
         case 3:
            return 1;
         case 4:
            return 3;
         default:
            return 1;
      }
   }

   public static function getButtons(level:Int, stage:Int):Array<HitButton> {
      var buttons:Array<HitButton> = new Array<HitButton>();
      stage = stage - 1;

      var coordinates:Array<Array<Array<Int>>>;
      var rotations:Array<Array<Int>>;
      var gateCoordinates:Array<Array<Array<Int>>>;
      var timing:Array<Array<Float>>;
      switch (level) {
         case 4:
            coordinates = [
               // stage 1
               [[500-50, 70]],
               // stage 2
               [[-9, cast(FlxG.height / 2, Int) - 30]],
               // stage 3
               [[cast(FlxG.width / 2, Int) - 30, 5], [-9, cast(FlxG.height / 2, Int) - 30], [cast(FlxG.width / 2, Int) - 30, FlxG.height - 43]]
            ];
            rotations = [
               // stage 1
               [-90],
               // stage 2
               [90],
               // stage 3
               [180, 90, 0]
            ];
            gateCoordinates = [
               // stage 1
               [[500, 164]],
               // stage 2
               [[500, 164]],
               // stage 3
               [[500, 164], [cast(FlxG.width / 2, Int) - 15, 15], [100, 164]]
            ];
            timing = [
               // stage 1
               [],
               // stage 2
               [1],
               // stage 3
               [2.25, 2.25, 2.25]
            ];

         default:
            coordinates = [];
            rotations = [];
            gateCoordinates = [];
            timing = [];
      }
      if (coordinates != null && coordinates.length > 0 ) {
         for (i in 0...coordinates[stage].length) {
            var timer:Float = 0;
            if (timing != null && timing[stage].length > 0) {
               timer = timing[stage][i];
            }
            buttons.push(new HitButton(coordinates[stage][i][0], coordinates[stage][i][1], gateCoordinates[stage][i][0], gateCoordinates[stage][i][1], rotations[stage][i], timer));
         }
      }
      return buttons;
   }
   
   public static function getTargets(level:Int, stage:Int):Array<Target> {
      stage = stage - 1;

      var velocities:Array<Array<Array<Int>>>;
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
            velocities = null;
         case 2: 
            coordinates = 
               [[polarCoordinate(100, -45), polarCoordinate(100, 0), polarCoordinate(100, 45)],
               [polarCoordinate(80, 0), polarCoordinate(140, 0), polarCoordinate(200, 0), polarCoordinate(260, 0)],
               [polarCoordinate(200, 30), polarCoordinate(150, 30), polarCoordinate(200, -30), polarCoordinate(150, -30)]];
            rotations = 
               [[-45, 0, 45],
               [0, 0, 0, 0],
               [30, 30, -30, -30]];
            velocities = null;
         case 3:
            coordinates = 
               [[polarCoordinate(200, 0), polarCoordinate(-200, 0)],
               [coordinateCenterOffset(-100, -100), coordinateCenterOffset(180, 210), coordinateCenterOffset(50, 160)],
               [polarCoordinate(260, 0), polarCoordinate(200, 0), polarCoordinate(-200, 0), polarCoordinate(-260, 0)]];
               // [coordinateCenterOffset(-200, 50), coordinateCenterOffset(-50, 200), coordinateCenterOffset(200, 50), coordinateCenterOffset(50, -200)]];
            rotations =
               [[0, 180], 
               [-90, 90, 90], 
               [0, 0, 180, 180]];
            velocities =
               [[[0,80], [0,80]],
               [[80,0], [-80,0], [80,0]],
               [[0,-80], [0,80], [0,-80], [0,80]]];
         case 4:
            coordinates = [
               // stage 1
               [coordinateCenterOffset(300, 0)],
               // stage 2
               [coordinateCenterOffset(300, 0)],
               // stage 3
               [coordinateCenterOffset(300, 0)]
            ];
            rotations = [
               [0],
               [0],
               [0]
            ];
            velocities = null;

         default:
            coordinates = [];
            rotations = [];
            velocities = null;
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
         if (velocities == null) {
            targets.push(new Target(coordinates[stage][i][0], coordinates[stage][i][1], whichImg, angle, false));
         } else {
            targets.push(new Target(coordinates[stage][i][0], coordinates[stage][i][1], whichImg, angle, true, velocities[stage][i][0], velocities[stage][i][1]));
         }
      }
      trace("post loop");

      return targets;
   }

   public static function getPlatforms(level:Int, stage:Int):Array<Platform> {
      // x, y, width, height
      stage = stage - 1;
      var properties:Array<Array<Array<Int>>>;
      var platforms:Array<Platform> = new Array<Platform>();
      switch (level) {
         case 1:
            properties = [];
         case 2:
            properties = [];
         case 3:
            properties = [];
         case 4:
            properties = [
               [[500, 0, 32, 165], [500, 286, 32, 220]],
               [[500, 0, 32, 165], [500, 286, 32, 220]],
               // stage 3
               [[500, 160, 200, 5], [500, 290, 200, 5], [cast(FlxG.width / 2, Int) - 68, 0, 5 , 94], [385, 0, 5, 94], [0, 160, 132, 5], [0, 290, 132, 5]]
            ];
         default:
            properties = [];//[[320, 240, 50, 5]];
      }
      


      // Wall 
      platforms.push(new Platform(0, 0, FlxG.width, 5));
      platforms.push(new Platform(0, FlxG.height - 5, FlxG.width, 5));
      platforms.push(new Platform(0, 0, 5, FlxG.height));
      platforms.push(new Platform(FlxG.width - 5, 0, 5, FlxG.height));

      if(properties.length > 0 && properties[stage] != null) {
         for (i in 0...properties[stage].length) {
            platforms.push(new Platform(properties[stage][i][0], properties[stage][i][1], properties[stage][i][2], properties[stage][i][3]));
         }
      }

      return platforms;
   }
}