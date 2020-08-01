import java.util.HashMap;

// Settings
int pixelsPerBlock;    // pixels per side of block
int blocksPerChunk;    // blocks per side of chunk
float chanceGrass;
int gameSeed;

// Game objects
HashMap<PVector, Chunk> generatedChunks;
Player player;
Chunk[] visibleChunks;   

void setup() {
    size(1200, 1200);
    
    // Settings
    pixelsPerBlock = 30;
    blocksPerChunk = 32;
    chanceGrass = 0.80;
    gameSeed = 1337;
    
    // Game objects
    generatedChunks = new HashMap<PVector, Chunk>();
    player = new Player(8192, 8192);
    loadVisibleChunks();
}

void draw() {
    updateLogic();
    drawEverything();
}
