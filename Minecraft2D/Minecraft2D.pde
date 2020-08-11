import java.util.HashMap;
import java.util.Iterator;

// Cheats
boolean cheatWalkThroughWalls;

// Settings
int pixelsPerBlock;    // pixels per side of block
int blocksPerChunk;    // blocks per side of chunk
float playerWidth;     // in pixels
float mobWidth;
float baseChanceStone;
float baseChanceTree;
float chanceRiver;
float chanceForestChunk;
int gameSeed;
float mobSpaceChance;    // Chance each frame, so should be pretty low
int maxMobs;
int mobSpawnRange;    // In blocks
int mobDespawnRange;    // In blocks
int viewDistance;      
boolean noStrokeMode;    // Setting this to false HALVES FPS (!), and makes things uglier. Keep it at true.

// Game objects
HashMap<PVector, Chunk> generatedChunks;
Player player;
Block[][] visibleBlocks;
ArrayList<Mob> mobs; 
ArrayList<Block> damagedBlocks;

// Other
boolean rightMouseButtonDown;
boolean leftMouseButtonDown;

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
    chanceForestChunk = 0.3;
    gameSeed = int(random(0, 100000000));
    mobSpaceChance = 0.03; 
    maxMobs = 30;
    mobSpawnRange = 50;
    mobDespawnRange = 100;
    viewDistance = 250;
    noStrokeMode = true;
    settingsSetup();
    
    // Game objects
    generatedChunks = new HashMap<PVector, Chunk>();
    player = new Player(1000000, 1000000);
    setViewDistance(viewDistance);
    mobs = new ArrayList<Mob>();
    damagedBlocks = new ArrayList<Block>();
    loadVisibleBlocks();
    makeViewDistanceFitZoomLevel();
    
    // Other
    rightMouseButtonDown = false;
    leftMouseButtonDown = false;
    setPlayerBlock(new Grass());
    
    // Testing atm
    player.addItemToInventory(new Tool("iron", "sword"));
    player.addItemToInventory(new Tool("diamond", "pick"));
    player.addItemToInventory(new Tool("stone", "shovel"));
    player.addItemToInventory(new Tool("diamond", "axe"));
}

void draw() {
    updateLogic();
    drawEverything();
}
