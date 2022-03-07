package;

import TrafficControl;
import entities.Car;
import entities.Entity;
import entities.Player;
import entities.Vehicle;
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
var carGroup:FlxGroup;

class PlayState extends FlxActionState {
    var traffic:TrafficControl;
    var offScreenLeft:Int;

    var offScreenRight:Int;

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

        offScreenLeft = -tileWidth;
        offScreenRight = Std.int(level.width + tileWidth);

        add(carGroup);
        loadObjects("assets/data/levels/level1/level1_objects.csv");

        FlxG.camera.scroll.y = level.height - camera.height;
        FlxG.camera.follow(player, TOPDOWN_TIGHT, 0.1);
        FlxG.camera.setScrollBounds(0, level.width, 0, level.height);
        FlxG.worldBounds.set(0, 0, level.width, level.height);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
        traffic.update(elapsed);
        FlxG.overlap(player, carGroup, onPlayerOverlapsCar);
    }

    public function loadObjects(path:String):Bool {
        if (!Assets.exists(path)) {
            trace("PATH NOT FOUND");
            return false;
        }
        trace("PATH FOUND");
        var spawners:Array<Spawner> = [];
        var lines = Assets.getText(path).split("\n");
        trace(lines);
        // set spawnWithDebugValues to true for cars that would generate fast enough that they would overlap each other
        var spawnWithDebugValues = false;
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
                    if (spawnWithDebugValues) {
                        var spawn:Spawner = {
                            collisionGroup: new FlxTypedGroup<Vehicle>(),
                            type: params[1],
                            direction: params[2],
                            xPos: determineSpawnerX(params[2]),
                            yPos: Std.parseInt(params[3]) * tileHeight,
                            vehicleSpeed: 100,
                            amount: Std.parseInt(params[4]),
                            timeUntilNextSpawn: 0,
                            delayBetweenSpawns: 0.05,
                            assetPath: "assets/images/Car.png"
                        }
                        spawners.push(spawn);
                    } else {
                        var spawn:Spawner = {
                            collisionGroup: new FlxTypedGroup<Vehicle>(),
                            type: params[1],
                            direction: params[2],
                            xPos: determineSpawnerX(params[2]),
                            yPos: Std.parseInt(params[3]) * tileHeight,
                            vehicleSpeed: FlxG.random.float(25, 350),
                            amount: Std.parseInt(params[4]),
                            timeUntilNextSpawn: 0,
                            delayBetweenSpawns: FlxG.random.float(0.05, 5),
                            assetPath: "assets/images/Car.png"
                        }
                        spawners.push(spawn);
                    }
            }
        }
        traffic = new TrafficControl(spawners, carGroup);
        add(objectGroup);
        return true;
    }

    var playerGotHit:Bool = false;

    function onPlayerOverlapsCar(player:FlxSprite, car:FlxSprite) {
        if (!playerGotHit) {
            trace('car hit');
            playerGotHit = true;
        }
    }

    function determineSpawnerX(direction:String):Int {
        return direction == "RIGHT" ? offScreenLeft : offScreenRight;
    }
}
