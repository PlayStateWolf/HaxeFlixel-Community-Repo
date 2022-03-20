package entities;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets;
import flixel.util.FlxPath;

class Vehicle extends FlxSprite {
    var originX:Int;
    var originY:Int;
    var originVelocity:Float;

    public var isWaiting:Bool;

    public function new(startX:Int, startY:Int, startVelocity:Float, asset:FlxGraphicAsset, destinations:Array<FlxPoint>) {
        super(startX, startY);
        loadGraphic(asset, true, 32, 32);
        originX = startX;
        originY = startY;
        originVelocity = startVelocity;
        isWaiting = true;
        this.path = new FlxPath(destinations);
        this.path.onComplete = path -> this.resetToOrigin();
    }

    public function resetToOrigin():Void {
        x = originX;
        y = originY;
        velocity.x = 0;
        velocity.y = 0;
        isWaiting = true;
    }

    public function start() {
        startMovingToDestination();
        isWaiting = false;
    }

    public inline function isMoving():Bool {
        return velocity.x != 0 || velocity.y != 0;
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        var direction = {
            x: velocityToDirection(velocity.x),
            y: velocityToDirection(velocity.y)
        };

        this.animation.frameIndex = switch direction {
            case {x: 0, y: -1}: 0; // up
            case {x: 0, y: 1}: 1; // down
            case {x: -1, y: 0}: 3; // left
            case _: 2; // default (right)
        };
    }

    inline function velocityToDirection(vel:Float):Int {
        return vel == 0 ? 0 : vel < 0 ? -1 : 1;
    }

    function startMovingToDestination() {
        final autoRotate = false;
        path.start(originVelocity, autoRotate);
    }
}
