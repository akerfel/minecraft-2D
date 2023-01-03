public class Mob {
    public PVector coords;
    PVector direction;          // Both x and y are always between -1 and 1
    float speedFactor;
    boolean isMoving;
    float chanceStartMoving;    // chance each frame when standing still
    float chanceStopMoving;     // chance each frame when moving
    public color c;

    public Mob(float x, float y) {
        coords = new PVector(x, y);
        direction = new PVector(0, 0);
        speedFactor = 0.1;
        isMoving = false;
        chanceStartMoving = 0.01;
        chanceStopMoving = 0.01;
        c = color(255, 192, 203);
    }

    void update() {
        if (isMoving) {
            float xPrevious = coords.x;
            float yPrevious = coords.y;
            // Change coords
            coords.x += direction.x * speedFactor;
            coords.y += direction.y * speedFactor;
            slightlyShiftDirection();
            maybeStopMoving();

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
            if (random(0, 1) < chanceStartMoving) {
                startMovingSequence();
            }
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

    void startMovingSequence() {
        isMoving = true;
        direction = new PVector(random(-1, 1), random(-1, 1));
    }
}
