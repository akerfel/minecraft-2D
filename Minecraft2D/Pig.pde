public class Pig extends Mob {
    boolean isMoving;
    float chanceStartMoving;    // chance each frame when standing still
    float chanceStopMoving;     // chance each frame when 

    public Pig(float x, float y) {
        super(x, y, settings.pigBaseSpeed, settings.pigWidthInBlocks, settings.pigColor);
        isMoving = false;
        chanceStartMoving = 0.006;
        chanceStopMoving = 0.006;
        c = color(255, 192, 203);
    }
    
    void determineDirection() {
        if (isMoving) {
            maybeStopMoving();
            if (random(0, 1) < 0.7) {
                direction.x += random(-0.25, 0.25);
            }
            if (random(0, 1) < 0.7) {
                direction.y += random(-0.25, 0.25);
            }
        } else {
            maybeStartMoving();
        }
        
        direction.normalize();
    }

    void maybeStopMoving() {
        if (random(0, 1) < chanceStopMoving) {
            direction = new PVector(0, 0);
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
        direction = new PVector(random(-1, 1), random(-1, 1)).normalize();
    }
}
