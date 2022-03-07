package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets;

class Vehicle extends FlxSprite {
    var originX:Int;
    var originY:Int;
    var originVelocity:Float;

    public function new(startX:Int, startY:Int, startVelocity:Float, ?asset:FlxGraphicAsset) {
        super(startX, startY, asset);
        originX = startX;
        originY = startY;
        originVelocity = startVelocity;
        isWaiting = true;
        // if direction is left, flipX
        if (originVelocity < 0) {
            flipX = true;
        }
    }

    public function resetToOrigin():Void {
        x = originX;
        y = originY;
        velocity.x = 0;
        velocity.y = 0;
        isWaiting = true;
    }

    public var isWaiting:Bool;

    public function start() {
        velocity.x = originVelocity;
        isWaiting = false;
    }

    inline function isOutOfBounds():Bool {
        return x < 0 - (width * 2) || x > FlxG.width + (width * 2);
    }

    public inline function isMoving():Bool {
        return velocity.x != 0 || velocity.y != 0;
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (isMoving()) {
            if (isOutOfBounds()) {
                resetToOrigin();
            }
        }
    }
}
