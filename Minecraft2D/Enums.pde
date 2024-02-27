import java.util.HashSet;
import java.util.Set;

enum ToolType {
    PICK,
    SHOVEL,
    AXE,
    SWORD,
    NOTYPE
}

enum ToolMaterial {
    WOOD,
    STONE,
    IRON,
    GOLD,
    DIAMOND
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
