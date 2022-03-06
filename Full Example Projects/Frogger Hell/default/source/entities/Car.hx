package entities;

import flixel.FlxBasic;
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
    var distance:Float;
    var distanceX:Float;
    var distanceY:Float;
    var speed:Float;

    // var blocked:Bool;

    public function new(startX:Int, t:String, d:String, startY:Int, startSpeed:Float) {
        super(startX, startY);
        type = t;
        direction = d;
        loadGraphic("assets/images/Car.png");
        canMove = true;
        speed = startSpeed;
        distanceX = targetX - originX;
        distanceY = targetY - originY;
        distance = Math.sqrt(((targetX - originX) * 2 + (targetY - originY) * 2));
        trace("THIS!!" + distance);
        if (direction == "RIGHT") {
            targetX = PlayState.level.width;
            targetY = y;
            // 320
            // 1.6
            // 0.005
            // 1.6/320=0.005
            moveToPos(targetX, y, speed / distance);
        } else if (direction == "LEFT") {
            targetX = -PlayState.tileWidth;
            targetY = y;
            flipX = true;
            moveToPos(targetX, y, 0.005);
        }

        currentLerp = Math.random();
        // blocked = false;
    }

    override function update(elapsed) {
        if (delay > 0) {
            delay--;
            currentLerp = 0;
        }
        if (currentLerp == 1) {
            resetPosition();
        }

        super.update(elapsed);
        isBlocked();
        /*isBlocked();

            if (blocked) {
                lerpSpeed = 0;
            } else
                lerpSpeed = 0.005; */
    }

    override public function resetPosition():Void {
        delay = Std.random(PlayState.tileWidth * 6);
        currentLerp = 0;
    }

    public function isBlocked():Bool {
        for (object in PlayState.carGroup) {
            var car = cast(object, Car);
            if (car != this) {
                if (direction == "RIGHT") {
                    if (car.x > this.x && car.x < this.x + width && car.y == y) {
                        // blocked = true;
                        currentLerp = FlxMath.lerp(originX, targetX, car.x - width);
                        // x = FlxMath.lerp(originX, targetX, currentLerp);
                        // return a + ratio * (b - a);
                        // ratio
                        return true;
                    }
                } else if (direction == "LEFT") {
                    if (car.x < x - width && car.x < this.x + width && car.y == y) {
                        // blocked = true;
                        currentLerp = FlxMath.lerp(originX, targetX, car.x + width);
                        return true;
                    }
                }
            }
        }
        // blocked = false;
        return false;
    }
}
