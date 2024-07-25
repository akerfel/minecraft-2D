public class Player extends Body {
    Inventory inventory;
    CraftingMenu craftingMenu;
    int reach;
    boolean isRunning;
    boolean isRunningSuperSpeed;
    float runningFactor;                    // 1.5 gives 50% speed increase when running
    float superSpeedFactor;

    public Player(float x, float y) {
        super(x, y, settings.playerBaseSpeed, settings.playerWidthInBlocks, settings.playerColor);
        inventory = new Inventory();
        craftingMenu = new CraftingMenu();
        coords = new PVector(x, y);
        reach = 7;
        isRunning = false;
        isRunningSuperSpeed = false;
        runningFactor = 2;
        superSpeedFactor = 200;
    }

    public ArrayList<ItemSlot> getHandCraftableItems() {
        ArrayList<ItemSlot> craftableItems = craftingMenu.getHandCraftableItems(inventory);
        if (canReachWorkbench()) {
            craftableItems.addAll(craftingMenu.getWorkbenchCraftableItems(inventory));
        }
        return craftableItems;
    }

    public ArrayList<ItemSlot> getCraftableItems() {
        ArrayList<ItemSlot> craftableItems = craftingMenu.getHandCraftableItems(inventory);
        if (canReachWorkbench()) {
            craftableItems.addAll(craftingMenu.getWorkbenchCraftableItems(inventory));
        }
        return craftableItems;
    }

    private boolean canReachWorkbench() {
        for (int y = -settings.craftingDistance; y <= settings.craftingDistance; y++) {
            for (int x = -settings.craftingDistance; x <= settings.craftingDistance; x++) {
                Block block = state.player.getRelativeBlock(x, y);
                if (block.itemID == ItemID.WORKBENCH) {
                    return true;
                }
            }
        }
        return false;
    }

    float determineSpeed() {
        float speed = baseSpeed;
        if (isRunning) {
            speed *= runningFactor;
        }
        if (isRunningSuperSpeed) {
            speed *= superSpeedFactor;
        }
        if (state.player.getBlockStandingOn().isWater()) {
            speed *= settings.waterSlowdownFactor;
        }
        return speed;
    }

    void determineDirection() {
        int xMovement = int(state.D_IsPressed) - int(state.A_isPressed);
        int yMovement = int(state.S_isPressed) - int(state.W_isPressed);
        direction = new PVector(xMovement, yMovement).normalize();
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
    
    boolean isHoldingGun() {
        return !getSelectedItemSlot().isEmpty() && getSelectedItemSlot().item.itemType == ItemType.GUN;
    }
    
    boolean isHoldingItemWhichCanMine() {
        return hasNotSelectedAnItem() || isHoldingTool();
    }
    
    boolean isHoldingTool() {
        return !getSelectedItemSlot().isEmpty() && getSelectedItemSlot().item.itemType == ItemType.TOOL;
    }
    
    boolean hasNotSelectedAnItem() {
        return getSelectedItemSlot().isEmpty();
    }
    
    boolean selectedItemIsBlock() {
        ItemSlot slot = getSelectedItemSlot();   
        return slot.item.itemType == ItemType.BLOCK;
    }
    
    ItemSlot getSelectedItemSlot() {
        return state.player.inventory.getHotbarSlot(state.player.inventory.hotbarIndexSelected);
    }
    
    public void handleEnemyAttack() {
        for (Body body : state.bodies) {
            if (body instanceof Zombie) {
                if (getDistancesBetweenBodiesInBlocks(state.player, (Zombie) body) < settings.zombieReachInBlocks) {
                    damage(1);    
                }
            }
        }
    }
}
