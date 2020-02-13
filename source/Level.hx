class Level {

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
      var targets:Array<Target> = new Array<Target>();
      switch (level) {
         case 0: 
            coordinates = [[20, 20], [340, 200], [400, 400], [340, 160]];
         case 1:
            coordinates = [[300, 50], [200, 50], [150, 50]];
         default:
            coordinates = [[150, 150]];
      }

      for (i in 0...coordinates.length) {
         targets.push(new Target(coordinates[i][0], coordinates[i][1]));
      }

      return targets;
   }
      
}