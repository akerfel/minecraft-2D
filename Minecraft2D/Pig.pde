public class Pig extends Mob {
    boolean isMoving;
    float chanceStartMoving;    // chance each frame when standing still
    float chanceStopMoving;     // chance each frame when 

    public Pig(float x, float y) {
        super(x, y, settings.pigSpeedFactor);
        isMoving = false;
        chanceStartMoving = 0.003;
        chanceStopMoving = 0.006;
        c = color(255, 192, 203);
    }

    void update() {
        if (isMoving) {
            move();
            maybeStopMoving();
        } else {
            maybeStartMoving();
        }
    }
    
    void move() {
        float xPrevious = coords.x;
        float yPrevious = coords.y;

        updateDirection();
        PVector positionDiff = getPositionDiff(speedFactor);
        coords.add(positionDiff);
        
        invertDirectionIfCollideWithWallOrWater(xPrevious, yPrevious);
        revertStepIfWalkedIntoMob(xPrevious, yPrevious);
    }
    
    private PVector getPositionDiff(float speed) {
        return direction.copy().mult(speed);
    }
    
    PVector updateDirection() {
        if (random(0, 1) < 0.7) {
            direction.x += random(-0.15, 0.15);
        }
        if (random(0, 1) < 0.7) {
            direction.y += random(-0.15, 0.15);
        }
        return direction.normalize();
    }

    void invertDirectionIfCollideWithWallOrWater(float xPrevious, float yPrevious) {
        if (isCollidingWithWallOrWater()) {
            coords.x = xPrevious;
            coords.y = yPrevious;
            direction.mult(-1);
        }
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
