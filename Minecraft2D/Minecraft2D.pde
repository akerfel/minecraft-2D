import java.util.HashMap;

// Settings
int pixelsPerBlock;    // pixels per side of block
int blocksPerChunk;    // blocks per side of chunk
float playerWidth;
float baseChanceStone;
int gameSeed;

// Game objects
HashMap<PVector, Chunk> generatedChunks;
Player player;
PVector currentChunkCoords; // Used to check if player has entered new chunk (shows new chunks around player)
Chunk[] visibleChunks;   

// Other
boolean rightMouseButtonDown;
boolean leftMouseButtonDown;

void setup() {
    size(1200, 1200);
    
    // Settings
    pixelsPerBlock = 25;
    blocksPerChunk = 40;
    resetObjectsDependingOnPixelsPerBlock();
    baseChanceStone = 0.08;
    gameSeed = 1337;
    
    // Game objects
    generatedChunks = new HashMap<PVector, Chunk>();
    player = new Player(8004, 8004);
    currentChunkCoords = calcChunkCoords(player.coords);
    visibleChunks = new Chunk[9];
    initalLoadChunks();
    
    // Other
    rightMouseButtonDown = false;
    leftMouseButtonDown = false;
}

void draw() {
    updateLogic();
    drawEverything();
}
