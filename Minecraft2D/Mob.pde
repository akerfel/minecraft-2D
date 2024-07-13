public abstract class Mob {
    public PVector coords;
    PVector direction;          // Both x and y are always between -1 and 1
    float speedFactor;
    public color c;

    public Mob(float x, float y, float speedFactor) {
        coords = new PVector(x, y);
        this.speedFactor = speedFactor;
        direction = new PVector(0, 0);
    }

    abstract void update();
    
    public boolean isCollidingWithWallOrWater() {
        float mobWidthInBlocks = settings.mobWidth / settings.pixelsPerBlock; // How much the state.player width is in blocks (ex 0.5 blocks)
        return getBlock(int(coords.x), int(coords.y)).isWallOrWater()
            || getBlock(int(coords.x + mobWidthInBlocks), int(coords.y)).isWallOrWater()
            || getBlock(int(coords.x), int(coords.y + mobWidthInBlocks)).isWallOrWater()
            || getBlock(int(coords.x + mobWidthInBlocks), int(coords.y + mobWidthInBlocks)).isWallOrWater();
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
