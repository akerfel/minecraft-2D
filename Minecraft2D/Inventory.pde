public class Inventory {
    int hotbarIndexSelected;                // The currently selected hotbar index
    ItemSlot[][] grid;                      // The hotbar is the last row in the grid
    ItemSlot[] craftingGrid;
    ItemSlot mouseHeldItemSlot;             // An itemSlot which is held by the mouse in the inventory (e.g. when reorganizing the inventory)
    int grabbedXindex;                      // the x index of the grid from which the mouse grabbed an item from
    int grabbedYindex;

    public Inventory() {
        hotbarIndexSelected = 0;
        craftingGrid = new ItemSlot[4];
        setCraftingGridEmpty();
        grid = new ItemSlot[settings.inventoryWidth][settings.inventoryHeight];
        setInventoryEmpty();
        mouseHeldItemSlot = new ItemSlot();
    }

    Item getHeldItem() {
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
    }

    // Add item to some empty inventory slot
    void addItem(Item item) {
        if (item.type.equals("block")) {
            addBlock((Block) item);
        }
        if (item.type.equals("tool")) {
            addTool((Tool) item);
        }
    }

    // Add item to a specified inventory slot
    void addItem(Item item, int x, int y) {
        if (item.type.equals("block")) {
            addBlock((Block) item, x, y);
        }
        if (item.type.equals("tool")) {
            addTool((Tool) item, x, y);
        }
    }

    // Add tool to some empty inventory slot
    void addTool(Tool tool) {
        for (int y = settings.inventoryHeight - 1; y > -1; y--) {
            for (int x = 0; x < settings.inventoryWidth; x++) {
                if (grid[x][y].amount == 0) {
                    grid[x][y].item = tool;
                    grid[x][y].amount = 1;
                    return;
                }
            }
        }
    }

    // Add tool to a specified inventory slot
    void addTool(Tool tool, int x, int y) {
        grid[x][y].item = tool;
        grid[x][y].amount = 1;
    }

    // Add block to some empty inventory slot
    void addBlock(Block block) {
        boolean foundInInventory = tryAddBlockToExistingStack(block);
        if (!foundInInventory) {
            putBlockInEmptyCell(block);
        }
    }

    void addBlock(Block block, int amount) {
        for (int i = 0; i < amount; i++) {
            addBlock(block);
        }
    }

    // Add block to a specified inventory slot
    void addBlock(Block block, int x, int y) {
        if (grid[x][y].toString().equals(block.toString()) && grid[x][y].amount < 64) {
            grid[x][y].incrementItemAmount();
        } else {
            putBlockInEmptyCell(block, x, y);
        }
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
    }

    // Put block in a specified cell
    private void putBlockInEmptyCell(Block block, int x, int y) {
        if (grid[x][y].amount == 0) {
            grid[x][y].item = block;
            grid[x][y].amount = 1;
        }
    }

    void setCraftingGridEmpty() {
        for (int i = 0; i < 4; i++) {
            craftingGrid[i] = new ItemSlot();
        }
    }

    void setInventoryEmpty() {
        for (int y = 0; y < settings.inventoryHeight; y++) {
            for (int x = 0; x < settings.inventoryWidth; x++) {
                grid[x][y] = new ItemSlot();
            }
        }
    }
}
