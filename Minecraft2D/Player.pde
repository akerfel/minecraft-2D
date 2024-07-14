public class Player {
    Inventory inventory;
    CraftingMenu craftingMenu;
    PVector coords;
    int reach;
    float baseSpeed;
    boolean isRunning;
    boolean isRunningSuperSpeed;
    float runningFactor;                    // 1.5 gives 50% speed increase when running
    float superSpeedFactor;

    public Player(float x, float y) {
        inventory = new Inventory();
        craftingMenu = new CraftingMenu();
        coords = new PVector(x, y);
        baseSpeed = 0.1;
        reach = 7;
        isRunning = false;
        isRunningSuperSpeed = false;
        runningFactor = 2;
        superSpeedFactor = 200;
    }

    public ArrayList<ItemCount> getHandCraftableItems() {
        ArrayList<ItemCount> craftableItems = craftingMenu.getHandCraftableItems(inventory);
        if (canReachWorkbench()) {
            craftableItems.addAll(craftingMenu.getWorkbenchCraftableItems(inventory));
        }
        return craftableItems;
    }

    public ArrayList<ItemCount> getCraftalbeItems() {
        ArrayList<ItemCount> craftableItems = craftingMenu.getHandCraftableItems(inventory);
        if (canReachWorkbench()) {
            craftableItems.addAll(craftingMenu.getWorkbenchCraftableItems(inventory));
        }
        return craftableItems;
    }

    private boolean canReachWorkbench() {
        for (int y = -settings.craftingDistance; y <= settings.craftingDistance; y++) {
            for (int x = -settings.craftingDistance; x <= settings.craftingDistance; x++) {
                Block block = getBlockRelativeToPlayer(x, y);
                if (block.itemID == ItemID.WORKBENCH) {
                    return true;
                }
            }
        }
        return false;
    }


    void move() {
        float xPrevious = coords.x;
        float yPrevious = coords.y;

        float speed = determineSpeed();
        coords.add(getPositionDiff(speed));

        if (!cheats.canWalkThroughWalls) {
            revertStepIfWalkedIntoWall(xPrevious, yPrevious);
        }
    }

    private float determineSpeed() {
        float speed = baseSpeed;
        if (isRunning) {
            speed *= runningFactor;
        }
        if (isRunningSuperSpeed) {
            speed *= superSpeedFactor;
        }
        if (getPlayerBlock().itemID == ItemID.WATER) {
            speed *= 0.5;
        }
        return speed;
    }

    private PVector getPositionDiff(float speed) {
        return getDirection().mult(speed);
    }
    
    private PVector getDirection() {
        int xMovement = int(state.D_IsPressed) - int(state.A_isPressed);
        int yMovement = int(state.S_isPressed) - int(state.W_isPressed);
        return new PVector(xMovement, yMovement).normalize();
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

        coords.y = yCollide;
        if (isCollidingWithWall()) {
            coords.y = yPrevious;
        }
    }

    boolean isCollidingWithWall() {
        return squareIsCollidingWithWall(coords, settings.playerWidthInBlocks);
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
