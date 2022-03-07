package entities;

import PlayState.tileHeight;
import PlayState.tileWidth;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets;

class Vehicle extends FlxSprite {
    var originX:Int;
    var originY:Int;
    var originVelocity:Float;
    var destinations:Array<FlxPoint>;

    public function new(startX:Int, startY:Int, startVelocity:Float, ?asset:FlxGraphicAsset, destinations:Array<FlxPoint>) {
        super(startX, startY, asset);
        originX = startX;
        originY = startY;
        originVelocity = startVelocity;
        this.destinations = destinations;
        destinationIndex = 0;
        isWaiting = true;
    }

    public function resetToOrigin():Void {
        x = originX;
        y = originY;
        velocity.x = 0;
        velocity.y = 0;
        isWaiting = true;
        destinationIndex = 0;
    }

    public var isWaiting:Bool;

    public function start() {
        startMovingToDestination();
        isWaiting = false;
    }

    public inline function isMoving():Bool {
        return velocity.x != 0 || velocity.y != 0;
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (isMoving()) {
            var destinationStatus = getDestinationStatus();
            if (destinationStatus.reachedX) {
                // stop moving on x axis
                velocity.x = 0;
                // clamp to grid
                x = roundToNearest(x, tileWidth);
            }
            if (destinationStatus.reachedY) {
                // stop moving on y axis
                velocity.y = 0;
                // clamp to grid
                y = roundToNearest(y, tileHeight);
            }

            if (destinationStatus.reachedX && destinationStatus.reachedY)
            {
                changeDestination();
            }
        }
    }

    function startMovingToDestination() {
        // if velocity x needs to change
        if (this.x != destinations[destinationIndex].x) {
            var willMoveTowardsRight = destinations[destinationIndex].x > x;
            var xDirection = willMoveTowardsRight ? 1 : -1;
            velocity.x = xDirection * originVelocity;
            // flipX if direction is towards left
            flipX = xDirection < 0;
        }

        // if velocity y needs to change
        if (this.y != destinations[destinationIndex].y) {
            var willMoveTowardsBottom = destinations[destinationIndex].y > y;
            var yDirection = willMoveTowardsBottom ? 1 : -1;
            velocity.y = yDirection * originVelocity;
        }
    }

    function centerX():Float {
        return this.x + (width * 0.5); 
    }

    function centerY():Float {
        return this.y + (height * 0.5);
    }

    function roundToNearest(value:Float, interval:Int):Int {
        return Math.round(value / interval) * interval;
    }

    function getDestinationStatus():{reachedX:Bool, reachedY:Bool} {
        var reachedDestinationX = x == destinations[destinationIndex].x;
        var reachedDestinationY = y == destinations[destinationIndex].y;

        if (!reachedDestinationX){
            // if moving left
            if (velocity.x < 0){
                reachedDestinationX = x <= destinations[destinationIndex].x;
            }
            // if moving right
            else{
                reachedDestinationX = x >= destinations[destinationIndex].x;
            }
        }

        if(!reachedDestinationY){
            // if moving up
            if (velocity.y < 0){
                reachedDestinationY = y <= destinations[destinationIndex].y;
            }
            // if moving down
            else{
                reachedDestinationY = y >= destinations[destinationIndex].y;
            }
        }
        
        return {
            reachedX: reachedDestinationX,
            reachedY: reachedDestinationY
        }
    }

    var destinationIndex:Int;

    function changeDestination() {
        destinationIndex++;
        // reset if reached final destination
        if (destinationIndex > destinations.length - 1) {
            resetToOrigin();
        } else {
            startMovingToDestination();
        }
    }


}
