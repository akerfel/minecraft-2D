public class CraftingMenu {
    ArrayList<Recipe> playerRecipes = new ArrayList<>();;
    ArrayList<Recipe> workbenchRecipes = new ArrayList<>();;
    
    public CraftingMenu() {
        Recipe stonePickaxeRecipe = new Recipe(new Tool(ItemID.STONE_PICKAXE));
        stonePickaxeRecipe.addCost(new Wood(), 2).addCost(new Stone(), 3);
        workbenchRecipes.add(stonePickaxeRecipe);
    }
}
