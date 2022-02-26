package states;

import entities.Player;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxTiledSprite;
import flixel.addons.tile.FlxTileSpecial;
import flixel.addons.tile.FlxTilemapExt;
import flixel.graphics.frames.FlxTileFrames;
import flixel.input.actions.FlxAction.FlxActionDigital;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.tile.FlxTile;
import flixel.tile.FlxTilemap;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import utils.FlxActionState;
import utils.FlxActionUISubState;

class PlayState extends FlxActionState
{
	// Player Info
	var player:Player;
	var startX:Int;
	var startY:Int;
	var playerZone:Int;

	// Basic Tilemap Info
	var tileWidth:Int;
	var tileHeight:Int;
	var tileSize:FlxPoint;
	var tileSpacing:FlxPoint;
	var tileBorder:FlxPoint;
	var tileFrames:FlxTileFrames;

	// Track Info
	var track0:FlxTilemapExt;
	var track1:FlxTilemapExt;
	var shadows:FlxTilemapExt;
	var collision0:FlxTilemapExt;
	var collision1:FlxTilemapExt;
	var collision2:FlxTilemapExt;
	var collision3:FlxTilemapExt;
	var collision4:FlxTilemapExt;
	var collision5:FlxTilemapExt;
	var zones:FlxTilemapExt;
	var text:FlxText;

	// Global Z-Depth Variables (Entities use Local Z-Depth Variables)
	var track0Z:Int;
	var track1Z:Int;
	var shadowsZ:Int;

	// Setup and Initalize Our PlayState
	override public function create():Void
	{
		// Basically Calls FlxActionUIState.create() For Pre-Initialization
		super.create();

		// Initialize Basic Tilemap Information (Fixes Tearing)
		tileWidth = 20;
		tileHeight = 20;
		tileSize = new FlxPoint(tileWidth, tileHeight);
		tileSpacing = new FlxPoint(2, 2);
		tileBorder = new FlxPoint(2, 2);

		// Shared FlxTileFrames Object For Keeping Our Game Clean
		tileFrames = FlxTileFrames.fromBitmapAddSpacesAndBorders("assets/images/collisiontiles.png", tileSize, tileSpacing, tileBorder);

		// Setup Our Collision Areas
		collision0 = new FlxTilemapExt();
		collision0.useScaleHack = true;
		collision0.loadMapFromCSV("assets/images/track1_collision0.csv", tileFrames);
		collision1 = new FlxTilemapExt();
		collision1.useScaleHack = true;
		collision1.loadMapFromCSV("assets/images/track1_collision1.csv", tileFrames);
		collision2 = new FlxTilemapExt();
		collision2.useScaleHack = true;
		collision2.loadMapFromCSV("assets/images/track1_collision2.csv", tileFrames);
		collision3 = new FlxTilemapExt();
		collision3.useScaleHack = true;
		collision3.loadMapFromCSV("assets/images/track1_collision3.csv", tileFrames);
		collision4 = new FlxTilemapExt();
		collision4.useScaleHack = true;
		collision4.loadMapFromCSV("assets/images/track1_collision4.csv", tileFrames);
		collision5 = new FlxTilemapExt();
		collision5.useScaleHack = true;
		collision5.loadMapFromCSV("assets/images/track1_collision5.csv", tileFrames);

		// Apply Custom Properties Last For Clarity
		collision0.setTileProperties(0, FlxObject.NONE);
		collision1.setTileProperties(0, FlxObject.NONE);
		collision2.setTileProperties(0, FlxObject.NONE);
		collision3.setTileProperties(0, FlxObject.NONE);
		collision4.setTileProperties(0, FlxObject.NONE);
		collision5.setTileProperties(0, FlxObject.NONE);

		// Setup Our Zones And Recycle Our FlxTileFrames Object
		zones = new FlxTilemapExt();
		zones.useScaleHack = true;
		tileFrames = FlxTileFrames.fromBitmapAddSpacesAndBorders("assets/images/zones.png", tileSize, tileSpacing, tileBorder);
		add(zones.loadMapFromCSV("assets/images/track1_zones.csv", tileFrames));

		// Setup Our Track And Recycle Our FlxTileFrames Object
		track0 = new FlxTilemapExt();
		track0.useScaleHack = true;
		tileFrames = FlxTileFrames.fromBitmapAddSpacesAndBorders("assets/images/track1tileset.png", tileSize, tileSpacing, tileBorder);
		add(track0.loadMapFromCSV("assets/images/track1_track0.csv", tileFrames));

		// Initialize Our Player
		// ! The Order We Add Tilemaps And Entities Matter!!! (Newer Objects Overlap Older Objects)
		player = new Player();
		player.x = 220;
		player.y = 100;
		playerZone = 0;
		add(player);

		// Second Track Layer
		track1 = new FlxTilemapExt();
		track1.useScaleHack = true;
		tileFrames = FlxTileFrames.fromBitmapAddSpacesAndBorders("assets/images/track1tileset.png", tileSize, tileSpacing, tileBorder);
		add(track1.loadMapFromCSV("assets/images/track1_track1.csv", tileFrames));

		// Setup Our Shadows And Recycle Our FlxTileFrames Object
		shadows = new FlxTilemapExt();
		tileFrames = FlxTileFrames.fromBitmapAddSpacesAndBorders("assets/images/shadows.png", tileSize, tileSpacing, tileBorder);
		add(shadows.loadMapFromCSV("assets/images/track1_shadows.csv", tileFrames));

		// Setup Debug Features
		text = new FlxText(0, 0, FlxG.width, "COLLISION AREA: " + playerZone, 10);
		add(text);

		/*
			Z-Depth Global Layers

			0 == GROUND (tilemap only)
			1 == ON_GROUND (objects only)
			2 == RAISED_GROUND (tilemap only)
			3 == ON_RAISED_GROUND (objects only)
			4 == SHADOWS (tilemap only)

		 */

		track0Z = 0; // The Ground
		track1Z = 2; // The Raised Platform
		shadowsZ = 4; // Shadows Are Displayed Above Everything
	}

	// Runs Over And Over Again Throughout PlayState's Lifetime
	override public function update(elapsed:Float):Void
	{
		// Basically Calls FlxActionUIState.update(elapsed) For Pre-Configuration
		super.update(elapsed);

		// Refresh The Screen
		FlxG.camera.bgColor = FlxColor.BLACK;

		// Debug Features
		text.text = "COLLISION AREA: " + playerZone;
		text.update(elapsed);

		// Check Collision with Zone Tiles
		zones.overlapsWithCallback(player, updateZones);

		// Collision Checks For Each Collision Area
		if (playerZone == 0)
			collision0.overlapsWithCallback(player, tilemapCollide);
		else if (playerZone == 1)
			collision1.overlapsWithCallback(player, tilemapCollide);
		else if (playerZone == 2)
			collision2.overlapsWithCallback(player, tilemapCollide);
		else if (playerZone == 3)
			collision3.overlapsWithCallback(player, tilemapCollide);
		else if (playerZone == 4)
			collision4.overlapsWithCallback(player, tilemapCollide);
		else if (playerZone == 5)
			collision5.overlapsWithCallback(player, tilemapCollide);

		// Update the Z-Depth of Every Object
		updateZDepth();

		// Apply Our Controls
		if (Controls.pause.triggered)
		{
			var tempState:PauseSubState = new PauseSubState();
			tempState.setState(this);
			openSubState(tempState);
		}
	}

	// Apply Track Collisions
	public function tilemapCollide(Tile:FlxObject, Object:FlxObject):Bool
	{
		if (Object == player && Tile.allowCollisions == ANY)
			FlxG.collide(Tile, Object);
		return false;
	}

	// Swap Collision Areas Based On Zone Tiles
	public function updateZones(Tile:FlxObject, Object:FlxObject):Bool
	{
		var index = zones.getTileByIndex(zones.getTileIndexByCoords(player.getMidpoint()));
		if (index >= 1)
			playerZone = index - 1;
		return false;
	}

	// Simple Z-Depth Stuff
	public function updateZDepth()
	{
		// Update Player's Z-Depth variable
		if (playerZone == 0)
			player.zDepth = 1;
		else if (playerZone == 3)
			player.zDepth = 3;
		else if (playerZone == 4)
			player.zDepth = 1;
		else if (playerZone == 5)
			player.zDepth = 3;

		// The Z-Depth Sort Function
		this.members.sort(zSort);
	}

	/*
		Complex Z-Depth Stuff Goes Here

		We compare each object's Z-Depth against each other
		When Object 1 has a higher value than Object 2, Object 1 gets sorted above Object 2
		When Object 2 has a higher value than Object 1, Object 2 gets sorted above Object 1
		No sorting for objects with the same Z-Depth value

		The Z-Depth order determines what gets displayed above what in the State, creating "depth"
	 */
	public function zSort(obj0:FlxBasic, obj1:FlxBasic):Int
	{
		// Our Comparable Global Z-Depth Layers
		var a = 0;
		var b = 0;

		// GROUND Z-Depth
		if (obj0 == track0)
			a = track0Z;
		else if (obj1 == track0)
			b = track0Z;

		// RAISED_GROUND Z-Depth
		if (obj0 == track1)
			a = track1Z;
		else if (obj1 == track1)
			b = track1Z;

		// SHADOWS Z-Depth
		if (obj0 == shadows)
			a = shadowsZ;
		else if (obj1 == shadows)
			b = shadowsZ;

		// Entities Use Local Z-Depth Variables
		if (obj0 == player)
		{
			a = cast(obj0, Player).zDepth;
		}
		else if (obj1 == player)
		{
			b = cast(obj1, Player).zDepth;
		}

		// Compare and Return
		if (a < b)
			return -1;
		if (a > b)
			return 1;
		return 0;
	}
}
