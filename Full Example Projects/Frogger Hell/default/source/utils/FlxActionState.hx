package utils;

import Controls;
import flixel.FlxG;
import flixel.FlxState;
import flixel.input.actions.FlxAction.FlxActionDigital;
import flixel.input.actions.FlxActionManager;

class FlxActionState extends FlxState
{
	override public function create():Void
	{
		super.create();

		// setup action manager if it doesn't exist
		// if (Controls.actionManager == null)
		Controls.setup();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		Controls.update();
	}
}
