public abstract class Item {
    public ItemID itemID;            // unique identifier   
    public ItemType itemType;
    color c;

    public Item(ItemID itemID, ItemType itemType) {
        this.itemType = itemType;
        this.itemID = itemID;
        c = color(255, 0, 0);
    }
    
    public String toString() {
        return itemID.toString();
    }
}
