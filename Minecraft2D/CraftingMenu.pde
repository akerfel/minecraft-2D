public class CraftingMenu {
    ArrayList<Recipe> handRecipes = new ArrayList<>();
    ArrayList<Recipe> workbenchRecipes = new ArrayList<>();
    
    public CraftingMenu() {
        // Player recipes
        handRecipes.add(new Recipe(createItem(ItemID.PLANKS), 4).addCost(createItem(ItemID.WOOD), 1));
        handRecipes.add(new Recipe(createItem(ItemID.WORKBENCH), 1).addCost(createItem(ItemID.PLANKS), 4));
        
        // Workbench recipes
        
        workbenchRecipes.add(new Recipe(createItem(ItemID.WOOD_SWORD), 1).addCost(createItem(ItemID.PLANKS), 4));
        workbenchRecipes.add(new Recipe(createItem(ItemID.STONE_SWORD), 1).addCost(createItem(ItemID.PLANKS), 2).addCost(createItem(ItemID.STONE), 2));
        workbenchRecipes.add(new Recipe(createItem(ItemID.IRON_SWORD), 1).addCost(createItem(ItemID.PLANKS), 2).addCost(createItem(ItemID.IRON_ORE), 2));
        workbenchRecipes.add(new Recipe(createItem(ItemID.GOLD_SWORD), 1).addCost(createItem(ItemID.PLANKS), 2).addCost(createItem(ItemID.GOLD_ORE), 2));
        workbenchRecipes.add(new Recipe(createItem(ItemID.DIAMOND_SWORD), 1).addCost(createItem(ItemID.PLANKS), 2).addCost(createItem(ItemID.DIAMOND_ORE), 2));
        
        workbenchRecipes.add(new Recipe(createItem(ItemID.WOOD_PICKAXE), 1).addCost(createItem(ItemID.PLANKS), 4));
        workbenchRecipes.add(new Recipe(createItem(ItemID.STONE_PICKAXE), 1).addCost(createItem(ItemID.PLANKS), 2).addCost(createItem(ItemID.STONE), 2));
        workbenchRecipes.add(new Recipe(createItem(ItemID.IRON_PICKAXE), 1).addCost(createItem(ItemID.PLANKS), 2).addCost(createItem(ItemID.IRON_ORE), 2));
        workbenchRecipes.add(new Recipe(createItem(ItemID.GOLD_PICKAXE), 1).addCost(createItem(ItemID.PLANKS), 2).addCost(createItem(ItemID.GOLD_ORE), 2));
        workbenchRecipes.add(new Recipe(createItem(ItemID.DIAMOND_PICKAXE), 1).addCost(createItem(ItemID.PLANKS), 2).addCost(createItem(ItemID.DIAMOND_ORE), 2));
        
        workbenchRecipes.add(new Recipe(createItem(ItemID.WOOD_SHOVEL), 1).addCost(createItem(ItemID.PLANKS), 4));
        workbenchRecipes.add(new Recipe(createItem(ItemID.STONE_SHOVEL), 1).addCost(createItem(ItemID.PLANKS), 2).addCost(createItem(ItemID.STONE), 2));
        workbenchRecipes.add(new Recipe(createItem(ItemID.IRON_SHOVEL), 1).addCost(createItem(ItemID.PLANKS), 2).addCost(createItem(ItemID.IRON_ORE), 2));
        workbenchRecipes.add(new Recipe(createItem(ItemID.GOLD_SHOVEL), 1).addCost(createItem(ItemID.PLANKS), 2).addCost(createItem(ItemID.GOLD_ORE), 2));
        workbenchRecipes.add(new Recipe(createItem(ItemID.DIAMOND_SHOVEL), 1).addCost(createItem(ItemID.PLANKS), 2).addCost(createItem(ItemID.DIAMOND_ORE), 2));
        
        workbenchRecipes.add(new Recipe(createItem(ItemID.WOOD_AXE), 1).addCost(createItem(ItemID.PLANKS), 4));
        workbenchRecipes.add(new Recipe(createItem(ItemID.STONE_AXE), 1).addCost(createItem(ItemID.PLANKS), 2).addCost(createItem(ItemID.STONE), 2));
        workbenchRecipes.add(new Recipe(createItem(ItemID.IRON_AXE), 1).addCost(createItem(ItemID.PLANKS), 2).addCost(createItem(ItemID.IRON_ORE), 2));
        workbenchRecipes.add(new Recipe(createItem(ItemID.GOLD_AXE), 1).addCost(createItem(ItemID.PLANKS), 2).addCost(createItem(ItemID.GOLD_ORE), 2));
        workbenchRecipes.add(new Recipe(createItem(ItemID.DIAMOND_AXE), 1).addCost(createItem(ItemID.PLANKS), 2).addCost(createItem(ItemID.DIAMOND_ORE), 2));
        
        workbenchRecipes.add(new Recipe(createItem(ItemID.WOOD_HOE), 1).addCost(createItem(ItemID.PLANKS), 4));
        workbenchRecipes.add(new Recipe(createItem(ItemID.STONE_HOE), 1).addCost(createItem(ItemID.PLANKS), 2).addCost(createItem(ItemID.STONE), 2));
        workbenchRecipes.add(new Recipe(createItem(ItemID.IRON_HOE), 1).addCost(createItem(ItemID.PLANKS), 2).addCost(createItem(ItemID.IRON_ORE), 2));
        workbenchRecipes.add(new Recipe(createItem(ItemID.GOLD_HOE), 1).addCost(createItem(ItemID.PLANKS), 2).addCost(createItem(ItemID.GOLD_ORE), 2));
        workbenchRecipes.add(new Recipe(createItem(ItemID.DIAMOND_HOE), 1).addCost(createItem(ItemID.PLANKS), 2).addCost(createItem(ItemID.DIAMOND_ORE), 2));
    }
    
    private ArrayList<Recipe> getAllRecipes() {
        ArrayList<Recipe> allRecipes = new ArrayList<>();
        allRecipes.addAll(handRecipes);
        allRecipes.addAll(workbenchRecipes);
        return allRecipes;
    }
    
    public ArrayList<ItemCount> getCraftingCosts(Item item) {
        for (Recipe recipe : getAllRecipes()) {
            if (recipe.result.item.equals(item)) {
                return recipe.costs;    
            }
        }
        return null;
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
