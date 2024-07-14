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
        
        revertStepIfWalkedIntoWall(xPrevious, yPrevious);
        revertStepIfWalkedIntoMob(xPrevious, yPrevious);
        
        determineDirection();
    }
    
    void determineDirection() {
        direction = state.player.coords.copy();
        direction.sub(this.coords);
        direction.normalize();
    }
}
