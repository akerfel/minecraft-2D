public class ItemSlot {
    Item item;
    int amount;

    public ItemSlot() {
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
