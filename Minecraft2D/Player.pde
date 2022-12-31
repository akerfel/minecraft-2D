public class Player {
    PVector coords;
    int reach;
    float speed;
    boolean isRunning;
    boolean isRunningSuperSpeed;
    float runningFactor;                    // 1.5 gives 50% speed increase when running
    float usainBoltRunningFactor;           // 1.5 gives 50% speed increase when running
    boolean isLeft, isRight, isUp, isDown;
    
    // Inventory
    int hotbarIndexSelected;
    ItemSlot[] craftingGrid;
    ItemSlot[][] inventory;                 // The hotbar is the last row in the inventory
    ItemSlot mouseHeldItemSlot;             // An itemSlot which is held by the mouse in the inventory (e.g. when reorganizing the inventory)
    
    public Player(float x, float y) {
        coords = new PVector(x, y);
        speed = 0.1;
        reach = 7;
        isRunning = false;
        isRunningSuperSpeed = false;
        runningFactor = 1.5;
        usainBoltRunningFactor = 200;
        
        // Inventory
        hotbarIndexSelected = 0;
        craftingGrid = new ItemSlot[4];
        setCraftingGridEmpty();
        inventory = new ItemSlot[inventoryWidth][inventoryHeight];
        setInventoryEmpty();
        mouseHeldItemSlot = new ItemSlot();
    }
    
    Item getHeldItem() {
        return getHotbarSlot(hotbarIndexSelected).item;
    }
    
    public boolean isHoldingTool() {
        return getHeldItem() instanceof Tool;
    }
    
    // Add item to some empty inventory slot
    void addItemToInventory(Item item) {
        if (item.type.equals("block")) {
            addBlockToInventory((Block) item);
        }
        if (item.type.equals("tool")) {
            addToolToInventory((Tool) item);    
        }
    }
    
    // Add item to a specified inventory slot
    void addItemToInventory(Item item, int x, int y) {
        if (item.type.equals("block")) {
            addBlockToInventory((Block) item, x, y);
        }
        if (item.type.equals("tool")) {
            addToolToInventory((Tool) item, x, y);    
        }
    }
    
    // Add tool to some empty inventory slot
    void addToolToInventory(Tool tool) {
        // TODO: should also check for inventory spaces
        for (int i = 0; i < 9; i++) {
            if (getHotbarSlot(i).amount == 0) {
                getHotbarSlot(i).item = tool;
                getHotbarSlot(i).amount = 1;
                return;
            }
        }
    }
    
    // Add tool to a specified inventory slot
    void addToolToInventory(Tool tool, int x, int y) {
        inventory[x][y].item = tool;
        inventory[x][y].amount = 1;
    }
    
    // Add block to some empty inventory slot
    void addBlockToInventory(Block block) {
        // TODO: should also check for inventory spaces
        boolean foundInInventory = tryAddBlockToExistingStack(block);
        if (!foundInInventory) {
            putBlockInEmptyCell(block);
        }
    }
    
    // Add block to a specified inventory slot
    void addBlockToInventory(Block block, int x, int y) {
        if (inventory[x][y].toString().equals(block.toString()) && inventory[x][y].amount < 64) {
            inventory[x][y].incrementItemAmount();
        }
        else {
            putBlockInEmptyCell(block, x, y);
        }
    }

    private ItemSlot getHotbarSlot(int x) {
        return inventory[x][inventoryHeight - 1];
    }
    
    private boolean tryAddBlockToExistingStack(Block block) {
        // TODO: should also check for inventory spaces
        boolean foundInInventory = false;
        for (int i = 0; i < 9; i++) {
            if (getHotbarSlot(i).toString().equals(block.toString()) && getHotbarSlot(i).amount < 64) {
                getHotbarSlot(i).incrementItemAmount();
                foundInInventory = true;
                break;
            }
        }
        return foundInInventory;
    }
    
    // Put block in some empty cell
    private void putBlockInEmptyCell(Block block) {
        // TODO: should also check for inventory spaces
        for (int i = 0; i < 9; i++) {
            if (getHotbarSlot(i).amount == 0) {
                getHotbarSlot(i).item = block;
                getHotbarSlot(i).amount = 1;
                break;
            }
        }     
    }
    
    // Put block in a specified cell
    private void putBlockInEmptyCell(Block block, int x, int y) {
        if (inventory[x][y].amount == 0) {
            inventory[x][y].item = block;
            inventory[x][y].amount = 1;
        }
    }
    
    void setCraftingGridEmpty() {
        for (int i = 0; i < 4; i++) {
            craftingGrid[i] = new ItemSlot();
        }
    }
    
    void setInventoryEmpty() {
        for (int y = 0; y < inventoryHeight; y++) {
            for (int x = 0; x < inventoryWidth; x++) {
                inventory[x][y] = new ItemSlot();
            }
        }
    }
    
    void move() {
        float v = speed;
        if (isRunning) {
            v *= runningFactor; 
        }
        if (isRunningSuperSpeed) {
            v *= usainBoltRunningFactor;
        }
        if (getPlayerBlock().stringID.equals("water")) {
            v *= 0.5;
        }
        
        // Save previous coords
        float xPrevious = coords.x;
        float yPrevious = coords.y;
        
        // Change coords
        coords.x += v*(int(isRight) - int(isLeft));
        coords.y += v*(int(isDown)  - int(isUp));
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
    
    boolean setMove(final int k, final boolean b) {
        switch (k) {
            case +'W':
            case UP:
                  return isUp = b;
         
            case +'S':
            case DOWN:
                  return isDown = b;
         
            case +'A':
            case LEFT:
                  return isLeft = b;
         
            case +'D':
            case RIGHT:
                  return isRight = b;
         
            default:
                  return b;
        }
    }
}
