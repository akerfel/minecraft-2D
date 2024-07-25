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
}
