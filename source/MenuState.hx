package;

import flixel.tweens.FlxTween;
import planets.Planet;
import yarn.Yarn;
import flixel.FlxG;
import flixel.FlxState;

class MenuState extends FlxState
{
	private var pluto:Planet;
	private var planet:Planet;

	override public function create():Void
	{
		super.create();

		var yarn = new Yarn("assets/data/yarnTest.json");

		planet = new Planet(FlxG.width/2, FlxG.height/2, "assets/images/bigPlanet.png", "assets/images/bigFace.png");
		pluto = new Planet(FlxG.width/4, FlxG.height/2, "assets/images/plutoPlanet.png", "assets/images/plutoFace.png");
		add(planet);
		add(pluto);

        GoInFrontTwo();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

	}

	private function swapPlanets(plutoFirst:Bool) {
		var planet1Index:Int = -1;
		var planet2Index:Int = -1;

		var index = 0;
		for(item in members) {
			if (item == planet) {
				planet1Index = index;
			} else if (item == pluto) {
				planet2Index = index;
			}
			index++;
		}

        if (plutoFirst && planet1Index >= 0 && planet2Index >=0) {
            members[Std.int(Math.min(planet1Index, planet2Index))] = planet;
			members[Std.int(Math.max(planet1Index, planet2Index))] = pluto;
		} else if (planet1Index >= 0 && planet2Index >=0) {
			members[Std.int(Math.min(planet1Index, planet2Index))] = pluto;
			members[Std.int(Math.max(planet1Index, planet2Index))] = planet;
		}
	}

	private function StopOnDestroy(t:FlxTween) {
		if (!pluto.exists) {
			t.cancel();
		}
	}

	private function GoBehindOne(t:FlxTween=null) {
		swapPlanets(false);
		FlxTween.tween(pluto, {x:planet.x + planet.width/2 - pluto.width/2}, 2, {onComplete:GoBehindTwo});
	}

	private function GoBehindTwo(t:FlxTween=null) {
		FlxTween.tween(pluto, {x:planet.x + planet.width/2 + pluto.width*1.15}, 2, {onComplete:GoInFrontOne});
		FlxTween.tween(pluto.scale, {x: 1, y: 1}, 4, {onUpdate:StopOnDestroy});
	}

	private function GoInFrontOne(t:FlxTween=null) {
		swapPlanets(true);
		FlxTween.tween(pluto, {x:planet.x + planet.width/2 - pluto.width/2}, 2, {onComplete:GoInFrontTwo});
	}

	private function GoInFrontTwo(t:FlxTween=null) {
		FlxTween.tween(pluto, {x:planet.x - (pluto.width*1.15)}, 2, {onComplete:GoBehindOne});
        FlxTween.tween(pluto.scale, {x: .75, y: .75}, 4, {onUpdate:StopOnDestroy});
	}
}
