package;


import flixel.addons.nape.FlxNapeSpace;
import nape.shape.Polygon;
import nape.phys.BodyType;
import nape.phys.Body;
import nape.dynamics.InteractionFilter;
import nape.phys.Material;
import flixel.util.FlxColor;
import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxGame;
import flixel.FlxSprite;
import flixel.FlxG;
import nape.geom.Vec2;

class Platform extends FlxSprite {

    public var body:Body;

    var COLLISION_GROUP:Int = 4;
    var COLLISION_MASK:Int = ~1;
    var SENSOR_GROUP:Int = 4;
    var SENSOR_MASK:Int = ~6;

    override public function new(x:Int, y:Int, width:Int, height:Int) {
        super(x, y);

        this.body = new Body(BodyType.STATIC);        
        this.body.shapes.add(new Polygon(Polygon.rect(x, y, width, height)));
        this.body.setShapeFilters(new InteractionFilter(COLLISION_GROUP, COLLISION_MASK, SENSOR_GROUP, SENSOR_MASK));
        this.body.space = FlxNapeSpace.space;
        this.body.name = 2; // 2 for platform

        makeGraphic(width, height, FlxColor.BROWN);
    }
}