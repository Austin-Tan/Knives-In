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

    public var COLLISION_GROUP:Int = 2;
    public var COLLISION_MASK:Int = ~1;
    public var SENSOR_GROUP:Int = 2;
    public var SENSOR_MASK:Int = ~7;

    var xVelocity:Int;
    var yVelocity:Int;
    var justTouch:Bool = false;
    var count:Int = 0;

    public var hit:Bool = false;
    public function new(x:Float, y:Float, whichImage:String, angle:Int=0, isKinemetic=false, xVelocity=0, yVelocity=0) {
        super(x, y, "assets/images/Target" + whichImage + ".png");
        this.body.rotation = (Math.PI / 180) * angle;
        this.scale.set(2, 2);
        updateHitbox();
        this.body.setShapeMaterials(new Material(0.2, 10.0, 20.0, 5, 0.001));
        this.body.setShapeFilters(new InteractionFilter(COLLISION_GROUP, COLLISION_MASK, SENSOR_GROUP, SENSOR_MASK));
        this.body.rotation = (Math.PI / 180) * angle;
        this.body.shapes.at(0).sensorEnabled = true;
        this.body.name = 0; // 0 for target

        if (!isKinemetic) {
            this.body.type = BodyType.STATIC;
        } else {
            this.body.type = BodyType.KINEMATIC;
            this.xVelocity = xVelocity;
            this.yVelocity = yVelocity;
            this.body.velocity.setxy(xVelocity, yVelocity);// = new Vec2(0,100);
        }
        // this.elasticity = 1000000;

     }

     override public function update(elapsed:Float):Void {
        super.update(elapsed);
        if (!hit && body.constraints.length > 0) {
            hit = true;
        }
        // make sure the target leaves the border
        if (justTouch) {
            count += 1;
            if (count == 10) {
                justTouch = false;
                count = 0;
            }
        }

     }
     public function collide(changeX:Int, changeY:Int) {
        if (hit || justTouch)
            return;
        trace("velocity: " + xVelocity + " " + yVelocity);
        trace("position: " + x + " " + y);
        xVelocity = changeX * xVelocity;
        yVelocity = changeY * yVelocity;
        this.body.velocity.setxy(xVelocity, yVelocity);
        justTouch = true;
        // if (changeY == -1) {
        //     setPosition(x, y + 1);
        // }
        //  this.body.velocity = new Vec2(xVelocity, yVelocity);
     }
}