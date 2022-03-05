package utils;

import flixel.FlxG;
import flixel.input.actions.FlxAction.FlxActionDigital;
import flixel.input.actions.FlxActionManager;
import utils.modified.BasicUISubState;

class FlxActionUISubState extends BasicUISubState
{
	override public function create():Void
	{
		super.create();
		Controls.setup();
		customCursor.setDefaultKeys(0);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		Controls.update();
		if (Controls.cursorLeft.triggered)
			customCursor.moveLeft(1);
		if (Controls.cursorRight.triggered)
			customCursor.moveRight(1);
		if (Controls.cursorUp.triggered)
			customCursor.moveUp(1);
		if (Controls.cursorDown.triggered)
			customCursor.moveDown(1);
		if (Controls.cursorClick.triggered)
			customCursor.click();
		if (Controls.cursorClickRelease.triggered)
			customCursor.clickRelease();
	}
}
