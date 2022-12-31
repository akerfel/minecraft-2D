public class Player {
    Inventory inventory;
    PVector coords;
    int reach;
    float speed;
    boolean isRunning;
    boolean isRunningSuperSpeed;
    float runningFactor;                    // 1.5 gives 50% speed increase when running
    float superSpeedFactor;                 // 1.5 gives 50% speed increase when running
    public Player(float x, float y) {
        inventory = new Inventory();
        coords = new PVector(x, y);
        speed = 0.1;
        reach = 7;
        isRunning = false;
        isRunningSuperSpeed = false;
        runningFactor = 2;
        superSpeedFactor = 200;
    }
    
    void move() {
        float v = speed;
        if (isRunning) {
            v *= runningFactor; 
        }
        if (isRunningSuperSpeed) {
            v *= superSpeedFactor;
        }
        if (getPlayerBlock().stringID.equals("water")) {
            v *= 0.5;
        }
        
        // Save previous coords
        float xPrevious = coords.x;
        float yPrevious = coords.y;
        
        // Change coords
        coords.x += v*(int(D_IsPressed) - int(A_isPressed));
        coords.y += v*(int(S_isPressed)  - int(W_isPressed));
        // If new coords are inside wall, go back to old coords
        float playerWidthInBlocks = playerWidth / pixelsPerBlock; // How much the player width is in blocks (ex 0.5 blocks)
        
        if (!cheatWalkThroughWalls 
            && (getBlock(coords.x, coords.y).isWall 
            || getBlock(coords.x + playerWidthInBlocks, coords.y).isWall 
            || getBlock(coords.x, coords.y + playerWidthInBlocks).isWall 
            || getBlock(coords.x + playerWidthInBlocks, coords.y + playerWidthInBlocks).isWall))
            {
            coords.x = xPrevious;
            coords.y = yPrevious;
        }
    }
    
    void setMove(final int keyWhichWasPressed, final boolean bool) {
        switch (keyWhichWasPressed) {
            case 'W':
            case UP:
                  W_isPressed = bool;
                  return;
         
            case 'S':
            case DOWN:
                  S_isPressed = bool;
                  return;
         
            case 'A':
            case LEFT:
                  A_isPressed = bool;
                  return;
         
            case 'D':
            case RIGHT:
                  D_IsPressed = bool;
                  return;
         
            default:
                  return;
        }
    }
}
