public class Inventory {
    int hotbarIndexSelected;                // The currently selected hotbar index
    ItemSlot[][] grid;                      // The hotbar is the last row in the grid
    ItemSlot mouseHeldItemSlot;             // An itemSlot which is held by the mouse in the inventory (e.g. when reorganizing the inventory)
    ArrayList<Item> craftableItems;
    int grabbedXindex;                      // the x index of the grid from which the mouse grabbed an item from
    int grabbedYindex;

    public Inventory() {
        hotbarIndexSelected = 0;
        grid = new ItemSlot[settings.inventoryWidth][settings.inventoryHeight];
        setInventoryEmpty();
        mouseHeldItemSlot = new ItemSlot();
        craftableItems = new ArrayList<>();
    }

    public Item getHeldItem() {
        return getHotbarSlot(hotbarIndexSelected).item;
    }

    public boolean isHoldingTool() {
        return getHeldItem() instanceof Tool;
    }

    public void returnMouseGrabbedItemToInventory() {
        if (mouseHeldItemSlot.amount > 0) {
            grid[grabbedXindex][grabbedYindex] = mouseHeldItemSlot;
            mouseHeldItemSlot = new ItemSlot();
        }
        updateCraftableItems();
    }

    private ItemSlot getHotbarSlot(int x) {
        return grid[x][settings.inventoryHeight - 1];
    }

    // Returns true if found in inventory (and added to that stack)
    private boolean tryAddBlockToExistingStack(Block block) {
        for (int y = settings.inventoryHeight - 1; y > -1; y--) {
            for (int x = 0; x < settings.inventoryWidth; x++) {
                if (grid[x][y].toString().equals(block.toString()) && grid[x][y].amount < 64) {
                    grid[x][y].incrementItemAmount();
                    updateCraftableItems();
                    return true;
                }
            }
        }
        return false;
    }

    // Put block in some empty cell
    private void putBlockInEmptyCell(Block block) {
        // TODO: should also check for inventory spaces
        for (int y = settings.inventoryHeight - 1; y > -1; y--) {
            for (int x = 0; x < settings.inventoryWidth; x++) {
                if (grid[x][y].amount == 0) {
                    grid[x][y].item = block;
                    grid[x][y].amount = 1;
                    return;
                }
            }
        }
        updateCraftableItems();
    }

    // Put block in a specified cell
    private void putBlockInEmptyCell(Block block, int x, int y) {
        if (grid[x][y].amount == 0) {
            grid[x][y].item = block;
            grid[x][y].amount = 1;
        }
        updateCraftableItems();
    }

    private void setInventoryEmpty() {
        for (int y = 0; y < settings.inventoryHeight; y++) {
            for (int x = 0; x < settings.inventoryWidth; x++) {
                grid[x][y] = new ItemSlot();
            }
        }
        updateCraftableItems();
    }
    
    public boolean hasItem(Item item, int count) {
        int actualCount = 0;
        for (int y = 0; y < settings.inventoryHeight; y++) {
            for (int x = 0; x < settings.inventoryWidth; x++) {
                if (grid[x][y].toString().equals(item.toString())) {
                    actualCount += grid[x][y].amount;
                    if (actualCount >= count) {
                        return true;    
                    }
                }
            }
        }
        return false;
    }
    
    private void addBlock(Block block, int amount) {
        for (int i = 0; i < amount; i++) {
            addBlock(block);
        }
        updateCraftableItems();
    }

    // Add item to some empty inventory slot
    public void addItem(Item item) {
        if (item.itemType == ItemType.BLOCK) {
            addBlock((Block) item);
        }
        if (item.itemType == ItemType.TOOL) {
            addTool((Tool) item);
        }
        updateCraftableItems();
    }

    // Add tool to some empty inventory slot
    private void addTool(Tool tool) {
        for (int y = settings.inventoryHeight - 1; y > -1; y--) {
            for (int x = 0; x < settings.inventoryWidth; x++) {
                if (grid[x][y].amount == 0) {
                    grid[x][y].item = tool;
                    grid[x][y].amount = 1;
                    return;
                }
            }
        }
        updateCraftableItems();
    }

    // Add tool to a specified inventory slot
    private void addTool(Tool tool, int x, int y) {
        grid[x][y].item = tool;
        grid[x][y].amount = 1;
    }

    // Add block to some empty inventory slot
    private void addBlock(Block block) {
        boolean foundInInventory = tryAddBlockToExistingStack(block);
        if (!foundInInventory) {
            putBlockInEmptyCell(block);
        }
        updateCraftableItems();
    }
    
    private void updateCraftableItems() {
        
    }
}
