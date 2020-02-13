package;


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

    public function new(x:Float, y:Float) {
        super(x, y, "assets/images/Target1.png");
         this.body.setShapeMaterials(Material.wood());
         this.body.setShapeFilters(new InteractionFilter(COLLISION_GROUP, COLLISION_MASK));
     }

     override public function update(elapsed:Float):Void {
        super.update(elapsed);
     }
}