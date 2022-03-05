package;

import entities.Player;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.tiled.TiledLayer.TiledLayerType;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.tile.FlxTilemapExt;
import flixel.graphics.frames.FlxTileFrames;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import lime.utils.Assets;
import utils.FlxActionState;
import utils.FlxActionUIState;

var player:Player;
var level:FlxTilemapExt;

// Basic Tilemap Info
var tileWidth:Int;
var tileHeight:Int;
var tileSize:FlxPoint;
var tileSpacing:FlxPoint;
var tileBorder:FlxPoint;
var tileFrames:FlxTileFrames;
var objectGroup:FlxGroup;
var playerMoving:Bool;

class PlayState extends FlxActionState {
    override public function create() {
        super.create();

        tileWidth = 32;
        tileHeight = 32;
        tileSize = new FlxPoint(tileWidth, tileHeight);
        tileSpacing = new FlxPoint(2, 2);
        tileBorder = new FlxPoint(2, 2);
        objectGroup = new FlxGroup(0);

        // Shared FlxTileFrames Object For Keeping Our Game Clean
        tileFrames = FlxTileFrames.fromBitmapAddSpacesAndBorders("assets/images/Tileset.png", tileSize, tileSpacing, tileBorder);
        level = new FlxTilemapExt();
        level.loadMapFromCSV("assets/data/levels/level1/level1.csv", tileFrames, 32, 32);
        add(level);

        loadObjects("assets/data/levels/level1/level1_objects.csv");
        FlxG.camera.follow(player, TOPDOWN_TIGHT, 0.1);
        FlxG.camera.setScrollBounds(0, level.width, 0, level.height);

        // FlxG.collide(player, objectGroup);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
        trace("PlayerX:" + player.x + " PlayerY: " + player.y);
        // trace("Rock0 X: " + objectGroup.members[0]. + " Rock0 Y: " + objectGroup.members[0].y));

        if (Controls.cursorUp.triggered) {
            if (player.canMove) {
                var tempPos:FlxPoint = level.getTileCoordsByIndex(level.getTileByIndex(level.getTileIndexByCoords(player.getPosition())));
                player.moveToPos(player.x, player.y - tileHeight, 0.2);
            }
        }
        if (Controls.cursorDown.triggered) {
            var tempPos:FlxPoint = level.getTileCoordsByIndex(level.getTileByIndex(level.getTileIndexByCoords(player.getPosition())));
            player.moveToPos(player.x, player.y + tileHeight, 0.2);
        }
        if (Controls.cursorLeft.triggered) {
            if (player.canMove) {
                var tempPos:FlxPoint = level.getTileCoordsByIndex(level.getTileByIndex(level.getTileIndexByCoords(player.getPosition())));
                player.moveToPos(player.x - tileWidth, player.y, 0.2);
            }
        }
        if (Controls.cursorRight.triggered) {
            if (player.canMove) {
                var tempPos:FlxPoint = level.getTileCoordsByIndex(level.getTileByIndex(level.getTileIndexByCoords(player.getPosition())));
                player.moveToPos(player.x + tileWidth, player.y, 0.2);
            }
        }
        if (FlxG.overlap(player, objectGroup))
            player.resetPosition();
    }

    public function moveObjectToPoint(object:FlxSprite, targetX:Int, targetY:Int) {}

    public function loadObjects(path:String):Bool {
        if (!Assets.exists(path)) {
            trace("PATH NOT FOUND");
            return false;
        }
        trace("PATH FOUND");
        var lines = Assets.getText(path).split("\n");
        trace(lines);
        for (line in lines) {
            var params = line.split(",");
            switch (params[0]) {
                case "Player":
                    trace("Player was found");
                    player = new Player(Std.parseInt(params[1]) * tileWidth, Std.parseInt(params[2]) * tileHeight);
                    player.loadGraphic("assets/images/Player.png");
                    trace(player.x);
                    add(player);
                case "Rock":
                    trace("Rock was found");
                    var rock:FlxSprite = new FlxSprite(Std.parseInt(params[1]) * tileHeight, Std.parseInt(params[2]) * tileHeight);
                    rock.loadGraphic("assets/images/Rock.png");
                    objectGroup.add(rock);
            }
        }
        add(objectGroup);
        return true;
    }
}
