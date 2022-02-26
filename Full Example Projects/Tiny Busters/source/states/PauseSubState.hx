package states;

import flixel.FlxG;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUITypedButton;
import flixel.addons.ui.interfaces.IFlxUIWidget;
import utils.FlxActionUISubState;

/**
 * A FlxState which can be used for the game's menu.
 */
class PauseSubState extends FlxActionUISubState
{
	var state:PlayState;

	override public function create():Void
	{
		_xml_id = "pause"; // needs to be set before calling create()
		// actionManager.
		super.create();
	}

	override public function getEvent(eventName:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Void
	{
		if (destroyed)
		{
			return;
		}

		switch (eventName) // check which event was called
		{
			case FlxUITypedButton.OVER_EVENT:
			// Do Something

			case FlxUITypedButton.CLICK_EVENT:
				var widget:IFlxUIWidget = cast(sender, IFlxUIWidget); // get the widget that called the event
				if (widget != null && (widget is FlxUIButton)) // we are over a button indeed
				{
					var btn:FlxUIButton = cast(widget, FlxUIButton); //  get the btn
					switch (btn.name)
					{
						case race = "butt_0":
							// state.actionManager = this.actionManager;
							close();
						case options = "butt_1":
							var newState = new MainMenuState();
							// newState.actionManager = this.actionManager;
							FlxG.switchState(newState);
					}
				}
		}
	}

	public function setState(instate:PlayState)
	{
		state = instate;
	}
}
