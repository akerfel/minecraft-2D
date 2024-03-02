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
