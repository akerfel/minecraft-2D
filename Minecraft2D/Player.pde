public class Player {
    PVector coords;
    float playerSpeed;
    boolean movingDown;
    boolean movingUp;
    boolean movingRight;
    boolean movingLeft;
    
    public Player(float x, float y) {
        coords = new PVector(x, y);
        playerSpeed = 0.3;
        movingDown = false;
        movingUp = false;
        movingRight = false;
        movingLeft = false;
    }
    
    void updatePosition() {
        if (movingDown) {
            coords.y += playerSpeed;    
        }
        if (movingUp) {
            coords.y -= playerSpeed;    
        }
        if (movingRight) {
            coords.x += playerSpeed;    
        }
        if (movingLeft) {
            coords.x -= playerSpeed;    
        }
    }
}
