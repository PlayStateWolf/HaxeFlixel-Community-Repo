package;

import entities.Vehicle;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;

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
            // count down by elapsed time
            spawner.timeUntilNextSpawn -= elapsed;

            // when count down finished, find a vehicle that is waiting and start it
            if (spawner.timeUntilNextSpawn <= 0) {
                // loop over all vehicles belonging to spawner
                for (vehicle in spawner.collisionGroup) {
                    // find a vehicle that is waiting
                    if (vehicle.isWaiting) {
                        // if vehicle does not overlap a moving one it can start
                        if (!overlapsMovingVehicle(vehicle, spawner.collisionGroup)) {
                            vehicle.start();
                            // trace('started vehicle at ${vehicle.getPosition()}');

                            // a vehicle was started so reset the count down
                            spawner.timeUntilNextSpawn = spawner.delayBetweenSpawns;

                            // break out of the loop so that only first waiting vehicle is started
                            break;
                        }
                    }
                }
            }
        }
    }

    function overlapsMovingVehicle(vehicle:Vehicle, collisionGroup:FlxTypedGroup<Vehicle>):Bool {
        for (collidableVehicle in collisionGroup) {
            var vehiclesAreTheSameInstance = vehicle.ID == collidableVehicle.ID;
            if (!vehiclesAreTheSameInstance) {
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
        var vehicle = new Vehicle(spawner.xPos, spawner.yPos, vehicleVelocity, spawner.assetPath, spawner.destinations);
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
    var destinations:Array<FlxPoint>;
}
