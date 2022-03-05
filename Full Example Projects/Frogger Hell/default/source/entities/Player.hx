package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

class Player extends Entity {
    public function new(startX:Int, startY:Int) {
        super(startX, startY);
    }

    override function update(elapsed) {
        super.update(elapsed);
        if (Controls.cursorUp.triggered) {
            if (canMove && y >= PlayState.tileHeight) {
                this.moveToPos(x, y - PlayState.tileHeight, 0.2);
            }
        }
        if (Controls.cursorDown.triggered) {
            if (canMove && y < PlayState.level.height - PlayState.tileHeight) {
                this.moveToPos(x, y + PlayState.tileHeight, 0.2);
            }
        }
        if (Controls.cursorLeft.triggered) {
            if (canMove && x >= PlayState.tileWidth) {
                this.moveToPos(x - PlayState.tileWidth, y, 0.2);
            }
        }
        if (Controls.cursorRight.triggered) {
            if (canMove && x < PlayState.level.width - PlayState.tileWidth) {
                this.moveToPos(x + PlayState.tileWidth, y, 0.2);
            }
        }
        if (overlaps(PlayState.objectGroup, false))
            resetPosition();
    }
}
