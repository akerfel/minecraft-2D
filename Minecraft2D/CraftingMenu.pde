public class CraftingMenu {
    ArrayList<Recipe> handRecipes = new ArrayList<>();
    ArrayList<Recipe> workbenchRecipes = new ArrayList<>();
    
    public CraftingMenu() {
        
        // Player recipes
        handRecipes.add(new Recipe(new Planks(), 4).addCost(new Wood(), 1));
        
        // Workbench recipes
        workbenchRecipes.add(new Recipe(new Tool(ItemID.STONE_PICKAXE), 1).addCost(new Wood(), 2).addCost(new Stone(), 3));
    }
    
    // Get list of items craftable by hand(i.e., while not using a workbench)
    public ArrayList<ItemCount> getHandCraftableItems(Inventory inventory) {
        ArrayList<ItemCount> handCraftableItems = new ArrayList<>();
        for (Recipe recipe : handRecipes) {
            boolean canCraftItem = true;
            for (ItemCount itemCount : recipe.getCosts()) {
                
                if (!inventory.hasItem(itemCount)) {
                    canCraftItem = false;
                    break;
                }
            }
            if (canCraftItem) {
                handCraftableItems.add(recipe.getResult());
            }
        }
        return handCraftableItems;
    }
}
