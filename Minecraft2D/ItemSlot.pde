public class ItemSlot {
    private Item item;
    private int amount;

    public ItemSlot() {
        item = null;
        amount = 0;
    }
    
    public void setItem(Item item) {
        this.item = item;    
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
    
    public boolean isEmpty() {
        return (amount == 0 || item == null);    
    }
}
