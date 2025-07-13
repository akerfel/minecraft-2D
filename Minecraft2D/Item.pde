public class Item {
    public ItemID itemID;
    public ItemType itemType;
    color c;
    private boolean isStackable;
    boolean hasBlock;
    Block block;
    boolean hasLeftClickAction;
    
    public Item(ItemID itemID, ItemType itemType, boolean isStackable) {
        this.itemID = itemID;
        this.itemType = itemType;
        this.isStackable = isStackable;
        this.c = color(255, 0, 0);
        this.hasLeftClickAction = false;
    }
    
    public Item(ItemID itemID, ItemType itemType, boolean isStackable, color c) {
        this.itemID = itemID;
        this.itemType = itemType;
        this.isStackable = isStackable;
        this.c = c;
        this.hasLeftClickAction = false;
    }
    
    public void setHasLeftClickAction(boolean hasLeftClickAction) {
        this.hasLeftClickAction = hasLeftClickAction;
    }
    
    public String toString() {
        return itemID.toString();
    }
    
    @Override
    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }

        if (obj.getClass() != this.getClass()) {
            return false;
        }

        final Item other = (Item) obj;
        if ((this.itemID == null) ? (other.itemID != null) : !this.itemID.equals(other.itemID)) {
            return false;
        }

        return true;
    }
    
    public boolean isStackable() {
        return isStackable;    
    }
}

// This method holds all item definitions. All item objects should be created with this method.
Item createItem(ItemID itemID) {
    switch (itemID) {
        case DIRT:
            return new Block(itemID, color(151, 109, 77), false, ToolType.SHOVEL, true);
        case GRASS:
            return new Block(itemID, color(127, 178, 56) + color(random(-15, 15), random(-15, 15), random(-15, 15)), false, ToolType.SHOVEL, false);
        case LEAVES:
            return new Block(itemID, color(0, 124, 0) + color(random(-30, 30), random(-0, 30), random(-30, 30)), true, ToolType.AXE, true, 0.5);
        case PLANKS:
            return new Block(itemID, color(194, 155, 115), true, ToolType.AXE, true);
        case SAND:
            return new Block(itemID, color(247, 233, 163), false, ToolType.SHOVEL, true);
        case STONE:
            return new Block(itemID, color(112, 112, 112) + color(random(-8, 8), random(-8, 8), random(-8, 8)), true, ToolType.PICKAXE, true);
        case WATER:
            return new Block(itemID, color(64, 64, 255) + color(random(-15, 15), random(-15, 15), 0), false, ToolType.NOTYPE, false);
        case WOOD:
            return new Block(itemID, color(174, 125, 90), true, ToolType.AXE, true);
        case IRON_ORE:
            return new Block(itemID, color(223, 223, 225), true, ToolType.PICKAXE, true);
        case GOLD_ORE:
            return new Block(itemID, settings.colorGoldTool, true, ToolType.PICKAXE, true);
        case DIAMOND_ORE:
            return new Block(itemID, settings.colorDiamondTool, true, ToolType.PICKAXE, true);

        case WORKBENCH:
            return new Block(itemID, color(217, 177, 140), true, ToolType.AXE, true);

        case WOOD_SWORD:
            return new Tool(itemID, ToolType.SWORD, ToolMaterial.WOOD, settings.woodToolMiningMultiplier, settings.colorWoodTool);
        case STONE_SWORD:
            return new Tool(itemID, ToolType.SWORD, ToolMaterial.STONE, settings.stoneToolMiningMultiplier, settings.colorStoneTool);
        case IRON_SWORD:
            return new Tool(itemID, ToolType.SWORD, ToolMaterial.IRON, settings.ironToolMiningMultiplier, settings.colorIronTool);
        case GOLD_SWORD:
            return new Tool(itemID, ToolType.SWORD, ToolMaterial.GOLD, settings.goldToolMiningMultiplier, settings.colorGoldTool);
        case DIAMOND_SWORD:
            return new Tool(itemID, ToolType.SWORD, ToolMaterial.DIAMOND, settings.diamondToolMiningMultiplier, settings.colorDiamondTool);
        
        case WOOD_PICKAXE:
            return new Tool(itemID, ToolType.PICKAXE, ToolMaterial.WOOD, settings.woodToolMiningMultiplier, settings.colorWoodTool);
        case STONE_PICKAXE:
            return new Tool(itemID, ToolType.PICKAXE, ToolMaterial.STONE, settings.stoneToolMiningMultiplier, settings.colorStoneTool);
        case IRON_PICKAXE:
            return new Tool(itemID, ToolType.PICKAXE, ToolMaterial.IRON, settings.ironToolMiningMultiplier, settings.colorIronTool);
        case GOLD_PICKAXE:
            return new Tool(itemID, ToolType.PICKAXE, ToolMaterial.GOLD, settings.goldToolMiningMultiplier, settings.colorGoldTool);
        case DIAMOND_PICKAXE:
            return new Tool(itemID, ToolType.PICKAXE, ToolMaterial.DIAMOND, settings.diamondToolMiningMultiplier, settings.colorDiamondTool);
        
        case WOOD_SHOVEL:
            return new Tool(itemID, ToolType.SHOVEL, ToolMaterial.WOOD, settings.woodToolMiningMultiplier, settings.colorWoodTool);
        case STONE_SHOVEL:
            return new Tool(itemID, ToolType.SHOVEL, ToolMaterial.STONE, settings.stoneToolMiningMultiplier, settings.colorStoneTool);
        case IRON_SHOVEL:
            return new Tool(itemID, ToolType.SHOVEL, ToolMaterial.IRON, settings.ironToolMiningMultiplier, settings.colorIronTool);
        case GOLD_SHOVEL:
            return new Tool(itemID, ToolType.SHOVEL, ToolMaterial.GOLD, settings.goldToolMiningMultiplier, settings.colorGoldTool);
        case DIAMOND_SHOVEL:
            return new Tool(itemID, ToolType.SHOVEL, ToolMaterial.DIAMOND, settings.diamondToolMiningMultiplier, settings.colorDiamondTool);
        
        case WOOD_AXE:
            return new Tool(itemID, ToolType.AXE, ToolMaterial.WOOD, settings.woodToolMiningMultiplier, settings.colorWoodTool);
        case STONE_AXE:
            return new Tool(itemID, ToolType.AXE, ToolMaterial.STONE, settings.stoneToolMiningMultiplier, settings.colorStoneTool);
        case IRON_AXE:
            return new Tool(itemID, ToolType.AXE, ToolMaterial.IRON, settings.ironToolMiningMultiplier, settings.colorIronTool);
        case GOLD_AXE:
            return new Tool(itemID, ToolType.AXE, ToolMaterial.GOLD, settings.goldToolMiningMultiplier, settings.colorGoldTool);
        case DIAMOND_AXE:
            return new Tool(itemID, ToolType.AXE, ToolMaterial.DIAMOND, settings.diamondToolMiningMultiplier, settings.colorDiamondTool);
        
        case WOOD_HOE:
            return new Tool(itemID, ToolType.HOE, ToolMaterial.WOOD, settings.woodToolMiningMultiplier, settings.colorWoodTool);
        case STONE_HOE:
            return new Tool(itemID, ToolType.HOE, ToolMaterial.STONE, settings.stoneToolMiningMultiplier, settings.colorStoneTool);
        case IRON_HOE:
            return new Tool(itemID, ToolType.HOE, ToolMaterial.IRON, settings.ironToolMiningMultiplier, settings.colorIronTool);
        case GOLD_HOE:
            return new Tool(itemID, ToolType.HOE, ToolMaterial.GOLD, settings.goldToolMiningMultiplier, settings.colorGoldTool);
        case DIAMOND_HOE:
            return new Tool(itemID, ToolType.HOE, ToolMaterial.DIAMOND, settings.diamondToolMiningMultiplier, settings.colorDiamondTool);
            
        case MACHINE_GUN:
            return new MachineGun(itemID);
        case FLAME_THROWER:
            return new FlameThrower(itemID);
        case IRON_BULLET:
            return new Item(itemID, ItemType.BULLET, true, settings.colorIronTool);
        default:
            throw new IllegalArgumentException("Invalid ItemID: " + itemID);
    }
}
