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
int gameSeed;
float mobSpaceChance;    // Chance each frame, so should be pretty low
int maxMobs;
int mobSpawnRange;    // In blocks
int mobDespawnRange;    // In blocks
int viewDistance;      

// River stuff (atm)
float chanceTurningMode_Short = 0.05;
float chanceTurningMode_Long = 0.01;

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
    chanceRiver = 0.005;
    gameSeed = 1337;
    mobSpaceChance = 0.03; 
    maxMobs = 30;
    mobSpawnRange = 50;
    mobDespawnRange = 100;
    viewDistance = 120;
    
    // Game objects
    generatedChunks = new HashMap<PVector, Chunk>();
    player = new Player(8192, 8192);
    visibleBlocks = new Block[viewDistance][viewDistance];
    mobs = new ArrayList<Mob>();
    damagedBlocks = new ArrayList<Block>();
    loadVisibleBlocks();
    
    // Other
    rightMouseButtonDown = false;
    leftMouseButtonDown = false;
    
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
