public class Pig extends Mob {
    boolean isMoving;
    float chanceStartMoving;    // chance each frame when standing still
    float chanceStopMoving;     // chance each frame when moving

    public Pig(float x, float y) {
        super(x, y, settings.pigSpeedFactor);
        isMoving = false;
        chanceStartMoving = 0.01;
        chanceStopMoving = 0.01;
        c = color(255, 192, 203);
    }

    void update() {
        if (isMoving) {
            maybeStopMoving();
            float xPrevious = coords.x;
            float yPrevious = coords.y;
            // Change coords
            coords.x += direction.x * speedFactor;
            coords.y += direction.y * speedFactor;
            slightlyShiftDirection();

            float mobWidthInBlocks = settings.mobWidth / settings.pixelsPerBlock; // How much the state.player width is in blocks (ex 0.5 blocks)
            if (getBlock(int(coords.x), int(coords.y)).isWallOrWater()
                || getBlock(int(coords.x + mobWidthInBlocks), int(coords.y)).isWallOrWater()
                || getBlock(int(coords.x), int(coords.y + mobWidthInBlocks)).isWallOrWater()
                || getBlock(int(coords.x + mobWidthInBlocks), int(coords.y + mobWidthInBlocks)).isWallOrWater())
            {
                coords.x = xPrevious;
                coords.y = yPrevious;
                direction.x *= -1;
                direction.y *= -1;
            }
        } else {
            maybeStartMoving();
        }
    }

    void slightlyShiftDirection() {
        if (random(0, 1) < 0.7) {
            direction.x += random(-0.15, 0.15);
        }
        if (random(0, 1) < 0.7) {
            direction.y += random(-0.15, 0.15);
        }
        direction.x = constrain(direction.x, -1, 1);
        direction.y = constrain(direction.y, -1, 1);
    }

    void maybeStopMoving() {
        if (random(0, 1) < chanceStopMoving) {
            isMoving = false;
        }
    }
    
    void maybeStartMoving() {
        if (random(0, 1) < chanceStartMoving) {
            startMovingSequence();
        }
    }

    void startMovingSequence() {
        isMoving = true;
        direction = new PVector(random(-1, 1), random(-1, 1));
    }
}
