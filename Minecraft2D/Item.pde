public abstract class Item {
    public ItemID itemID;            // unique identifier   
    public ItemType itemType;
    color c;
    private boolean isStackable;
    boolean hasBlock;
    Block block;
    
    
    public Item(ItemID itemID, ItemType itemType, boolean isStackable) {
        this.itemID = itemID;
        this.itemType = itemType;
        this.isStackable = isStackable;
        c = color(255, 0, 0);
    }
    
    public String toString() {
        return itemID.toString();
    }
    
    public boolean isStackable() {
        return isStackable;    
    }
}

Item createItem(ItemID itemID) {
    switch (itemID) {
        case DIRT:
            return new Dirt();
        case GRASS:
            return new Grass();
        case LEAVES:
            return new Leaves();
        case PLANKS:
            return new Planks();
        case SAND:
            return new Sand();
        case STONE:
            return new Stone();
        case IRON_ORE:
            return new IronOre();
        case WATER:
            return new Water();
        case WOOD:
            return new Wood();
        case WORKBENCH:
            return new Workbench();

        case WOOD_SWORD:
            return new Tool(itemID, ToolType.SWORD, ToolMaterial.WOOD, settings.woodToolMiningMultiplier, settings.colorWoodTool);
        case WOOD_PICKAXE:
            return new Tool(itemID, ToolType.PICKAXE, ToolMaterial.WOOD, settings.woodToolMiningMultiplier, settings.colorWoodTool);
        case WOOD_SHOVEL:
            return new Tool(itemID, ToolType.SHOVEL, ToolMaterial.WOOD, settings.woodToolMiningMultiplier, settings.colorWoodTool);
        case WOOD_AXE:
            return new Tool(itemID, ToolType.AXE, ToolMaterial.WOOD, settings.woodToolMiningMultiplier, settings.colorWoodTool);
        case WOOD_HOE:
            return new Tool(itemID, ToolType.HOE, ToolMaterial.WOOD, settings.woodToolMiningMultiplier, settings.colorWoodTool);
        
        case STONE_SWORD:
            return new Tool(itemID, ToolType.SWORD, ToolMaterial.STONE, settings.stoneToolMiningMultiplier, settings.colorStoneTool);
        case STONE_PICKAXE:
            return new Tool(itemID, ToolType.PICKAXE, ToolMaterial.STONE, settings.stoneToolMiningMultiplier, settings.colorStoneTool);
        case STONE_SHOVEL:
            return new Tool(itemID, ToolType.SHOVEL, ToolMaterial.STONE, settings.stoneToolMiningMultiplier, settings.colorStoneTool);
        case STONE_AXE:
            return new Tool(itemID, ToolType.AXE, ToolMaterial.STONE, settings.stoneToolMiningMultiplier, settings.colorStoneTool);
        case STONE_HOE:
            return new Tool(itemID, ToolType.HOE, ToolMaterial.STONE, settings.stoneToolMiningMultiplier, settings.colorStoneTool);
        
        case IRON_SWORD:
            return new Tool(itemID, ToolType.SWORD, ToolMaterial.IRON, settings.ironToolMiningMultiplier, settings.colorIronTool);
        case IRON_PICKAXE:
            return new Tool(itemID, ToolType.PICKAXE, ToolMaterial.IRON, settings.ironToolMiningMultiplier, settings.colorIronTool);
        case IRON_SHOVEL:
            return new Tool(itemID, ToolType.SHOVEL, ToolMaterial.IRON, settings.ironToolMiningMultiplier, settings.colorIronTool);
        case IRON_AXE:
            return new Tool(itemID, ToolType.AXE, ToolMaterial.IRON, settings.ironToolMiningMultiplier, settings.colorIronTool);
        case IRON_HOE:
            return new Tool(itemID, ToolType.HOE, ToolMaterial.IRON, settings.ironToolMiningMultiplier, settings.colorIronTool);
        case GOLD_SWORD:
            return new Tool(itemID, ToolType.SWORD, ToolMaterial.GOLD, settings.goldToolMiningMultiplier, settings.colorGoldTool);
        
        case GOLD_PICKAXE:
            return new Tool(itemID, ToolType.PICKAXE, ToolMaterial.GOLD, settings.goldToolMiningMultiplier, settings.colorGoldTool);
        case GOLD_SHOVEL:
            return new Tool(itemID, ToolType.SHOVEL, ToolMaterial.GOLD, settings.goldToolMiningMultiplier, settings.colorGoldTool);
        case GOLD_AXE:
            return new Tool(itemID, ToolType.AXE, ToolMaterial.GOLD, settings.goldToolMiningMultiplier, settings.colorGoldTool);
        case GOLD_HOE:
            return new Tool(itemID, ToolType.HOE, ToolMaterial.GOLD, settings.goldToolMiningMultiplier, settings.colorGoldTool);
        
        case DIAMOND_SWORD:
            return new Tool(itemID, ToolType.SWORD, ToolMaterial.DIAMOND, settings.diamondToolMiningMultiplier, settings.colorDiamondTool);
        case DIAMOND_PICKAXE:
            return new Tool(itemID, ToolType.PICKAXE, ToolMaterial.DIAMOND, settings.diamondToolMiningMultiplier, settings.colorDiamondTool);
        case DIAMOND_SHOVEL:
            return new Tool(itemID, ToolType.SHOVEL, ToolMaterial.DIAMOND, settings.diamondToolMiningMultiplier, settings.colorDiamondTool);
        case DIAMOND_AXE:
            return new Tool(itemID, ToolType.AXE, ToolMaterial.DIAMOND, settings.diamondToolMiningMultiplier, settings.colorDiamondTool);
        case DIAMOND_HOE:
            return new Tool(itemID, ToolType.HOE, ToolMaterial.DIAMOND, settings.diamondToolMiningMultiplier, settings.colorDiamondTool);
        
        default:
            throw new IllegalArgumentException("Invalid ItemID: " + itemID);
    }
}
