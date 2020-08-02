public class HotbarCell {
    Block block;
    int amount;
    
    public HotbarCell() {
        block = null;
        amount = 0;
    }
    
    String toString() {
        if (block == null) {
            return "Empty";    
        }
        return block.toString();    
    }
    
    void incrementItemAmount() {
        amount++;
    }
}
