package states;

import flixel.FlxG;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUITypedButton;
import flixel.addons.ui.interfaces.IFlxUIWidget;
import utils.FlxActionUIState;

/**
 * A FlxState displaying the game's option menu
 */
class OptionsState extends FlxActionUIState
{
	override public function create():Void
	{
		_xml_id = "options"; // needs to be set before calling create()
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
						case controls = "butt_0":
							var newState = new ControlsState();
							// newState.actionManager = this.actionManager;
							FlxG.switchState(newState);
						case opt2 = "butt_1":
						// Controls.touchscreen != Controls.touchscreen;
						case back = "butt_5":
							var newState = new MainMenuState();
							// newState.actionManager = this.actionManager;
							FlxG.switchState(newState);
					}
				}
		}
	}
}
