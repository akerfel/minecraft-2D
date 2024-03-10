public abstract class Item {
    public ItemID itemID;            // unique identifier   
    public ItemType itemType;
    color c;
    private boolean isStackable;
    boolean hasBlock;
    Block block;
    
    public Item(ItemID itemID, ItemType itemType, boolean isStackable) {
        this.itemID = itemID;
        this.itemType = itemType;
        this.isStackable = isStackable;
        c = color(255, 0, 0);
    }
    
    public String toString() {
        return itemID.toString();
    }
    
    public boolean isStackable() {
        return isStackable;    
    }
}
