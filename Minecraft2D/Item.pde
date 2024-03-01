public abstract class Item {
    public ItemID itemID;            // unique identifier   
    public ItemType itemType;
    color c;
    private boolean isStackable;

    public Item(ItemID itemID, ItemType itemType, boolean isStackable) {
        this.itemType = itemType;
        this.itemID = itemID;
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
