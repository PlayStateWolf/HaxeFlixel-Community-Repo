package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;

class Car extends Entity {
    var type:String;
    var direction:String;

    public function new(startX:Int, t:String, d:String, startY:Int) {
        super(startX, startY);
        type = t;
        direction = d;
        y = startY;
        loadGraphic("assets/images/Car.png");
        flipX = true;
        canMove = true;
        if (direction == "RIGHT") {
            targetX = PlayState.level.width;
            targetY = y;
        } else {
            targetX = PlayState.level.width;
            targetY = y;
        }
        // moveToPos(targetX, targetY, 0.2);
    }

    override function update(elapsed) {
        super.update(elapsed);
        if (x == targetX && y == targetY)
            resetPosition();
        /*if (direction == "RIGHT") {
                if (x > PlayState.level.width) {
                    x = -PlayState.tileWidth;
                }
                velocity.x = 8;
            } else {
                if (x > PlayState.level.width) {
                    x = -PlayState.tileWidth;
                }
                velocity.x = -8;
        }*/
    }
}
