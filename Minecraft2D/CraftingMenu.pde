public class CraftingMenu {
    ArrayList<Recipe> playerRecipes = new ArrayList<>();
    ArrayList<Recipe> workbenchRecipes = new ArrayList<>();
    
    public CraftingMenu() {
        
        // Player recipes
        playerRecipes.add(new Recipe(new Planks(), 4).addCost(new Wood(), 1));
        
        // Workbench recipes
        workbenchRecipes.add(new Recipe(new Tool(ItemID.STONE_PICKAXE), 1).addCost(new Wood(), 2).addCost(new Stone(), 3));
    }
    
    // Get list of items craftable by the player (i.e., while not using a workbench)
    public ArrayList<ItemCount> getPlayerCraftableItems(Inventory inventory) {
        ArrayList<ItemCount> craftableItems = new ArrayList<>();
        for (Recipe recipe : playerRecipes) {
            boolean canCraftItem = true;
            for (ItemCount itemCount : recipe.getCosts()) {
                
                if (!inventory.hasItem(itemCount)) {
                    canCraftItem = false;
                    break;
                }
            }
            if (canCraftItem) {
                craftableItems.add(recipe.getResult());
            }
        }
        return craftableItems;
    }
}
