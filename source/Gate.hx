package;

import nape.dynamics.InteractionFilter;
import flixel.addons.nape.FlxNapeSpace;
import nape.phys.BodyType;
import flixel.FlxSprite;

class Gate extends FlxSprite {

    var button:HitButton;

    var timed:Bool;
    var timer:Float;    // resets after certain time

    public var open:Bool = false;

    var releaseKnives:Array<Knife>;
    override public function new(x:Float, y:Float, button:HitButton, timer:Float) {
        super(x, y);
        this.button = button;
		loadGraphic("assets/images/barrier.png", true, 32, 128);
        this.animation.add("closed", [0], 0, false);
        this.animation.add("opened", [4], 0, false);
        this.animation.add("opening", [0, 1, 2, 3, 4], 20, false);
        this.animation.add("closing", [4, 3, 2, 1, 0], 20, false);
        this.animation.play("closed");

        if(timer != 0) {
            timed = true;
            this.timer = timer;
        }
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
    }

    public function embedKnife(knife:Knife):Void {
        if (releaseKnives == null) {
            releaseKnives = new Array<Knife>();
        }
        releaseKnives.push(knife);
        knife.stuck = true;
        knife.body.type = BodyType.STATIC;
        knife.body.space = null;
        knife.metal_sound.play();
    }

    var collideAll:InteractionFilter = new InteractionFilter(2, ~1, 2, ~7);
    public function toggleGate():Void {
        open = !open;
        if(open) {
            this.animation.play("opening");
        } else {
            this.animation.play("closing");
        }
        if (releaseKnives != null) {
            for (knife in releaseKnives) {
                knife.body.type = BodyType.DYNAMIC;
                knife.body.space = FlxNapeSpace.space;
                knife.body.setShapeFilters(collideAll);
            }
        }

    }
}