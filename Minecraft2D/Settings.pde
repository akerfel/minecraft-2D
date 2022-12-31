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

void intializeSettings() {
    pixelsPerBlock = 25;
    blocksPerChunk = 512;
    resetObjectsDependingOnPixelsPerBlock();
    baseChanceStone = 0.005;
    baseChanceTree = 0.02;
    chanceRiver = 0.00004;
    chanceForestChunk = 0.17;
    chanceBigTreesChunk = 0.20;
    println("worldSeed: " + worldSeed);
    mobSpawnChance = 0.01;
    maxMobs = 30;
    mobSpawnRange = 50;
    mobDespawnRange = 100;
    viewDistance = 250;
    noStrokeMode = true;
    settingsSetup();
    pixelsPerItemSlot = 60;
    inventoryWidth = 9;
    inventoryHeight = 4;
    inventoryUpperLeftXPixel = width / 2 - pixelsPerItemSlot * inventoryWidth / 2;
    inventoryUpperLeftYPixel = height / 2 - pixelsPerItemSlot * inventoryHeight / 2;    
}
