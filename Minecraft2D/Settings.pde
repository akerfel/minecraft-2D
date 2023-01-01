public class Settings {
    int pixelsPerBlock;            // pixels per side of block
    int blocksPerChunk;            // blocks per side of chunk
    float playerWidth;             // will change depending on zoom level
    float mobWidth;                // will change depending on zoom level
    float baseChanceStone;
    float baseChanceTree;
    float chanceRiver;
    float chanceForestChunk;
    float chanceBigTreesChunk;
    float mobSpawnChance;          // Chance each frame, so should be pretty low
    int maxMobs;
    int mobSpawnRange;             // In blocks
    int mobDespawnRange;           // In blocks
    int viewDistance;
    boolean noStrokeMode;          // Setting this to false HALVES FPS (!), and makes things uglier. Keep it at true.
    int pixelsPerItemSlot;
    int inventoryWidth;
    int inventoryHeight;
    int inventoryUpperLeftXPixel;  // The x pixel coordinate of the upper left corner of the inventory
    int inventoryUpperLeftYPixel;  // The y pixel coordinate of the upper left corner of the inventory
}

void initializeSettings() {
    settings.pixelsPerBlock = 25;
    settings.blocksPerChunk = 256;
    resetObjectsDependingOnPixelsPerBlock();
    settings.baseChanceStone = 0.005;
    settings.baseChanceTree = 0.02;
    settings.chanceRiver = 0.00004;
    settings.chanceForestChunk = 0.17;
    settings.chanceBigTreesChunk = 0.20;
    settings.mobSpawnChance = 0.01;
    settings.maxMobs = 30;
    settings.mobSpawnRange = 50;
    settings.mobDespawnRange = 100;
    settings.viewDistance = 250;
    settings.pixelsPerItemSlot = 60;
    settings.inventoryWidth = 9;
    settings.inventoryHeight = 4;
    settings.inventoryUpperLeftXPixel = width / 2 - settings.pixelsPerItemSlot * settings.inventoryWidth / 2;
    settings.inventoryUpperLeftYPixel = height / 2 - settings.pixelsPerItemSlot * settings.inventoryHeight / 2;
    settings.noStrokeMode = true;
    setNoStrokeModeDependingOnSetting();
}
