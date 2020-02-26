package;


import lime.math.Vector2;
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
    var SENSOR_MASK:Int = ~7;

    var xVelocity:Int;
    var yVelocity:Int;

    public var hit:Bool = false;
    public function new(x:Float, y:Float, whichImage:String, angle:Int=0, isKinemetic=false, xVelocity=0, yVelocity=0) {
        super(x, y, "assets/images/Target" + whichImage + ".png");
        this.body.rotation = (Math.PI / 180) * angle;
        this.scale.set(2, 2);
        this.body.setShapeMaterials(new Material(0.2, 10.0, 20.0, 5, 0.001));
        this.body.setShapeFilters(new InteractionFilter(COLLISION_GROUP, COLLISION_MASK, SENSOR_GROUP, SENSOR_MASK));
        this.body.rotation = (Math.PI / 180) * angle;
        this.body.shapes.at(0).sensorEnabled = true;
        this.body.name = 0; // 0 for target
        // 26 x 32
        this.setSize(26, 32);

        if (!isKinemetic) {
            this.body.type = BodyType.STATIC;
        } else {
            this.body.type = BodyType.KINEMATIC;
            this.xVelocity = xVelocity;
            this.yVelocity = yVelocity;
            this.body.velocity.setxy(xVelocity, yVelocity);// = new Vec2(0,100);
        }

     }

     override public function update(elapsed:Float):Void {
        super.update(elapsed);
        if (!hit && body.constraints.length > 0) {
            hit = true;
        }

     }
     public function collide(changeX:Int, changeY:Int) {
        xVelocity = changeX * xVelocity;
        yVelocity = changeY * yVelocity;
        this.body.velocity.setxy(xVelocity, yVelocity);
        //  this.body.velocity = new Vec2(xVelocity, yVelocity);
     }
}