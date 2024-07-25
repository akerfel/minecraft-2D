public class Recipe {
    private ArrayList<ItemCount> costs = new ArrayList<>();
    private ItemCount result;
    
    public Recipe(Item item, int count) {
        this.result = new ItemCount(item, count);
    }
    
    public Recipe addCost(Item item, int count) {
        costs.add(new ItemCount(item, count));
        return this;
    }
    
    public ArrayList<ItemCount> getCosts() {
        return costs;    
    }
    
    public ItemCount getResult() {
        return result;    
    }
}
