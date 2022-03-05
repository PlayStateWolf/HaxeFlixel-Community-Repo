package entities;

import flixel.FlxSprite;
import flixel.math.FlxMath;

class Entity extends FlxSprite {
    public var originX:Float;
    public var originY:Float;
    public var targetX:Float;
    public var targetY:Float;

    var currentLerp:Float;

    public var canMove:Bool;

    public var lerpSpeed:Float;

    public function new(startX:Int, startY:Int) {
        super(startX, startY);
        targetX = startX;
        targetY = startY;
    }

    override function update(elapsed) {
        if (x == targetX && y == targetY) {
            canMove = true;
            currentLerp = 0;
            originX = x;
            originY = y;
        } else if (!canMove) {
            currentLerp += lerpSpeed;
            x = FlxMath.lerp(originX, targetX, currentLerp);
            y = FlxMath.lerp(originY, targetY, currentLerp);
        }
        /*if (x == targetX && y == targetY) {
                canMove = true;
                currentLerp = 0;
                originX = x;
                originY = y;
            } else {
                currentLerp += lerpSpeed;
                x = FlxMath.lerp(originX, targetX, currentLerp);
                y = FlxMath.lerp(originY, targetY, currentLerp);
        }*/
    }

    public function moveToPos(newX:Float, newY:Float, speed:Float) {
        if (canMove) {
            canMove = false;
            originX = x;
            originY = y;
            targetX = newX;
            targetY = newY;
            currentLerp = 0;
            lerpSpeed = speed;
        }
    }

    public function resetPosition():Void {
        x = originX;
        y = originY;
        targetX = originX;
        targetY = originY;
        canMove = true;
    }
}
