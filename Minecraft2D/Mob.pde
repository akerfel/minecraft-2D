public class Mob {
    public PVector coords;
    PVector direction;          // Both x and y are always between -1 and 1
    float speed;
    boolean isMoving;
    float chanceStartMoving;    // chance each frame when standing still
    float chanceStopMoving;     // chance each frame when moving
    public color c;
   
    public Mob(float x, float y) {
        coords = new PVector(x, y);
        direction = new PVector(0, 0);
        speed = 0.01;
        isMoving = false;
        chanceStartMoving = 0.003;
        chanceStopMoving = 0.001;
        c = color(255, 192, 203);
        println("made mob at " + coords.x + ", " + coords.y);
    }
    
    void update() {
        if (isMoving) {
            coords = coords.add(direction);
            slightlyShiftDirection();
            maybeStopMoving();
            
        }
        else {
            if (random(0, 1) < chanceStartMoving) {
                startMovingSequence();
            }
        }
    }
    
    void slightlyShiftDirection() {
        if (random(0, 1) < 0.3) {
            direction.x += random(-0.01, 0.01);
        }
        if (random(0, 1) < 0.3) {
            direction.y += random(-0.01, 0.01);
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
        direction = new PVector(speed * random(-1, 1), speed * random(-1, 1));
    }
}
