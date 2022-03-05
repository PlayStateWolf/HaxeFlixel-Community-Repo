package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.input.FlxAccelerometer;
import flixel.input.actions.FlxAction;
import flixel.input.actions.FlxActionManager;
import flixel.input.touch.FlxTouch;
import flixel.input.touch.FlxTouchManager;
import flixel.ui.FlxButton;

class Controls
{
	/**
	 * Our action manager.
	 */
	public static var actionManager:FlxActionManager;

	/**
	 * Our action triggered when the cursor should move left.
	 * 
	 * We can optionally pass in a callback in the constructor for when the action is triggered.
	 */
	public static var cursorLeft:FlxActionDigital;

	public static var autoLeft:FlxActionDigital;

	/**
	 * Our action triggered when the cursor should move up.
	 */
	public static var cursorUp:FlxActionDigital;

	public static var autoUp:FlxActionDigital;

	/**
	 * Our action triggered when the cursor should move right.
	 */
	public static var cursorRight:FlxActionDigital;

	public static var autoRight:FlxActionDigital;

	/**
	 * Our action triggered when the cursor should move down.
	 */
	public static var cursorDown:FlxActionDigital;

	public static var autoDown:FlxActionDigital;

	/**
	 * Our action triggered when the cursor should click.
	 */
	public static var cursorClick:FlxActionDigital;

	/**
	 * Our action triggered when the cursor click should be released.
	 */
	public static var cursorClickRelease:FlxActionDigital;

	/**
	 * Our action triggered when we press the pause button.
	 */
	public static var pause:FlxActionDigital;

	public static function setup()
	{
		actionManager = FlxG.inputs.add(new FlxActionManager());
		cursorLeft = new FlxActionDigital("cursor_left");
		autoLeft = new FlxActionDigital("auto_left");
		cursorUp = new FlxActionDigital("cursor_up");
		autoUp = new FlxActionDigital("auto_up");
		cursorRight = new FlxActionDigital("cursor_right");
		autoRight = new FlxActionDigital("auto_right");
		cursorDown = new FlxActionDigital("cursor_down");
		autoDown = new FlxActionDigital("auto_down");
		cursorClick = new FlxActionDigital("cursor_click");
		cursorClickRelease = new FlxActionDigital("cursor_click_release");
		pause = new FlxActionDigital("pause");
		// add sets of keys that will trigger our actions
		setupWASDLayout();
		setupArrowsLayout();
		setupGamepadLayout();

		// add all of our actions to the manager
		actionManager.addActions([
			cursorLeft, cursorUp, cursorRight, cursorDown, cursorClick, cursorClickRelease, autoLeft, autoUp, autoRight, autoDown
		]);
	}

	public static function update()
	{
		cursorLeft.update();
		cursorUp.update();
		cursorRight.update();
		cursorDown.update();
		cursorClick.update();
		cursorClickRelease.update();
		autoLeft.update();
		autoUp.update();
		autoRight.update();
		autoDown.update();
		pause.update();
	}

	/**
	 * Add the default WASD layout keys to our actions.
	 */
	static function setupWASDLayout()
	{
		cursorLeft.addKey(A, JUST_PRESSED);
		cursorUp.addKey(W, JUST_PRESSED);
		cursorRight.addKey(D, JUST_PRESSED);
		cursorDown.addKey(S, JUST_PRESSED);
		cursorClick.addKey(ENTER, JUST_PRESSED);
		cursorClickRelease.addKey(ENTER, JUST_RELEASED);
		autoLeft.addKey(A, PRESSED);
		autoUp.addKey(W, PRESSED);
		autoRight.addKey(D, PRESSED);
		autoDown.addKey(S, PRESSED);
		pause.addKey(ESCAPE, PRESSED);
	}

	/**
	 * Add the default arrows input keys to our actions.
	 */
	static function setupArrowsLayout()
	{
		cursorLeft.addKey(LEFT, JUST_PRESSED);
		cursorUp.addKey(UP, JUST_PRESSED);
		cursorRight.addKey(RIGHT, JUST_PRESSED);
		cursorDown.addKey(DOWN, JUST_PRESSED);
		autoLeft.addKey(LEFT, PRESSED);
		autoUp.addKey(UP, PRESSED);
		autoRight.addKey(RIGHT, PRESSED);
		autoDown.addKey(DOWN, PRESSED);
		cursorClick.addKey(Z, JUST_PRESSED);
		cursorClickRelease.addKey(Z, JUST_RELEASED);
		pause.addKey(ENTER, PRESSED);
	}

	/**
	 * Add the default gamepad input keys to our actions.
	 */
	static function setupGamepadLayout()
	{
		cursorLeft.addGamepad(DPAD_LEFT, JUST_PRESSED);
		cursorUp.addGamepad(DPAD_UP, JUST_PRESSED);
		cursorRight.addGamepad(DPAD_RIGHT, JUST_PRESSED);
		cursorDown.addGamepad(DPAD_DOWN, JUST_PRESSED);
		autoLeft.addGamepad(DPAD_LEFT, PRESSED);
		autoUp.addGamepad(DPAD_UP, PRESSED);
		autoRight.addGamepad(DPAD_RIGHT, PRESSED);
		autoDown.addGamepad(DPAD_DOWN, PRESSED);
		cursorClick.addGamepad(A, JUST_PRESSED);
		cursorClickRelease.addGamepad(A, JUST_RELEASED);
		pause.addGamepad(START, PRESSED);
	}
}
