import java.util.Map;
import java.util.stream.Collectors;
import static java.util.Map.entry;

public class Settings {
    
    // Will change depending on zoom level (not initialized in this class)
    float playerWidth;
    float mobWidth;
    
    // Visuals
    int pixelsPerBlock;            // pixels per side of block
    int blocksPerChunk;            // blocks per side of chunk;
    boolean noStrokeMode;          // Setting this to false HALVES FPS (!), and makes things uglier. Keep it at true.
    int viewDistance;
    
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
    float mobSpawnChance;          // Chance each frame, so should be pretty low
    int maxMobs;
    int mobSpawnRange;             // In blocks
    int mobDespawnRange;           // In blocks
    
    // Inventory
    int pixelsPerItemSlot;
    int inventoryWidth;
    int inventoryHeight;
    int inventoryUpperLeftXPixel;  // The x pixel coordinate of the upper left corner of the inventory
    int inventoryUpperLeftYPixel;  // The y pixel coordinate of the upper left corner of the inventory

    // Mapping block to chars
    Map<String, Character> blockNamesToChars;
    Map<Character, String> blockCharsToNames;
}

void initializeSettings() {
    
    // Visuals
    settings.pixelsPerBlock = 25;
    settings.blocksPerChunk = 64;
    settings.noStrokeMode = true;
    setNoStrokeModeDependingOnSetting();
    resetObjectsDependingOnPixelsPerBlock();
    settings.viewDistance = 250;
    
    // Block chances
    settings.chanceStone = 0.38;
    
    // Other
    settings.chanceRiver = 0.00004;
    
    // Mobs
    settings.mobSpawnChance = 0.01;
    settings.maxMobs = 30;
    settings.mobSpawnRange = 50;
    settings.mobDespawnRange = 100;
    
    // Inventory
    settings.pixelsPerItemSlot = 60;
    settings.inventoryWidth = 9;
    settings.inventoryHeight = 4;
    settings.inventoryUpperLeftXPixel = width / 2 - settings.pixelsPerItemSlot * settings.inventoryWidth / 2;
    settings.inventoryUpperLeftYPixel = height / 2 - settings.pixelsPerItemSlot * settings.inventoryHeight / 2;
    
    // Mapping block to chars
    mapBlockNamesToCharacters();
}

private void mapBlockNamesToCharacters() {// Maps block names to block chars.
    // E.g. "wood" could map to "w".
    settings.blockNamesToChars = Map.ofEntries(
        entry("dirt", 'd'),
        entry("grass", '_'),
        entry("leaves", 'l'),
        entry("planks", 'p'),
        entry("sand", 's'),
        entry("stone", 'S'),
        entry("water", '~'),
        entry("wood", 'w'),
        entry("ironore", 'i')
        );

    // blockCharsToNames is a reverse map of blockNamesToChars
    settings.blockCharsToNames =
        settings.blockNamesToChars.entrySet()
        .stream()
        .collect(Collectors.toMap(Map.Entry::getValue, Map.Entry::getKey));
}
