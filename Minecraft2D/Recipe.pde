public abstract class Recipe {
    ArrayList<Item> costs = new ArrayList<Item>();
    public Item result;
    
    public Recipe(Item result) {
        this.result = result;
    }
}
