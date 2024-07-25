public class ItemSlot {
    public int xPixel;
    public int yPixel;
    private Item item;
    public int count;

    public ItemSlot(int xPixel, int yPixel) {
        this.xPixel = xPixel;
        this.yPixel = yPixel;
        item = null;
        count = 0;
    }
    
    public void setItem(Item item) {
        this.item = item;    
    }
    
    public void setCount(int count) {
        this.count = count;    
    }

    String toString() {
        if (item == null) {
            return "empty";
        }
        return item.toString();
    }

    void incrementItemCount() {
        count++;
    }
    
    public int getCount() {
        return count;    
    }
    
    public boolean isEmpty() {
        return (count == 0 || item == null);    
    }
    
    public void setToEmpty() {
        item = null;
        count = 0;
    }
    
    public void swapWith(ItemSlot other) {
        Item otherItem = other.item;
        int otherCount = other.count;
        
        other.item = this.item;
        other.count = this.count;
        
        this.item = otherItem;
        this.count = otherCount;
        
    }
}
