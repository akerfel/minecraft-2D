import java.util.HashSet;
import java.util.Set;

enum ToolType {
    SWORD,
    PICKAXE,
    SHOVEL,
    AXE,
    HOE,
    NOTYPE
}

enum ToolMaterial {
    WOOD,
    STONE,
    IRON,
    GOLD,
    DIAMOND
}

enum ItemType {
    BLOCK,
    TOOL,
    OTHER
}

public enum ItemID {
    
    DIRT,
    GRASS,
    LEAVES,
    PLANKS,
    SAND,
    STONE,
    IRON_ORE,
    WATER,
    WOOD,
   
    WORKBENCH,
    
    WOOD_SWORD,
    WOOD_PICKAXE,
    WOOD_SHOVEL,
    WOOD_AXE,
    WOOD_HOE,
    
    STONE_SWORD,
    STONE_PICKAXE,
    STONE_SHOVEL,
    STONE_AXE,
    STONE_HOE,
    
    IRON_SWORD,
    IRON_PICKAXE,
    IRON_SHOVEL,
    IRON_AXE,
    IRON_HOE,
    
    GOLD_SWORD,
    GOLD_PICKAXE,
    GOLD_SHOVEL,
    GOLD_AXE,
    GOLD_HOE,
    
    DIAMOND_SWORD,
    DIAMOND_PICKAXE,
    DIAMOND_SHOVEL,
    DIAMOND_AXE,
    DIAMOND_HOE
}

Item itemFactory(ItemID itemID) {
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
            return new Tool(ItemID.WOOD_SWORD);
        case WOOD_PICKAXE:
            return new Tool(ItemID.WOOD_PICKAXE);
        case WOOD_SHOVEL:
            return new Tool(ItemID.WOOD_SHOVEL);
        case WOOD_AXE:
            return new Tool(ItemID.WOOD_AXE);
        case WOOD_HOE:
            return new Tool(ItemID.WOOD_HOE);
        
        case STONE_PICKAXE:
            return new Tool(ItemID.STONE_PICKAXE);
        case STONE_SHOVEL:
            return new Tool(ItemID.STONE_SHOVEL);
        case STONE_AXE:
            return new Tool(ItemID.STONE_AXE);
        case STONE_HOE:
            return new Tool(ItemID.STONE_HOE);
        
        case IRON_SWORD:
            return new Tool(ItemID.IRON_SWORD);
        case IRON_PICKAXE:
            return new Tool(ItemID.IRON_PICKAXE);
        case IRON_SHOVEL:
            return new Tool(ItemID.IRON_SHOVEL);
        case IRON_AXE:
            return new Tool(ItemID.IRON_AXE);
        case IRON_HOE:
            return new Tool(ItemID.IRON_HOE);
            
        case GOLD_SWORD:
            return new Tool(ItemID.GOLD_SWORD);
        case GOLD_PICKAXE:
            return new Tool(ItemID.GOLD_PICKAXE);
        case GOLD_SHOVEL:
            return new Tool(ItemID.GOLD_SHOVEL);
        case GOLD_AXE:
            return new Tool(ItemID.GOLD_AXE);
        case GOLD_HOE:
            return new Tool(ItemID.GOLD_HOE);
            
        case DIAMOND_SWORD:
            return new Tool(ItemID.DIAMOND_SWORD);
        case DIAMOND_PICKAXE:
            return new Tool(ItemID.DIAMOND_PICKAXE);
        case DIAMOND_SHOVEL:
            return new Tool(ItemID.DIAMOND_SHOVEL);
        case DIAMOND_AXE:
            return new Tool(ItemID.DIAMOND_AXE);
        case DIAMOND_HOE:
            return new Tool(ItemID.DIAMOND_HOE);
        default:
            throw new IllegalArgumentException("Invalid ItemID: " + itemID);
    }
}

// Tools grouped by material

Set<ItemID> woodToolIDs = new HashSet<>(Set.of(
    ItemID.WOOD_SWORD,
    ItemID.WOOD_PICKAXE,
    ItemID.WOOD_SHOVEL,
    ItemID.WOOD_AXE,
    ItemID.WOOD_HOE
));

Set<ItemID> stoneToolIDs = new HashSet<>(Set.of(
    ItemID.STONE_SWORD,
    ItemID.STONE_PICKAXE,
    ItemID.STONE_SHOVEL,
    ItemID.STONE_AXE,
    ItemID.STONE_HOE
));

Set<ItemID> ironToolIDs = new HashSet<>(Set.of(
    ItemID.IRON_SWORD,
    ItemID.IRON_PICKAXE,
    ItemID.IRON_SHOVEL,
    ItemID.IRON_AXE,
    ItemID.IRON_HOE
));

Set<ItemID> goldToolIDs = new HashSet<>(Set.of(
    ItemID.GOLD_SWORD,
    ItemID.GOLD_PICKAXE,
    ItemID.GOLD_SHOVEL,
    ItemID.GOLD_AXE,
    ItemID.GOLD_HOE
));

Set<ItemID> diamondToolIDs = new HashSet<>(Set.of(
    ItemID.DIAMOND_SWORD,
    ItemID.DIAMOND_PICKAXE,
    ItemID.DIAMOND_SHOVEL,
    ItemID.DIAMOND_AXE,
    ItemID.DIAMOND_HOE
));

// Tools grouped by type

Set<ItemID> swordIDs = new HashSet<>(Set.of(
    ItemID.WOOD_SWORD,
    ItemID.STONE_SWORD,
    ItemID.IRON_SWORD,
    ItemID.GOLD_SWORD,
    ItemID.DIAMOND_SWORD
));

Set<ItemID> pickaxeIDs = new HashSet<>(Set.of(
    ItemID.WOOD_PICKAXE,
    ItemID.STONE_PICKAXE,
    ItemID.IRON_PICKAXE,
    ItemID.GOLD_PICKAXE,
    ItemID.DIAMOND_PICKAXE
));

Set<ItemID> shovelIDs = new HashSet<>(Set.of(
    ItemID.WOOD_SHOVEL,
    ItemID.STONE_SHOVEL,
    ItemID.IRON_SHOVEL,
    ItemID.GOLD_SHOVEL,
    ItemID.DIAMOND_SHOVEL
));

Set<ItemID> axeIDs = new HashSet<>(Set.of(
    ItemID.WOOD_AXE,
    ItemID.STONE_AXE,
    ItemID.IRON_AXE,
    ItemID.GOLD_AXE,
    ItemID.DIAMOND_AXE
));

Set<ItemID> hoeIDs = new HashSet<>(Set.of(
    ItemID.WOOD_HOE,
    ItemID.STONE_HOE,
    ItemID.IRON_HOE,
    ItemID.GOLD_HOE,
    ItemID.DIAMOND_HOE
));
