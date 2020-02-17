package;


import nape.phys.BodyType;
import nape.callbacks.CbType;
import nape.dynamics.InteractionFilter;
import nape.phys.Material;
import flixel.util.FlxColor;
import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxGame;
import flixel.FlxSprite;
import flixel.FlxG;
import nape.geom.Vec2;

class Target extends FlxNapeSprite {

    var COLLISION_GROUP:Int = 2;
    var COLLISION_MASK:Int = ~1;
    var SENSOR_GROUP:Int = 2;
    var SENSOR_MASK:Int = ~6;

    public var hit:Bool = false;
    public function new(x:Float, y:Float, whichImage:String) {
        super(x, y, "assets/images/Target" + whichImage + ".png");
         this.body.setShapeMaterials(new Material(0.2, 1.0, 2.0, 10, 0.001));
         this.body.setShapeFilters(new InteractionFilter(COLLISION_GROUP, COLLISION_MASK, SENSOR_GROUP, SENSOR_MASK));
         this.body.shapes.at(0).sensorEnabled = true;
         this.body.name = 0; // 0 for target
         this.body.type = BodyType.STATIC;
     }

     override public function update(elapsed:Float):Void {
        super.update(elapsed);
        if(!hit && body.constraints.length > 0) {
            hit = true;
        }
     }
}