public class Player {
    Inventory inventory;
    PVector coords;
    int reach;
    float speed;
    boolean isRunning;
    boolean isRunningSuperSpeed;
    float runningFactor;                    // 1.5 gives 50% speed increase when running
    float superSpeedFactor;
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
        if (getPlayerBlock().name.equals("water")) {
            v *= 0.5;
        }

        // Save previous coords
        float xPrevious = coords.x;
        float yPrevious = coords.y;

        // Change coords
        coords.x += v*(int(state.D_IsPressed) - int(state.A_isPressed));
        coords.y += v*(int(state.S_isPressed)  - int(state.W_isPressed));
        // If new coords are inside wall, go back to old coords
        float playerWidthInBlocks = settings.playerWidth / settings.pixelsPerBlock; // How much the state.player width is in blocks (ex 0.5 blocks)

        if (!cheats.canWalkThroughWalls
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
            state.W_isPressed = bool;
            return;

        case 'S':
        case DOWN:
            state.S_isPressed = bool;
            return;

        case 'A':
        case LEFT:
            state.A_isPressed = bool;
            return;

        case 'D':
        case RIGHT:
            state.D_IsPressed = bool;
            return;

        default:
            return;
        }
    }
}
