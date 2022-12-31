import java.util.HashMap;
import java.util.Iterator;

// Cheats
boolean cheatWalkThroughWalls;

// Settings
int pixelsPerBlock;            // pixels per side of block
int blocksPerChunk;            // blocks per side of chunk
float playerWidth;             // in pixels
float mobWidth;
float baseChanceStone;
float baseChanceTree;
float chanceRiver;
float chanceForestChunk;
float chanceBigTreesChunk;
int worldSeed;
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

// Other
HashMap<PVector, Chunk> generatedChunks;
Player player;
Block[][] visibleBlocks;
ArrayList<Mob> mobs;
ArrayList<Block> damagedBlocks;
boolean rightMouseButtonDown;
boolean leftMouseButtonDown;
boolean A_isPressed, D_IsPressed, W_isPressed, S_isPressed;
boolean inventoryIsOpen;

// This function is called once, at startup
void setup() {
    size(1200, 1200);

    // Cheats
    cheatWalkThroughWalls = false;

    // Settings
    pixelsPerBlock = 25;
    blocksPerChunk = 512;
    resetObjectsDependingOnPixelsPerBlock();
    baseChanceStone = 0.005;
    baseChanceTree = 0.02;
    chanceRiver = 0.00004;
    chanceForestChunk = 0.17;
    chanceBigTreesChunk = 0.20;
    worldSeed = int(random(0, 100000000));
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
    

    // Other
    generatedChunks = new HashMap<PVector, Chunk>();
    player = new Player(1000000, 1000000);
    setViewDistance(viewDistance);
    mobs = new ArrayList<Mob>();
    damagedBlocks = new ArrayList<Block>();
    loadVisibleBlocks();
    makeViewDistanceFitZoomLevel();
    rightMouseButtonDown = false;
    leftMouseButtonDown = false;
    setPlayerBlock(new Grass());
    inventoryIsOpen = false;

    // Adding some items to the hotbar
    player.inventory.addItemToInventory(new Tool("iron", "sword"));
    player.inventory.addItemToInventory(new Tool("diamond", "pick"));
    player.inventory.addItemToInventory(new Tool("stone", "shovel"));
    player.inventory.addItemToInventory(new Tool("diamond", "axe"));
    player.inventory.addItemToInventory(new Dirt());
    player.inventory.addItemToInventory(new Sand());
    player.inventory.addItemToInventory(new Wood());
    player.inventory.addItemToInventory(new Planks());
    player.inventory.addItemToInventory(new Grass());
    player.inventory.addItemToInventory(new Leaves());
    
    // Adding some items to the inventory
    //player.addItemToInventory(new Tool("iron", "sword"), 1, 2);
    //player.addItemToInventory(new Dirt(), 3, 0);
    //player.addItemToInventory(new Dirt(), 3, 0);
    //player.addItemToInventory(new Dirt(), 3, 0);
}

// This function is called 60 times per second
void draw() {
    updateLogic();
    drawEverything();
}
