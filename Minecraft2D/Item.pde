public class Item {
    public ItemID itemID;            // unique identifier   
    public ItemType itemType;
    color c;

    public Item(ItemType itemType, ItemID itemID) {
        this.itemType = itemType;
        this.itemID = itemID;
        c = color(255, 0, 0);
    }
    
    public String toString() {
        return itemID.toString();
    }
}
