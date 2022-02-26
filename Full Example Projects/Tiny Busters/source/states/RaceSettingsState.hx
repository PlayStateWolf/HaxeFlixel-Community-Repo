package states;

import flixel.FlxG;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUITypedButton;
import flixel.addons.ui.interfaces.IFlxUIWidget;
import states.PlayState;
import utils.FlxActionUIState;

/**
 * A FlxState displaying the game's option menu
 */
class RaceSettingsState extends FlxActionUIState
{
	override public function create():Void
	{
		_xml_id = "racesettings"; // needs to be set before calling create()
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
			// fade background to one related to selection
			case FlxUITypedButton.CLICK_EVENT:
				var widget:IFlxUIWidget = cast(sender, IFlxUIWidget); // get the widget that called the event
				if (widget != null && (widget is FlxUIButton)) // we are over a button indeed
				{
					var btn:FlxUIButton = cast(widget, FlxUIButton); //  get the btn
					switch (btn.name)
					{
						case race1 = "butt_0":
							var newState = new PlayState();
							// newState.actionManager = this.actionManager;
							FlxG.switchState(newState);
						case race2 = "butt_1":
						case race3 = "butt_2":
						case race4 = "butt_3":
						case race5 = "butt_4":
						case mainmenu = "butt_5":
							var newState = new MainMenuState();
							// newState.actionManager = this.actionManager;
							FlxG.switchState(newState);
					}
				}
		}
	}
}
