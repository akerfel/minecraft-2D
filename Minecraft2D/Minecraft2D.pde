import java.util.HashMap;
import java.util.Iterator;

// Settings
int pixelsPerBlock;    // pixels per side of block
int blocksPerChunk;    // blocks per side of chunk
float playerWidth;
float baseChanceStone;
float baseChanceTree;
int gameSeed;
float mobSpaceChance;    // Chance each frame, so should be pretty low
int maxMobs;
int mobSpawnRange;    // In blocks
int mobDespawnRange;    // In blocks

// Game objects
HashMap<PVector, Chunk> generatedChunks;
Player player;
PVector currentChunkCoords; // Used to check if player has entered new chunk (shows new chunks around player)
Chunk[] visibleChunks;   
ArrayList<Mob> mobs; 

// Other
boolean rightMouseButtonDown;
boolean leftMouseButtonDown;

void setup() {
    size(1200, 1200);
    
    // Settings
    pixelsPerBlock = 25;
    blocksPerChunk = 40;
    resetObjectsDependingOnPixelsPerBlock();
    baseChanceStone = 0.05;
    baseChanceStone = 0.02;
    gameSeed = 1337;
    mobSpaceChance = 0.03; 
    maxMobs = 15;
    mobSpawnRange = blocksPerChunk / 2;
    mobDespawnRange = blocksPerChunk * 2;
    
    // Game objects
    generatedChunks = new HashMap<PVector, Chunk>();
    player = new Player(8020, 8020);
    currentChunkCoords = calcChunkCoords(player.coords);
    visibleChunks = new Chunk[9];
    initalLoadChunks();
    mobs = new ArrayList<Mob>();
    
    // Other
    rightMouseButtonDown = false;
    leftMouseButtonDown = false;
}

void draw() {
    updateLogic();
    drawEverything();
}
