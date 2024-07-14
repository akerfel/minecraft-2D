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

    abstract void update();
    
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
