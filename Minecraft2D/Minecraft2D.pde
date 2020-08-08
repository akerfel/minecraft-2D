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
int gameSeed;
float mobSpaceChance;    // Chance each frame, so should be pretty low
int maxMobs;
int mobSpawnRange;    // In blocks
int mobDespawnRange;    // In blocks
int sightInBlocks;      

// Game objects
boolean needToReloadVisibleBlocks;
HashMap<PVector, Chunk> generatedChunks;
Player player;
PVector currentChunkCoords; // Used to check if player has entered new chunk (shows new chunks around player)
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
    blocksPerChunk = 500;
    resetObjectsDependingOnPixelsPerBlock();
    baseChanceStone = 0.005;
    baseChanceTree = 0.02;
    gameSeed = 1337;
    mobSpaceChance = 0.03; 
    maxMobs = 30;
    mobSpawnRange = 50;
    mobDespawnRange = 100;
    sightInBlocks = 120;
    
    // Game objects
    needToReloadVisibleBlocks = true;
    generatedChunks = new HashMap<PVector, Chunk>();
    player = new Player(8020, 8020);
    currentChunkCoords = calcChunkCoords(player.coords);
    visibleBlocks = new Block[sightInBlocks][sightInBlocks];
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
