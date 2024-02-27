public class Item {
    public ItemID itemID;            // unique identifier   
    String type;
    color c;

    public Item(String type, ItemID itemID) {
        this.type = type;
        this.itemID = itemID;
        c = color(255, 0, 0);
    }
    
    public String toString() {
        return itemID.toString();
    }
}
