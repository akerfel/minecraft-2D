public class Recipe {
    private ArrayList<ItemSlot> costs = new ArrayList<>();
    private ItemSlot result;
    
    public Recipe(Item item, int count) {
        this.result = new ItemSlot(item, count);
    }
    
    public Recipe addCost(Item item, int count) {
        costs.add(new ItemSlot(item, count));
        return this;
    }
    
    public ArrayList<ItemSlot> getCosts() {
        return costs;    
    }
    
    public ItemSlot getResult() {
        return result;    
    }
}
