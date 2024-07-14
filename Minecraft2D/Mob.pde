public abstract class Mob {
    PVector coords;
    float speedFactor;
    color c;
    boolean isMoving;
    PVector direction;

    public Mob(float x, float y, float speedFactor) {
        coords = new PVector(x, y);
        this.speedFactor = speedFactor;
        this.direction = new PVector(0, 0);
    }

    void update() {
        determineDirection();
        
        float xPrevious = coords.x;
        float yPrevious = coords.y;
        
        coords.x += direction.x * speedFactor;
        coords.y += direction.y * speedFactor;
        
        revertStepIfWalkedIntoWall(xPrevious, yPrevious);
        revertStepIfWalkedIntoMob(xPrevious, yPrevious);
        
    }
    
    abstract void determineDirection();
    
    public boolean isCollidingWithWall() {
        return squareIsCollidingWithWall(coords, settings.mobWidthInBlocks);
    }
    
    public boolean isCollidingWithWallOrWater() {
        return squareIsCollidingWithWallOrWater(coords, settings.mobWidthInBlocks);
    }
    
    public boolean isCollidingWithAnotherMob() {
        for (Mob otherMob : state.mobs) {
            if (mobsAreColliding(this, otherMob)) {
                return true;
            }
        }
        return false;
    }
    
    void revertStepIfWalkedIntoWall(float xPrevious, float yPrevious) {
        float xCollide = coords.x;
        float yCollide = coords.y;
        
        if (isCollidingWithWall()) {
            coords.x = xPrevious;
            coords.y = yPrevious;
        }
        
        coords.x = xCollide;
        if (isCollidingWithWall()) {
            coords.x = xPrevious;
        }
        else {
            return;
        }
        
        coords.y = yCollide;
        if (isCollidingWithWallOrWater()) {
            coords.y = yPrevious;
        }
    }
    
    void revertStepIfWalkedIntoMob(float xPrevious, float yPrevious) {
        float xCollide = coords.x;
        float yCollide = coords.y;
        
        if (isCollidingWithAnotherMob()) {
            coords.x = xPrevious;
            coords.y = yPrevious;
        }
        
        coords.x = xCollide;
        if (isCollidingWithAnotherMob()) {
            coords.x = xPrevious;
        }
        
        coords.y = yCollide;
        if (isCollidingWithAnotherMob()) {
            coords.y = yPrevious;
        }
    }
}
