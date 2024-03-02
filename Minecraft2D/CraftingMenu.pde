public class CraftingMenu {
    ArrayList<Recipe> handRecipes = new ArrayList<>();
    ArrayList<Recipe> workbenchRecipes = new ArrayList<>();
    
    public CraftingMenu() {
        
        // Player recipes
        handRecipes.add(new Recipe(new Planks(), 4).addCost(new Wood(), 1));
        handRecipes.add(new Recipe(new Workbench(), 1).addCost(new Planks(), 4));
        
        // Workbench recipes
        workbenchRecipes.add(new Recipe(new Tool(ItemID.STONE_PICKAXE), 1).addCost(new Planks(), 2).addCost(new Stone(), 3));
    }
    
    // Get list of items craftable by hand (i.e., while not using a workbench)
    public ArrayList<ItemCount> getHandCraftableItems(Inventory inventory) {
        ArrayList<ItemCount> craftable = new ArrayList<>();
        for (Recipe recipe : handRecipes) {
            boolean canCraftItem = true;
            for (ItemCount itemCount : recipe.getCosts()) {
                
                if (!inventory.hasItem(itemCount)) {
                    canCraftItem = false;
                    break;
                }
            }
            if (canCraftItem) {
                craftable.add(recipe.getResult());
            }
        }
        return craftable;
    }
    
    public ArrayList<ItemCount> getWorkbenchCraftableItems(Inventory inventory) {
        ArrayList<ItemCount> craftable = new ArrayList<>();
        for (Recipe recipe : workbenchRecipes) {
            boolean canCraftItem = true;
            for (ItemCount itemCount : recipe.getCosts()) {
                
                if (!inventory.hasItem(itemCount)) {
                    canCraftItem = false;
                    break;
                }
            }
            if (canCraftItem) {
                craftable.add(recipe.getResult());
            }
        }
        return craftable;
    }
}
