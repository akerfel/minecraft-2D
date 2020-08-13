// Movement code mostly taken from http://studio.processingtogether.com/sp/pad/export/ro.91tcpPtI9LrXp

public class Player {
    PVector coords;
    int reach;
    float speed;
    boolean isRunning;
    boolean isRunningLikeUsainBolt;
    float runningFactor;    // 1.5 gives 50% speed increase when running
    float usainBoltRunningFactor;    // 1.5 gives 50% speed increase when running
    boolean isLeft, isRight, isUp, isDown;
    int hotbarIndexSelected;
    ItemSlot[] hotbar;
    
    public Player(float x, float y) {
        coords = new PVector(x, y);
        speed = 0.1;
        reach = 7;
        isRunning = false;
        isRunningLikeUsainBolt = false;
        runningFactor = 1.5;
        usainBoltRunningFactor = 200;
        hotbarIndexSelected = 0;
        hotbar = new ItemSlot[9];
        setHotbarEmpty();
    }
    
    Item getHeldItem() {
        return hotbar[hotbarIndexSelected].item;
    }
    
    public boolean isHoldingTool() {
        return getHeldItem() instanceof Tool;
    }
    
    void addItemToInventory(Item item) {
        if (item.type.equals("block")) {
            addBlockToInventory((Block) item);
        }
        if (item.type.equals("tool")) {
            addToolToInventory((Tool) item);    
        }
    }
    
    void addToolToInventory(Tool tool) {
        for (int i = 0; i < 9; i++) {
            if (hotbar[i].amount == 0) {
                hotbar[i].item = tool;
                hotbar[i].amount = 1;
                break;
            }
        }
    }
    
    void addBlockToInventory(Block block) {
        boolean foundInInventory = tryAddBlockToExistingStack(block);
        if (!foundInInventory) {
            putBlockInEmptyCell(block);
        }
    }
    
    private boolean tryAddBlockToExistingStack(Block block) {
        boolean foundInInventory = false;
        for (int i = 0; i < 9; i++) {
            if (hotbar[i].toString().equals(block.toString()) && hotbar[i].amount < 64) {
                hotbar[i].incrementItemAmount();
                foundInInventory = true;
                break;
            }
        }
        return foundInInventory;
    }
    
    private void putBlockInEmptyCell(Block block) {
        for (int i = 0; i < 9; i++) {
                if (hotbar[i].amount == 0) {
                    hotbar[i].item = block;
                    hotbar[i].amount = 1;
                    break;
                }
            }     
    }
    
    void setHotbarEmpty() {
        for (int i = 0; i < 9; i++) {
            hotbar[i] = new ItemSlot();
        }
    }
    
    void move() {
        float v = speed;
        if (isRunning) {
            v *= runningFactor; 
        }
        if (isRunningLikeUsainBolt) {
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
