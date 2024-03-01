public class Inventory {
    int hotbarIndexSelected;                // The currently selected hotbar index
    ItemSlot[][] grid;                      // The hotbar is the last row in the grid
    ItemSlot mouseHeldItemSlot;             // An itemSlot which is held by the mouse in the inventory (e.g. when reorganizing the inventory)
    ArrayList<Item> craftableItems;
    int grabbedXindex;                      // the x index of the grid from which the mouse grabbed an item from
    int grabbedYindex;
    CraftingMenu craftingMenu;

    public Inventory() {
        hotbarIndexSelected = 0;
        grid = new ItemSlot[settings.inventoryWidth][settings.inventoryHeight];
        setInventoryEmpty();
        mouseHeldItemSlot = new ItemSlot();
        craftableItems = new ArrayList<>();
        craftingMenu = new CraftingMenu();
    }
    
    public ArrayList<ItemCount> getPlayerCraftableItems() {
        return craftingMenu.getPlayerCraftableItems(this);    
    }

    public Item getHeldItem() {
        return getHotbarSlot(hotbarIndexSelected).item;
    }

    public boolean isHoldingTool() {
        return getHeldItem() instanceof Tool;
    }

    public void returnMouseGrabbedItemToInventory() {
        if (mouseHeldItemSlot.count > 0) {
            grid[grabbedXindex][grabbedYindex] = mouseHeldItemSlot;
            mouseHeldItemSlot = new ItemSlot();
        }
    }

    private ItemSlot getHotbarSlot(int x) {
        return grid[x][settings.inventoryHeight - 1];
    }

    private void setInventoryEmpty() {
        for (int y = 0; y < settings.inventoryHeight; y++) {
            for (int x = 0; x < settings.inventoryWidth; x++) {
                grid[x][y] = new ItemSlot();
            }
        }
    }
    
    public boolean hasItem(ItemCount itemCount) {
        return hasItem(itemCount.item, itemCount.count);    
    }
    
    public boolean hasItem(Item item, int count) {
        int foundItems = 0;
        for (int y = settings.inventoryHeight - 1; y > -1; y--) {
            for (int x = 0; x < settings.inventoryWidth; x++) {
                ItemSlot itemSlot = grid[x][y];
                if (itemSlot.item != null && itemSlot.item.itemID == item.itemID) {
                    foundItems += itemSlot.count;
                    if (foundItems > count) {
                        return true;    
                    }
                }
            }
        }
        return false;
    }
    
    // Returns true if item could be addad to a stack
    private boolean tryAddItemToSomeStack(Item item) {
        for (int y = settings.inventoryHeight - 1; y > -1; y--) {
            for (int x = 0; x < settings.inventoryWidth; x++) {
                if (grid[x][y].item != null && grid[x][y].item.itemID == item.itemID && grid[x][y].count < 64) {
                    grid[x][y].incrementItemCount();
                    return true;
                }
            }
        }
        return false;
    }
    
    // Adds 'count' items to the inventory. Returns the amount of items which could not be added.
    public int addItem(Item item, int count) {
        for (int added = 0; added < count; added++) {
            if (!addItem(item)) {
                return count - added;
            }
        }
        return 0;
    }
    
    private boolean tryToAddUnstackableItem(Item item) {
        for (int y = settings.inventoryHeight - 1; y > -1; y--) {
            for (int x = 0; x < settings.inventoryWidth; x++) {
                if (grid[x][y].isEmpty()) {
                    grid[x][y].item = item;
                    grid[x][y].count = 1;
                    return true;
                }
            }
        }
        return false;
    }
    
    // Add item to some empty inventory slot
    public boolean addItem(Item item) {
        if (item.isStackable() && tryAddItemToSomeStack(item)) {
            return true;    
        }
        return tryToAddUnstackableItem(item);
    }
}
