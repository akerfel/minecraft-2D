public class ItemSlot {
    private Item item;
    public int count;

    public ItemSlot() {
        item = null;
        count = 0;
    }
    
    public ItemSlot(Item item, int count) {
        this.item = item;
        this.count = count;
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

    void incrementItemSlot() {
        count++;
    }
    
    public int getCount() {
        return count;    
    }
    
    public boolean isEmpty() {
        return (count == 0 || item == null);    
    }
}
