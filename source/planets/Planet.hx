package planets;
import flixel.group.FlxSpriteGroup;
import flixel.FlxG;
import flixel.FlxSprite;

class Planet extends FlxSpriteGroup {

    private var face:FlxSprite;
    private var planet:FlxSprite;

    public function new(X:Float, Y:Float, PlanetImage:Dynamic, FaceImage:Dynamic) {
        super(X, Y);

        planet = new FlxSprite();
        planet.loadGraphic(PlanetImage, true, 128, 128);
        planet.animation.add("rotate", [0,1,2,3,4,5], 5, true);
        planet.animation.play("rotate");
        add(planet);

        face = new FlxSprite();
        face.loadGraphic(FaceImage, true, 128, 128);
        face.animation.add("rotate", [0,1,2,3,4,5], 5, true);
        face.animation.play("rotate");
        add(face);
    }
}
