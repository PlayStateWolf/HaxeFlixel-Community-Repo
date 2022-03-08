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

        offScreenLeft = 0 - tileWidth;
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
        if (FlxG.keys.justReleased.R) {
            FlxG.resetState();
        }
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
        var spawnWithDebugValues = true;
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
                    var direction = params[2];
                    var spawnerXPos = determineSpawnerX(direction);
                    var spawnerYPos = Std.parseInt(params[3]) * tileHeight;
                    var endDestinationX = determineVehicleFinalPositionX(direction);

                    trace('new spawner: pointing $direction | x: $spawnerXPos | y: $spawnerYPos');
                    if (spawnWithDebugValues) {
                        endDestinationX = tileWidth * 6;
                        var spawn:Spawner = {
                            collisionGroup: new FlxTypedGroup<Vehicle>(),
                            type: params[1],
                            direction: direction,
                            xPos: spawnerXPos,
                            yPos: spawnerYPos,
                            vehicleSpeed: 100,
                            amount: Std.parseInt(params[4]),
                            timeUntilNextSpawn: 0,
                            delayBetweenSpawns: 0.05,
                            assetPath: "assets/images/Car.png",
                            destinations: [
                                new FlxPoint(endDestinationX, spawnerYPos),
                                new FlxPoint(endDestinationX, spawnerYPos - (tileHeight * 3))
                            ]
                        }
                        spawners.push(spawn);
                    } else {
                        var spawn:Spawner = {
                            collisionGroup: new FlxTypedGroup<Vehicle>(),
                            type: params[1],
                            direction: direction,
                            xPos: spawnerXPos,
                            yPos: spawnerYPos,
                            vehicleSpeed: FlxG.random.float(25, 350),
                            amount: Std.parseInt(params[4]),
                            timeUntilNextSpawn: 0,
                            delayBetweenSpawns: FlxG.random.float(0.05, 5),
                            assetPath: "assets/images/Car.png",
                            destinations: [new FlxPoint(endDestinationX, spawnerYPos)]
                        }
                        spawners.push(spawn);
                    }
            }
        }
        traffic = new TrafficControl(spawners, carGroup);
        add(objectGroup);
        return true;
    }

    function onPlayerOverlapsCar(player:Player, car:FlxSprite) {
        trace('overlap car, was it fatal?');
        if (!player.wasHit) {
            player.wasHit = car.overlapsPoint(player.getMidpoint());
            if (player.wasHit) {
                trace('yes, car hit!');
                FlxG.camera.shake(0.05, 0.1);
                player.originX = playerStartX;
                player.originY = playerStartY;
                player.resetPosition();
                player.wasHit = false;
            }
        }
    }

    function determineSpawnerX(direction:String):Int {
        // if moving right the Spawner should be off screen to the left, otherwise off screen to the right
        if (direction == "RIGHT") {
            return offScreenLeft;
        }
        return offScreenRight;
    }

    function determineVehicleFinalPositionX(direction:String):Int {
        // if moving right the Vehicle wants to end off screen to the right, otherwise off screen to the left
        if (direction == "RIGHT") {
            return offScreenRight + tileWidth;
        }
        return offScreenLeft - tileWidth;
    }
}
