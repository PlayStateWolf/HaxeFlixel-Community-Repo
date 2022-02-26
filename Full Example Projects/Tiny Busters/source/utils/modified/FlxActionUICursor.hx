package utils.modified;

import flixel.FlxG;
import flixel.addons.ui.FlxUICursor;
import flixel.input.actions.FlxAction;

/**
 * A `FlxUICursor` that implements some publicily accessible functions to move around the UI's widgets and click them.
 */
class FlxActionUICursor extends FlxUICursor
{
	/**
	 * Set to true when clicking is detected, and false otherwise.
	 */
	public var isClick:Bool = false;

	/**
	 * Moves the cursor left, wrapping if necessary.
	 * 
	 * @param _steps the amount of steps we want to take in the direction, 1 to move to the next widget
	 * @param _recursion no clue what this does
	 */
	public function moveLeft(_steps:Int = 1, _recursion:Int = 0)
	{
		_doInput(-_steps, 0, _recursion);
		#if debug
		trace('LEFT PRESS');
		#end
	}

	/**
	 * Moves the cursor up, wrapping if necessary.
	 * 
	 * @param _steps the amount of steps we want to take in the direction, 1 to move to the next widget
	 * @param _recursion no clue what this does
	 */
	public function moveUp(_steps:Int = 1, _recursion:Int = 0)
	{
		_doInput(0, -_steps, _recursion);
		#if debug
		trace('UP PRESS');
		#end
	}

	/**
	 * Moves the cursor right, wrapping if necessary.
	 * 
	 * @param _steps the amount of steps we want to take in the direction, 1 to move to the next widget
	 * @param _recursion no clue what this does
	 */
	public function moveRight(_steps:Int = 1, _recursion:Int = 0)
	{
		_doInput(_steps, 0, _recursion);
		#if debug
		trace('RIGHT PRESS');
		#end
	}

	/**
	 * Moves the cursor down, wrapping if necessary.
	 * 
	 * @param _steps the amount of steps we want to take in the direction, 1 to move to the next widget
	 * @param _recursion no clue what this does
	 */
	public function moveDown(_steps:Int = 1, _recursion:Int = 0)
	{
		_doInput(0, _steps, _recursion);
		#if debug
		trace('DOWN PRESS');
		#end
	}

	/**
	 * Simulates a click on the currently selected UI widget.
	 */
	public function click()
	{
		isClick = true;
	}

	/**
	 * Simulates click release on the currently selected UI widget.
	 */
	public function clickRelease()
	{
		isClick = false;
	}

	override private function _clickKeysJustPressed():Bool
	{
		if (isClick)
		{
			return true;
		}
		return false;
	}

	override private function _clickKeysPressed():Bool
	{
		if (isClick)
		{
			return true;
		}
		return false;
	}
}
