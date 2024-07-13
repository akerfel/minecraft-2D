public class Zombie extends Mob {
    boolean isMoving;

    public Zombie(float x, float y) {
        super(x, y, settings.zombieSpeedFactor);
        isMoving = false;
        c = color(37, 87, 49);
    }

    void update() {
        float xPrevious = coords.x;
        float yPrevious = coords.y;
        
        coords.x += direction.x * speedFactor;
        coords.y += direction.y * speedFactor;
        
        revertStepIfWalkedIntoWallOrWater(xPrevious, yPrevious);
        
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
        if (!isCollidingWithWallOrWater()) {
            return; // Collided with wall because of movement in y direction
        }
        coords.x = xPrevious;
        
        coords.y = yCollide;
        if (!isCollidingWithWallOrWater()) {
            return; // Collided with wall because of movement in x direction
        }
        coords.y = yPrevious;
    }
    
    void determineDirection() {
        direction = state.player.coords.copy();
        direction.sub(this.coords);
        direction.x = constrain(direction.x, -1, 1);
        direction.y = constrain(direction.y, -1, 1);
    }
}
