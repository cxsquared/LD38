package;

import yarn.Yarn;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class MenuState extends FlxState
{
	override public function create():Void
	{
		super.create();

		var yarn = new Yarn("assets/data/yarnTest.json");

		yarn.Run();

		FlxG.log.add(yarn.GetCharacter() + ": " + yarn.GetCurrentText());
		yarn.NextLine();
		FlxG.log.add(yarn.GetCharacter() + ": " + yarn.GetCurrentText());
		yarn.NextLine();
		FlxG.log.add(yarn.GetCurrentText());
        yarn.SelectOption(0);
		FlxG.log.add(yarn.GetCharacter() + ": " + yarn.GetCurrentText());
		yarn.NextLine();
		FlxG.log.add(yarn.GetCharacter() + ": " + yarn.GetCurrentText());
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
