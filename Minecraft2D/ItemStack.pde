public class ItemStack {
    private Item item;
    private int count;

    public ItemStack(Item item, int count) {
        this.item = item;
        this.count = count;
    }

    String toString() {
        if (item == null) {
            return "empty";
        }
        return item.toString();
    }

    void incrementCount() {
        count++;
    }
}
