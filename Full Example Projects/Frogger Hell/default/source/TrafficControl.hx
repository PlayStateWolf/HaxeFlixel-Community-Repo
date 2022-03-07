package;

import entities.Vehicle;
import flixel.group.FlxGroup;

class TrafficControl {
    var vehicleRenderGroup:FlxGroup;
    var spawners:Array<Spawner>;

    public function new(spawners:Array<Spawner>, vehicleRenderGroup:FlxGroup) {
        this.spawners = spawners;
        this.vehicleRenderGroup = vehicleRenderGroup;
        for (spawner in spawners) {
            // initialise vehicles (they are not moving to start)
            for (i in 0...spawner.amount) {
                spawn(spawner);
            }
        }
    }

    public function update(elapsed:Float) {
        // update each spawner
        for (spawner in spawners) {
            var shouldResetCountDown = false;
            // count down by elapsed time
            spawner.timeUntilNextSpawn -= elapsed;

            // spawn if count down finished
            if (spawner.timeUntilNextSpawn <= 0) {
                for (vehicle in spawner.collisionGroup) {
                    if (shouldResetCountDown) {
                        spawner.timeUntilNextSpawn = spawner.delayBetweenSpawns;
                        break;
                        // trace('reset spawn count down : $spawner');
                    }

                    if (vehicle.isWaiting) {
                        // got a waiting vehicle
                        if (!overlapsMovingVehicle(vehicle, spawner.collisionGroup)) {
                            // can start vehicle if it does not overlap a moving one
                            vehicle.start();
                            shouldResetCountDown = true;
                        }
                        // trace('started vehicle at ${vehicle.getPosition()}');
                    }
                }
            }
        }
    }

    function overlapsMovingVehicle(vehicle:Vehicle, collisionGroup:FlxTypedGroup<Vehicle>):Bool {
        for (collidableVehicle in collisionGroup) {
            var isComparingIdenticalVehicles = vehicle.ID == collidableVehicle.ID;
            if (!isComparingIdenticalVehicles) {
                if (collidableVehicle.isMoving() && collidableVehicle.overlaps(vehicle)) {
                    return true;
                }
            }
        }
        return false;
    }

    function spawn(spawner:Spawner) {
        var vehicleVelocity = spawner.vehicleSpeed;
        if (spawner.direction == "LEFT") {
            // if moving left, reverse the veleocity
            vehicleVelocity *= -1;
        }
        var vehicle = new Vehicle(spawner.xPos, spawner.yPos, vehicleVelocity, spawner.assetPath);
        vehicleRenderGroup.add(vehicle);
        spawner.collisionGroup.add(vehicle);
    }
}

typedef Spawner = {
    var collisionGroup:FlxTypedGroup<Vehicle>;
    var type:String;
    var direction:String;
    var xPos:Int;
    var yPos:Int;
    var vehicleSpeed:Float;
    var amount:Int;
    var timeUntilNextSpawn:Float;
    var delayBetweenSpawns:Float;
    var assetPath:String;
}
