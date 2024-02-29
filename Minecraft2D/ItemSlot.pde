public class ItemStack {
    Item item;
    int amount;

    public ItemStack() {
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
