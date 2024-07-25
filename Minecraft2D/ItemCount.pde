public class ItemCount {
    public Item item;
    public int count;
    
    public ItemCount(Item item, int count) {
        this.item = item;
        this.count = count;
    }
    
    public ItemSlot toItemSlot(int xPixel, int yPixel) {
        return new ItemSlot(item, count, xPixel, yPixel);
    }
}
