import java.util.Map;
import java.util.stream.Collectors;
import static java.util.Map.entry;

public class Settings {
    
    // Will change depending on zoom level (not initialized in this class)
    float playerWidth;
    float mobWidth;
    
    // Dynamic
    int viewDistance;
    
    // General
    int blocksPerChunk;            // blocks per side of chunk;
    int maxStackCount;
    int craftingDistance;          // Minimum distance (in blocks) to crafting table in order to use it
    
    // Visuals
    int pixelsPerBlock;            // pixels per side of block
    boolean noStrokeMode;          // Setting this to false HALVES FPS (!), and makes things uglier. Keep it at true.
    boolean drawInnerSquaresInBlocks;
    float offsetInnerSquare;       // How far from the corner of the block the inner square should start, between 0 - 1. Default 0.1
    
    // Colors
    color colorWoodTool;
    color colorStoneTool;
    color colorIronTool;
    color colorGoldTool;
    color colorDiamondTool;
    
    // Default/base chunk 
    float baseChanceStone;
    float baseChanceTree;
    
    // Big trees chunks
    float chanceBigTreesChunk;
    
    // Forest chunk
    float chanceForestChunk;
    float chanceTreeInForestChunk;
    
    // Mountain chunk
    float chanceMountainChunk;
    float chanceStone;
    
    // Other
    float chanceRiver;
    
    // Mobs
    int maxMobs;
    int mobSpawnRange;             // In blocks
    int mobDespawnRange;           // In blocks
    
    // Mob spawn chance each frame, so should be pretty low
    float pigSpawnChance;
    float zombieSpawnChance;
    
    // Mob speeds
    float pigSpeedFactor = 0.1;
    float zombieSpeedFactor = 0.05;
    
    // Tools
    int woodToolMiningMultiplier;
    int stoneToolMiningMultiplier;
    int ironToolMiningMultiplier;
    int goldToolMiningMultiplier;
    int diamondToolMiningMultiplier;
    
    // Inventory
    int pixelsPerItemSlot;
    int inventoryWidth;
    int inventoryHeight;
    int inventoryUpperLeftXPixel;  // The x pixel coordinate of the upper left corner of the inventory
    int inventoryUpperLeftYPixel;  // The y pixel coordinate of the upper left corner of the inventory

    // Mapping block to chars
    Map<ItemID, Character> blockIDsToChars;
    Map<Character, ItemID> blockCharsToIDs;
    
    public void initialize() {
        // Dynamic
        this.viewDistance = 250;
        
        // General 
        this.blocksPerChunk = 64;
        this.maxStackCount = 64;
        this.craftingDistance = 5;
        
        // Visuals
        this.pixelsPerBlock = 25;
        this.noStrokeMode = true;
        setNoStrokeModeDependingOnSetting();
        resetObjectsDependingOnPixelsPerBlock();
        this.drawInnerSquaresInBlocks = false;
        this.offsetInnerSquare = 0.1;
        
        // colors
        this.colorWoodTool = color(143, 119, 72);
        this.colorStoneTool = color(112, 112, 112);
        this.colorIronTool = color(167, 167, 167);
        this.colorGoldTool = color(250, 238, 77);
        this.colorDiamondTool = color(92, 219, 213);
        
        // Block chances
        this.chanceStone = 0.38;
        
        // Other
        this.chanceRiver = 0.00004;
        
        // Mobs
        this.maxMobs = 1000;
        this.mobSpawnRange = 50;
        this.mobDespawnRange = 100;
        
        // Mob spawn chance
        this.pigSpawnChance = 0.05;
        this.zombieSpawnChance = 0.05;
        
        // Mob speeds
        this.pigSpeedFactor = 0.1;
        this.zombieSpeedFactor = 0.05;
        
        // Tools
        this.woodToolMiningMultiplier = 2;
        this.stoneToolMiningMultiplier = 4;
        this.ironToolMiningMultiplier = 6;
        this.goldToolMiningMultiplier = 8;
        this.diamondToolMiningMultiplier = 10;
        
        // Inventory
        this.pixelsPerItemSlot = 60;
        this.inventoryWidth = 9;
        this.inventoryHeight = 4;
        this.inventoryUpperLeftXPixel = width / 2 - settings.pixelsPerItemSlot * settings.inventoryWidth / 2;
        this.inventoryUpperLeftYPixel = height / 2 - settings.pixelsPerItemSlot * settings.inventoryHeight / 2;
        
        // Mapping block to chars
        mapBlockNamesToCharacters();
    }    
}



private void mapBlockNamesToCharacters() {// Maps block names to block chars.
    // E.g. "wood" could map to "w".
    settings.blockIDsToChars = Map.ofEntries(
        entry(ItemID.DIRT, 'd'),
        entry(ItemID.GRASS, '_'),
        entry(ItemID.LEAVES, 'l'),
        entry(ItemID.PLANKS, 'p'),
        entry(ItemID.SAND, 's'),
        entry(ItemID.STONE, 'S'),
        entry(ItemID.WATER, '~'),
        entry(ItemID.WOOD, 'w'),
        entry(ItemID.IRON_ORE, 'i')
    );

    // blockCharsToNames is a reverse map of blockNamesToChars
    settings.blockCharsToIDs =
        settings.blockIDsToChars.entrySet()
        .stream()
        .collect(Collectors.toMap(Map.Entry::getValue, Map.Entry::getKey));
}
