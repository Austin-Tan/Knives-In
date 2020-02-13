package;


import nape.phys.Material;
import flixel.util.FlxColor;
import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxGame;
import flixel.FlxSprite;
import flixel.FlxG;
import nape.geom.Vec2;

class Target extends FlxNapeSprite {

    public function new(x:Float, y:Float) {
        super(x, y, "assets/images/Target1.png");
         this.body.setShapeMaterials(Material.wood());
     }

     override public function update(elapsed:Float):Void {
        super.update(elapsed);
     }
}