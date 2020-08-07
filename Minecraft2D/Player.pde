// Movement code mostly taken from http://studio.processingtogether.com/sp/pad/export/ro.91tcpPtI9LrXp

public class Player {
    PVector coords;
    float speed;
    boolean isRunning;
    boolean isRunningLikeUsainBolt;
    float runningFactor;    // 1.5 gives 50% speed increase when running
    float usainBoltRunningFactor;    // 1.5 gives 50% speed increase when running
    boolean isLeft, isRight, isUp, isDown;
    int hotbarCellSelected;
    HotbarCell[] hotbar;
    int reach;
   
    
    public Player(float x, float y) {
        coords = new PVector(x, y);
        speed = 0.07;
        isRunning = false;
        isRunningLikeUsainBolt = false;
        runningFactor = 1.5;
        usainBoltRunningFactor = 20;
        hotbarCellSelected = 0;
        hotbar = new HotbarCell[9];
        setHotbarEmpty();
        reach = 7;
    }
    
    void addBlockToInventory(Block block) {
        boolean foundInInventory = false;
        for (int i = 0; i < 9; i++) {
            if (hotbar[i].toString().equals(block.toString()) && hotbar[i].amount != 64) {
                hotbar[i].incrementItemAmount();
                foundInInventory = true;
                break;
            }
        }
        if (!foundInInventory) {
            for (int i = 0; i < 9; i++) {
                if (hotbar[i].amount == 0) {
                    hotbar[i].block = block;
                    hotbar[i].amount = 1;
                    break;
                }
            }  
        }
    }
    
    void setHotbarEmpty() {
        for (int i = 0; i < 9; i++) {
            hotbar[i] = new HotbarCell();
        }
    }
    
    void move() {
        // 
        float v = speed;
        if (isRunning) {
            v *= runningFactor; 
        }
        if (isRunningLikeUsainBolt) {
            v *= usainBoltRunningFactor;
        }
        
        // Save previous coords
        float xPrevious = coords.x;
        float yPrevious = coords.y;
        
        // Change coords
        coords.x += v*(int(isRight) - int(isLeft));
        coords.y += v*(int(isDown)  - int(isUp));
        // If new coords are inside wall, go back to old coords
        float playerWidthInBlocks = playerWidth / pixelsPerBlock; // How much the player width is in blocks (ex 0.5 blocks)
        
        if (getBlock(coords.x, coords.y).isWall 
            || getBlock(coords.x + playerWidthInBlocks, coords.y).isWall 
            || getBlock(coords.x, coords.y + playerWidthInBlocks).isWall 
            || getBlock(coords.x + playerWidthInBlocks, coords.y + playerWidthInBlocks).isWall)
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
