package;

import entities.Car;
import entities.Player;
import flixel.FlxG;
import flixel.FlxObject;
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
import lime.graphics.cairo.Cairo;
import lime.utils.Assets;
import utils.FlxActionState;
import utils.FlxActionUIState;

var player:Player;
var playerStartX:Int;
var playerStartY:Int;
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
var spawners:Array<Spawner>;
var carGroup:FlxGroup;

class PlayState extends FlxActionState {
    override public function create() {
        super.create();

        tileWidth = 32;
        tileHeight = 32;
        tileSize = new FlxPoint(tileWidth, tileHeight);
        tileSpacing = new FlxPoint(2, 2);
        tileBorder = new FlxPoint(2, 2);
        objectGroup = new FlxGroup(0);
        carGroup = new FlxGroup(0);

        // Shared FlxTileFrames Object For Keeping Our Game Clean
        tileFrames = FlxTileFrames.fromBitmapAddSpacesAndBorders("assets/images/Tileset.png", tileSize, tileSpacing, tileBorder);
        level = new FlxTilemapExt();
        level.loadMapFromCSV("assets/data/levels/level1/level1.csv", tileFrames, 32, 32);
        add(level);

        spawners = new Array<Spawner>();

        loadObjects("assets/data/levels/level1/level1_objects.csv");

        for (sp in spawners) {
            var collection:FlxGroup = new FlxGroup(0);
            if (sp.direction == "RIGHT") {
                for (i in 0...sp.amount) {
                    var car = new Car(-tileWidth, sp.type, sp.direction, sp.yPos * tileHeight);
                    car.x = Std.random(Std.int(level.width + tileWidth)) - tileWidth;
                    // collection.add(car);
                    carGroup.add(car);
                }
                // add(car);
            } else {
                for (i in 0...sp.amount) {
                    var car = new Car(Std.int(level.width), sp.type, sp.direction, sp.yPos * tileHeight);
                    car.x = Std.random(Std.int(level.width + tileWidth)) - tileWidth;
                    // collection.add(car);
                    carGroup.add(car);
                }
                // add(car);
                // carGroup.add(collection);
            }
        }
        add(carGroup);
        FlxG.camera.scroll.y = level.height - camera.height;
        FlxG.camera.follow(player, TOPDOWN_TIGHT, 0.1);
        FlxG.camera.setScrollBounds(0, level.width, 0, level.height);
        FlxG.worldBounds.set(0, 0, level.width, level.height);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
        carGroup.update(elapsed);
        player.update(elapsed);
        // trace("PlayerX:" + player.x + " PlayerY: " + player.y);
        // trace("Rock0 X: " + objectGroup.members[0]. + " Rock0 Y: " + objectGroup.members[0].y));
        FlxG.overlap(player, carGroup, onPlayerOverlapsCar); // FlxG.collide(player, objectGroup);
    }

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
                    playerStartX = Std.parseInt(params[1]) * tileWidth;
                    playerStartY = Std.parseInt(params[2]) * tileHeight;
                    player = new Player(playerStartX, playerStartY);
                    player.loadGraphic("assets/images/Player.png");
                    player.canMove = true;
                    add(player);
                case "Rock":
                    // trace("Rock was found");
                    var rock:FlxSprite = new FlxSprite(Std.parseInt(params[1]) * tileHeight, Std.parseInt(params[2]) * tileHeight);
                    rock.loadGraphic("assets/images/Rock.png");
                    objectGroup.add(rock);
                case "Spawner":
                    var spawn:Spawner = {
                        collection: new FlxGroup(0),
                        type: params[1],
                        direction: params[2],
                        yPos: Std.parseInt(params[3]),
                        amount: Std.parseInt(params[4])
                    };
                    spawners.push(spawn);
            }
        }
        add(objectGroup);
        return true;
    }

    function onPlayerOverlapsCar(player:FlxSprite, car:FlxSprite) {
        trace('car hit');
    }
}

typedef Spawner = {
    var collection:FlxGroup;
    var type:String;
    var direction:String;
    var yPos:Int;
    var amount:Int;
}
