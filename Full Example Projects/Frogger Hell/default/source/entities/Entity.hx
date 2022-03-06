package entities;

import flixel.FlxSprite;
import flixel.math.FlxMath;

class Entity extends FlxSprite {
    public var originX:Float;
    public var originY:Float;
    public var targetX:Float;
    public var targetY:Float;

    public var currentLerp:Float;

    public var canMove:Bool;

    public var lerpSpeed:Float;

    public function new(startX:Int, startY:Int) {
        super(startX, startY);
        originX = startX;
        originY = startY;
        targetX = startX;
        targetY = startY;
        currentLerp = 0;
        canMove = true;
        lerpSpeed = 0;
    }

    override function update(elapsed) {
        if (x == targetX && y == targetY) {
            canMove = true;
            currentLerp = 0;
            originX = x;
            originY = y;
        } else if (!canMove) {
            currentLerp += lerpSpeed;
            // trace(FlxMath.lerp(originX, targetX, currentLerp) - x);
            // trace(targetX);
            x = FlxMath.lerp(originX, targetX, currentLerp);
            y = FlxMath.lerp(originY, targetY, currentLerp);
        }

        if (currentLerp > 1)
            currentLerp = 1;
    }

    public function moveToPos(newX:Float, newY:Float, sp:Float) {
        if (canMove) {
            canMove = false;
            originX = x;
            originY = y;
            targetX = newX;
            targetY = newY;
            currentLerp = 0;
            lerpSpeed = sp;
        }
    }

    public function resetPosition():Void {
        x = originX;
        y = originY;
        canMove = true;
    }
}
