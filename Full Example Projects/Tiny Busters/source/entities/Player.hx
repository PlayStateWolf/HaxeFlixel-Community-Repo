package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.actions.FlxAction.FlxActionDigital;
import flixel.input.actions.FlxActionManager;
import flixel.math.FlxPoint;

class Player extends FlxSprite
{
	// Basic Information
	var direction = 0;
	var speedMultiplier = 4;
	var autoDelay = 0;

	// Global Z-Depth Layer (ON_GROUND)
	// ! Defined in PlayState.hx
	public var zDepth = 1;

	public function new()
	{
		// declare actions and define callback functions

		super();
		loadGraphic("assets/images/car.png", true, 9, 8);

		animation.add("0", [0], 0, false);
		animation.add("1", [1], 0, false);
		animation.add("2", [2], 0, false);
		animation.add("3", [3], 0, false);
		animation.add("4", [4], 0, false);
		animation.add("5", [3], 0, false, true);
		animation.add("6", [2], 0, false, true);
		animation.add("7", [1], 0, false, true);
		animation.add("8", [0], 0, false, true);
		animation.add("9", [1], 0, false);
		animation.add("10", [2], 0, false);
		animation.add("11", [3], 0, false);
		animation.add("12", [4], 0, false);
		animation.add("13", [3], 0, false, true);
		animation.add("14", [2], 0, false, true);
		animation.add("15", [1], 0, false, true);
		direction = 0;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (Controls.autoLeft.triggered && autoDelay == 0)
		{
			autoDelay = 5;
			if (direction == 0)
				direction = 15;
			else
				direction--;
		}
		else if (Controls.autoRight.triggered && autoDelay == 0)
		{
			autoDelay = 5;
			if (direction == 15)
				direction = 0;
			else
				direction++;
		}

		#if FLX_MOUSE
		if (FlxG.mouse.pressed && FlxG.mouse.x < FlxG.state.camera.width / 2 && autoDelay == 0)
		{
			autoDelay = 5;
			if (direction == 0)
				direction = 15;
			else
				direction--;
		}
		else if (FlxG.mouse.pressed && FlxG.mouse.x > FlxG.state.camera.width / 2 && autoDelay == 0)
		{
			autoDelay = 5;
			if (direction == 15)
				direction = 0;
			else
				direction++;
		}
		#end

		animation.play(direction + "");

		switch direction
		{
			case 0:
				velocity.x = 0;
				velocity.y = -15 * speedMultiplier;
			case 1:
				velocity.x = 3.75 * speedMultiplier;
				velocity.y = -11.25 * speedMultiplier;
			case 2:
				velocity.x = 7.5 * speedMultiplier;
				velocity.y = -7.5 * speedMultiplier;
			case 3:
				velocity.x = 11.25 * speedMultiplier;
				velocity.y = -3.75 * speedMultiplier;
			case 4:
				velocity.x = 15 * speedMultiplier;
				velocity.y = 0;
			case 5:
				velocity.x = 11.25 * speedMultiplier;
				velocity.y = 3.75 * speedMultiplier;
			case 6:
				velocity.x = 7.5 * speedMultiplier;
				velocity.y = 7.5 * speedMultiplier;
			case 7:
				velocity.x = 3.75 * speedMultiplier;
				velocity.y = 11.25 * speedMultiplier;
			case 8:
				velocity.x = 0;
				velocity.y = 15 * speedMultiplier;
			case 9:
				velocity.x = -3.75 * speedMultiplier;
				velocity.y = 11.25 * speedMultiplier;
			case 10:
				velocity.x = -7.5 * speedMultiplier;
				velocity.y = 7.5 * speedMultiplier;
			case 11:
				velocity.x = -11.25 * speedMultiplier;
				velocity.y = 3.75 * speedMultiplier;
			case 12:
				velocity.x = -15 * speedMultiplier;
				velocity.y = 0;
			case 13:
				velocity.x = -11.25 * speedMultiplier;
				velocity.y = -3.75 * speedMultiplier;
			case 14:
				velocity.x = -7.5 * speedMultiplier;
				velocity.y = -7.5 * speedMultiplier;
			case 15:
				velocity.x = -3.75 * speedMultiplier;
				velocity.y = -11.25 * speedMultiplier;
			default:
				direction = 0;
		}

		updateAnimation(elapsed);

		if (autoDelay > 0)
			autoDelay--;
	}
}
