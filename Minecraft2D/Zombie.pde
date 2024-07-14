public class Zombie extends Mob {
    boolean isMoving;

    public Zombie(float x, float y) {
        super(x, y, settings.zombieSpeedFactor);
        isMoving = false;
        c = color(102, 0, 0);
    }

    void update() {
        float xPrevious = coords.x;
        float yPrevious = coords.y;
        
        coords.x += direction.x * speedFactor;
        coords.y += direction.y * speedFactor;
        
        revertStepIfWalkedIntoWallOrWater(xPrevious, yPrevious);
        revertStepIfWalkedIntoMob(xPrevious, yPrevious);
        
        determineDirection();
    }
    
    void revertStepIfWalkedIntoWallOrWater(float xPrevious, float yPrevious) {
        float xCollide = coords.x;
        float yCollide = coords.y;
        
        if (isCollidingWithWallOrWater()) {
            coords.x = xPrevious;
            coords.y = yPrevious;
        }
        
        coords.x = xCollide;
        if (isCollidingWithWallOrWater()) {
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
    
    void determineDirection() {
        direction = state.player.coords.copy();
        direction.sub(this.coords);
        direction.normalize();
    }
}
