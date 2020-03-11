import haxe.Timer;
import flixel.FlxG;
import flixel.math.FlxRandom;

class Level {
   public static var MAX_LEVEL:Int = 10;

   public static function getStageId(level:Int, stage:Int):Int {
      var id:Int = 0;
      for (i in 0...level) {
         id += getNumStages(level);
      }
      id += stage;
      return id;
   }

   static var rand:FlxRandom = new FlxRandom();
   static var THROWER_WIDTH:Int = 30;
   static var THROWER_HEIGHT:Int = 9; 

   public static function getThrower(level:Int):Thrower {
      switch (level) {
         case 1: 
            return new Thrower((FlxG.width / 2) - (THROWER_WIDTH / 2),  (FlxG.height / 2) - (THROWER_HEIGHT / 2));
         case 2:
            return new Thrower(100 - (THROWER_WIDTH / 2), (FlxG.height / 2) - (THROWER_HEIGHT / 2) - 8);
         case 3:
            return new Thrower((FlxG.width / 2) - (THROWER_WIDTH / 2),  (FlxG.height / 2) - (THROWER_HEIGHT / 2));
         case 4:
            return new Thrower((FlxG.width / 2) - (THROWER_WIDTH / 2),  (FlxG.height / 2) - (THROWER_HEIGHT / 2));
         case 5:
            return new Thrower(100, (FlxG.height / 2) - (THROWER_HEIGHT / 2) - 8);
         case 6:
            return new Thrower((FlxG.width / 2) - 16, (FlxG.height / 2) - 16);
         case 7:
            return new Thrower((FlxG.width / 2) - (THROWER_WIDTH / 2), 100 - (THROWER_HEIGHT / 2));
         case 8:
            return new Thrower((FlxG.width / 2) - (THROWER_WIDTH / 2), (FlxG.height / 2) - 16);
         case 9:
            return new Thrower((FlxG.width / 2) - (THROWER_WIDTH / 2), 75 - (THROWER_HEIGHT / 2));
         case 10:
            return new Thrower((FlxG.width / 2) - (THROWER_WIDTH / 2), 75 - (THROWER_HEIGHT / 2));
         default:
            return new Thrower(50, 50);
      }
   }

   static var HALF_TARGET_WIDTH:Int = 0;
   static var HALF_TARGET_HEIGHT:Int = 0;

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

   public static function polarCoordinate(r:Float, angle:Float, cx:Float, cy:Float):Array<Int> {

      var x:Int = Std.int(cx + r * Math.cos(angle * 2 * Math.PI / 360) - 15);
      var y:Int = Std.int(cy + r * Math.sin(angle * 2 * Math.PI / 360) - 15);
      return targetCoordinate(x, y);
   }

   public static function getLevelStats(level:Int):LevelStats {
      // format LevelStats(#Stages, Knives Par, Time(Seconds) Par)
      switch(level) {
         case 1:
            // min knives is 12
            return new LevelStats(3, 13, 10);
         case 2:
            // min knives is 15
            return new LevelStats(3, 17, 25);
         case 3:
            // min knives is 9
            return new LevelStats(3, 10, 10);
         case 4:
            // min knives is 8
            return new LevelStats(3, 10, 12);
         case 5:
            // min is 26
            // my min time is 15
            return new LevelStats(3, 28, 18);
         case 6:
            // min is 102 (assuming only one knife per target opening)
            // my min time is 20
            return new LevelStats(5, 120, 50);
         case 7:
            // min knives is 10
            // my min time is 13
            return new LevelStats(3, 13, 20);
         case 8:
            // min is 2, 2
            return new LevelStats(1, 2, 2);
         case 9:
            // min is 5, 1
            return new LevelStats(1, 5, 1);
         case 10:
            // min is 5, 1
            return new LevelStats(1, 5, 1);
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
            return 3;
         case 4:
            return 3;
         case 5:
            return 3;
         case 6:
            return 5;
         case 7:
            return 3;
         case 8:
            return 1;
         case 9:
            return 1;
         case 10:
            return 1;
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
      var rotateGate:Array<Array<Bool>>;
      switch (level) {
         case 4:
            coordinates = [
               // stage 1
               [[500-50, 70]],
               // stage 2
               [[-6, cast(FlxG.height / 2, Int) -30]],
               // stage 3
               [[cast(FlxG.width /  2, Int) - 30, 5], [-9, cast(FlxG.height / 2, Int) - 30], [cast(FlxG.width / 2, Int) - 30, FlxG.height - 43]]
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
            rotateGate = [
               // stage 1
               [false],
               // stage 2
               [false],
               // stage 3
               [false, true, false],
            ];

         case 6:
            coordinates = [
               // stage 1
               [],
               // stage 2
               [],
               // stage 3
               [[125, 103], [430, FlxG.height - 140]],
               // stage 4
               [[-800, cast(FlxG.height / 2, Int) - 31], [-8, cast(FlxG.height / 2, Int) - 100]],
               // stage 5
               []
            ];
            rotations = [
               // stage 1
               [],
               // stage 2
               [],
               // stage 3
               [180, 0],
               // stage 4
               [90, 90],
               // stage 5
               []
            ];
            gateCoordinates = [
               // stage 1
               [],
               // stage 2
               [],
               // stage 3
               [[290, 31], [290, 328]],
               // stage 4
               [[900, 164], [500, 164]],
               // stage 5
               []
            ];
            timing = [
               // stage 1
               [],
               // stage 2
               [],
               // stage 3
               [0.5, 0.5],
               // stage 4
               [1, 1],
               // stage 5
               []
            ]; 
            rotateGate = [
               // stage 1
               [],
               // stage 2
               [],
               // stage 3
               [true, true],
               // stage 4
               [false, false],
               // stage 5
               []
            ];
            case 7:
            coordinates = [
               // stage 1
               [],
               // stage 2
               [[430, FlxG.height - 158]],
               // stage 3
               [[130, FlxG.height - 208], [430, FlxG.height - 208]],
            ];
            rotations = [
               // stage 1
               [],
               // stage 2
               [0],
               // stage 3
               [0, 0]
            ];
            gateCoordinates = [
               // stage 1
               [],
               // stage 2
               [[290, 311]],
               // stage 3
               [[290, 311], [290, 261]]
            ];
            timing = [
               // stage 1
               [],
               // stage 2
               [4],
               // stage 3
               [4,4]
            ]; 
            rotateGate = [
               // stage 1
               [],
               // stage 2
               [true],
               // stage 3
               [true, true]
            ];
         default:
            coordinates = [];
            rotations = [];
            gateCoordinates = [];
            timing = [];
            rotateGate = [];
      }
      if (coordinates != null && coordinates.length > 0 ) {
         for (i in 0...coordinates[stage].length) {
            var timer:Float = 0;
            if (timing != null && timing[stage].length > 0) {
               timer = timing[stage][i];
            }
            buttons.push(new HitButton(coordinates[stage][i][0], coordinates[stage][i][1], gateCoordinates[stage][i][0], gateCoordinates[stage][i][1], rotations[stage][i], timer, rotateGate[stage][i]));
         }
      }
      return buttons;
   }
   
   public static function getTargets(level:Int, stage:Int):Array<Target> {
      stage = stage - 1;

      var velocities:Array<Array<Array<Int>>>;
      var coordinates:Array<Array<Array<Int>>>;
      var rotations:Array<Array<Int>>;
      var bigBoys:Array<Array<Bool>>;
      switch (level) {
         case 1: 
            var cx:Float = (FlxG.width / 2);
            var cy:Float = (FlxG.height / 2);
            coordinates = 
               // stage 1
               [[coordinateCenterOffset(-104, -60), coordinateCenterOffset(104, -60), coordinateCenterOffset(0, 120)],
               // stage 2
               [coordinateCenterOffset(0, -130), coordinateCenterOffset(130, 0), coordinateCenterOffset(0, 130), coordinateCenterOffset(-130, 0)],
               // stage 3
               [polarCoordinate(150, 0, cx, cy), polarCoordinate(150, 72, cx, cy), polarCoordinate(150, 72 * 2, cx, cy), polarCoordinate(150, 72 * 3, cx, cy), polarCoordinate(150, 72*4, cx, cy)]];
            rotations = 
               // stage 1
               [[210, -30, 90],
               // stage 2
               [-90, 0, 90, 180],
               //stage 3
               [0, 72, 72 * 2, 72 * 3, 72 * 4]];
            velocities = null;
            bigBoys = null;
         case 2: 
            var cx:Float = 100;
            var cy:Float = (FlxG.height / 2);
            coordinates = 
               [[polarCoordinate(400, -20, cx, cy), polarCoordinate(400, -10, cx, cy), polarCoordinate(400, 0, cx, cy),polarCoordinate(400, 10, cx, cy), polarCoordinate(400, 20, cx, cy)],
               [coordinateCenterOffset(70, -70), coordinateCenterOffset(115, -35), coordinateCenterOffset(160, 0), coordinateCenterOffset(205, 35), coordinateCenterOffset(250, 70)],
               [coordinateCenterOffset(-270, 200), coordinateCenterOffset(-135, 200), coordinateCenterOffset(0, 200), coordinateCenterOffset(135, 200), coordinateCenterOffset(270, 200)]];
            rotations = 
               [[-20, -10, 0, 10, 20],
               [0, 0, 0, 0, 0],
               [90, 90, 90, 90, 90]];
            velocities = null;
            bigBoys = null;
         case 3:
            var cx:Float = (FlxG.width / 2);
            var cy:Float = (FlxG.height / 2);
            coordinates = 
               [[polarCoordinate(200, 0, cx, cy), polarCoordinate(-200, 0, cx, cy)],
               [coordinateCenterOffset(-100, -100), coordinateCenterOffset(180, 210), coordinateCenterOffset(50, 160)],
               [polarCoordinate(260, 0, cx, cy), polarCoordinate(200, 0, cx, cy), polarCoordinate(-200, 0, cx, cy), polarCoordinate(-260, 0, cx, cy)]];
               // [coordinateCenterOffset(-200, 50), coordinateCenterOffset(-50, 200), coordinateCenterOffset(200, 50), coordinateCenterOffset(50, -200)]];
            rotations =
               [[0, 180], 
               [-90, 90, 90], 
               [0, 0, 180, 180]];
            velocities =
               [[[0,80], [0,80]],
               [[80,0], [-80,0], [80,0]],
               [[0,-80], [0,80], [0,-80], [0,80]]];
            bigBoys = null;
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
            bigBoys = null;
         case 5: 
            var cx:Float = (FlxG.width / 2);
            var cy:Float = (FlxG.height / 2);
            coordinates = 
               [[polarCoordinate(100, -45, cx, cy), polarCoordinate(180, 0, cx, cy), polarCoordinate(100, 45, cx, cy)],
               [coordinateCenterOffset(250, -70), coordinateCenterOffset(0, 0), coordinateCenterOffset(250, 70)],
               [polarCoordinate(200, 30, cx, cy), polarCoordinate(150, 30, cx, cy), polarCoordinate(200, -30, cx, cy), polarCoordinate(150, -30, cx, cy)]];
            rotations = 
               [[-45, 0, 45],
               [0, 0, 0],
               [30, 30, -30, -30]];
            velocities = null;
            bigBoys = [
               // stage 1
               [false, true, false],
               // stage 2
               [false, true, false],
               // stage 3
               [true, false, true, false]
            ];
         case 6:
            coordinates = [
               // stage 1
               [coordinateCenterOffset(220, 10), coordinateCenterOffset(175, 175), coordinateCenterOffset(15, 215), coordinateCenterOffset(-145, 175), coordinateCenterOffset(-190, 10), coordinateCenterOffset(-145, -125), coordinateCenterOffset(15, -170), coordinateCenterOffset(175, -125)],
               // stage 2
               [[50, 30], [cast(FlxG.width / 2, Int), 30], [FlxG.width - 50, 30], [50, FlxG.height - 40], [FlxG.width - 50, FlxG.height - 40], [100, 115], [FlxG.width - 100, FlxG.height - 120]],
               // stage 3
               [[cast(FlxG.width / 2, Int), 30], [cast(FlxG.width / 2, Int), FlxG.height - 40]],
               // stage 4
               [coordinateCenterOffset(300, 10), coordinateCenterOffset(150, 5)],
               // stage 5
               [[120, 100], [FlxG.width - 120, 100], [120, FlxG.height - 140], [FlxG.width - 120, FlxG.height - 140]]
            ];
            rotations = [
               // stage 1
               [0, 45, 90, 135, 180, 225, 270, 315],
               // stage 2
               [225, 270, 315, 135, 45, -90, 90],
               // stage 3
               [-90, 90],
               // stage 4
               [0, 0],
               // stage 5
               [225, 315, 135, 45]
            ];
            velocities = [
            // stage 1
               [[0,0], [0,0], [0,0], [0,0], [0,0], [0,0], [0,0], [0,0]],
            // stage 2
               [[0,0], [0,0], [0,0], [0,0], [0,0], [100,0], [-100,0]],
            // stage 3
               [[0, 0], [0, 0]],
            // stage 4
               [[0, 0], [0, 0]],
            // stage 5
               [[0, 0], [0, 0], [0, 0], [0, 0]],
            
            ];
            bigBoys = [
               // stage 1
               [true, true, true, true, true, true, true, true],
               // stage 2
               [false, false, false, false, false, true, true],
               // stage 3
               [true, true],
               // stage 4
               [false, true],
               // stage 5
               [true, true, true, true]
            ];
         case 7:
            var cx:Float = (FlxG.width / 2) - (THROWER_WIDTH / 2);
            var cy:Float = 100- (THROWER_HEIGHT / 2);
            coordinates = [
               // stage 1
               [coordinateCenterOffset(-200, -50), coordinateCenterOffset(250, 0), coordinateCenterOffset(-150, 50), coordinateCenterOffset(0, 100), coordinateCenterOffset(50, 150)],
               // stage 2
               [coordinateCenterOffset(50, 190)],
               // stage 3
               [coordinateCenterOffset(50, 190)]
            ];
         rotations = [
            // stage 1
            [90, 90, 90, 90, 90],
            // stage 2
            [90],
            // stage 3
            [90]
         ];
         velocities = [
         // stage 1
            [[200,0], [-100,0], [-200,0], [100,0], [-150,0]],
         // stage 2
            [[-100,0]],
         // stage 3
            [[100,0]]
         ];
         bigBoys = [
            // stage 1
            [false, false, false, false, false],
            // stage 2
            [false],
            // stage 3
            [false]     
         ];
         case 8:
            coordinates = [
               // stage 1
               [coordinateCenterOffset(200, -50), coordinateCenterOffset(160, -110)]
            ];
            rotations = [
               // stage 1
               [-25, -45]
            ];
            velocities = null;
            bigBoys = null;
         case 9:
            coordinates = [
               // stage 1
               [coordinateCenterOffset(180, 100)]
            ];
            rotations = [
               // stage 1
               [90]
            ];
            velocities = [
               // stage 1
               [[-200, -200]]
            ];
            bigBoys = [
               // stage 1
               [true]
            ];
            case 10:
            coordinates = [
               // stage 1
               [coordinateCenterOffset(200, 100)]
            ];
            rotations = [
               // stage 1
               [90]
            ];
            velocities = [
               // stage 1
               [[-200, 0]]
            ];
            bigBoys = [
               // stage 1
               [true]
            ];

         default:
            coordinates = [];
            rotations = [];
            velocities = null;
            bigBoys = null;
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
         if (i < rotations[stage].length) {
            angle = rotations[stage][i];
         }
         if (velocities == null) {
            targets.push(new Target(coordinates[stage][i][0], coordinates[stage][i][1], bigBoys == null ? false:bigBoys[stage][i],whichImg, angle, false));
         } else {
            targets.push(new Target(coordinates[stage][i][0], coordinates[stage][i][1], bigBoys == null ? false:bigBoys[stage][i], whichImg, angle, (velocities[stage][i][0] != 0 || velocities[stage][i][1] != 0), velocities[stage][i][0], velocities[stage][i][1]));
         }
      }

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
         case 5:
            properties = [];
         case 6:
            properties = [
               [],
               [],
               // stage 3
               [[0, 80, 248, 25], [370, 80, 400, 25], [0, FlxG.height - 103, 248, 25], [370, FlxG.height - 103, 400, 25]],
               // stage 4
               [[500, 0, 32, 165], [500, 286, 32, 220]],
               // stage 5
               []
            ];
         case 7:
            properties = [
               [], 
               [[0, FlxG.height - 120, 248, 25], [370, FlxG.height - 120, 400, 25]],
               [[0, FlxG.height - 120, 248, 25], [370, FlxG.height - 120, 400, 25], [0, FlxG.height - 170, 248, 25], [370, FlxG.height - 170, 400, 25]]
            ];
         default:
            properties = [];
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