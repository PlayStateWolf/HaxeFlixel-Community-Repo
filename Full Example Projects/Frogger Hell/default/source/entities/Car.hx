package entities;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;

class Car extends Entity {
    var type:String;
    var direction:String;
    var delay:Int;

    public function new(startX:Int, t:String, d:String, startY:Int) {
        super(startX, startY);
        type = t;
        direction = d;
        loadGraphic("assets/images/Car.png");
        canMove = true;
        if (direction == "RIGHT") {
            targetX = PlayState.level.width;
            targetY = y;
            moveToPos(targetX, y, 0.005);
        } else if (direction == "LEFT") {
            targetX = -PlayState.tileWidth;
            targetY = y;
            flipX = true;
            moveToPos(targetX, y, 0.005);
        }

        currentLerp = Math.random();
    }

    override function update(elapsed) {
        if (delay > 0) {
            delay--;
            currentLerp = 0;
        }
        if (currentLerp == 1)
            resetPosition();

        super.update(elapsed);
        // carOverlap();
    }

    override public function resetPosition():Void {
        delay = Std.random(PlayState.tileWidth * 6);
        currentLerp = 0;
    }
    /*public function carOverlap():Bool {
        var isSeperate:Bool = false;
        for (object in PlayState.carGroup) {
            var car = cast(object, Car);
            if (this.overlaps(car) && car != this) {
                isSeperate = false;
                FlxObject.separate(car, this);
                if (carOverlap())
                    isSeperate = true;
            }
        }
        return isSeperate;
    }*/
}
