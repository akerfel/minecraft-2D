public class HotbarCell {
    Item item;
    int amount;
    
    public HotbarCell() {
        item = null;
        amount = 0;
    }
    
    String toString() {
        if (item == null) {
            return "empty";    
        }
        return item.toString();    
    }
    
    void incrementItemAmount() {
        amount++;
    }
}
