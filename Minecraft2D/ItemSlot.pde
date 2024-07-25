public class ItemSlot {
    private Item item;
    public int count;
    public int xPixel;
    public int yPixel;
    public boolean isCraftingSlot;

    public ItemSlot(int xPixel, int yPixel) {
        this.item = null;
        this.count = 0;
        this.xPixel = xPixel;
        this.yPixel = yPixel;
        this.isCraftingSlot = false;
    }

    public ItemSlot(Item item, int count, int xPixel, int yPixel) {
        this.item = item;
        this.count = count;
        this.xPixel = xPixel;
        this.yPixel = yPixel;
        this.isCraftingSlot = false;
    }
    
    public ItemSlot setAsCraftingSlot() {
        isCraftingSlot = true;
        return this;
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
    
    
    void decrementItemCount() {
        count--;
        if (count < 1) {
            item = null;
        }
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
    
    boolean mouseCurrentlyHovers() {
        return mouseX >= xPixel && mouseX <= xPixel + settings.pixelsPerItemSlot &&
               mouseY >= yPixel && mouseY <= yPixel + settings.pixelsPerItemSlot;
    }
}
