import flixel.FlxG;
import flixel.math.FlxRandom;

class Level {

   static var rand:FlxRandom = new FlxRandom();
   public static function getThrower(level:Int):Thrower {
      switch (level) {
         case 0: 
            return new Thrower(150, 150);
         case 1:
            return new Thrower(300, 200);
         default: 
            return new Thrower(150, 150);
      }
   }
   
   public static function getTargets(level:Int):Array<Target> {
      var coordinates:Array<Array<Int>>;
      switch (level) {
         case 0: 
            coordinates = [[20, 20], [340, 200], [400, 400], [340, 160]];
         case 1:
            coordinates = [[300, 50], [200, 50], [150, 50]];
         default:
            coordinates = [[150, 150]];
      }

      var targets:Array<Target> = new Array<Target>();

      var whichImg:String = "1";
      for (i in 0...coordinates.length) {
         if(rand.float() < 0.33) {
            whichImg = "1";
         } else if (rand.float() < 0.66) {
            whichImg = "2";
         } else { // rand.float() < 1
            whichImg = "3";
         }
         targets.push(new Target(coordinates[i][0], coordinates[i][1], whichImg));
      }

      return targets;
   }

   public static function getPlatforms(level:Int):Array<Platform> {
      // x, y, width, height
      var properties:Array<Array<Int>>;
      switch (level) {
         case 0:
            properties = [[320, 240, 50, 5]];
         case 1:
            properties = [[320, 240, 50, 5]];
         default:
            properties = [[320, 240, 50, 5]];
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