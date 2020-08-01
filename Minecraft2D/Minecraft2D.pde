import java.util.HashMap;

// Settings
int pixelsPerBlock;    // pixels per side of block
int blocksPerChunk;    // blocks per side of chunk
float playerWidth;
float chanceGrass;
int gameSeed;


// Game objects
HashMap<PVector, Chunk> generatedChunks;
Player player;
Chunk[] visibleChunks;   

// Other
PVector currentChunkCoords;

void setup() {
    size(1200, 1200);
    
    // Settings
    pixelsPerBlock = 32;
    blocksPerChunk = 32;
    playerWidth = pixelsPerBlock / 2;
    chanceGrass = 0.80;
    gameSeed = 1337;
    
    // Other
    
    
    // Game objects
    generatedChunks = new HashMap<PVector, Chunk>();
    player = new Player(8000, 8000);
    currentChunkCoords = calcChunkCoords(player.coords);
    visibleChunks = new Chunk[9];
    initalLoadChunks();
}

void draw() {
    updateLogic();
    drawEverything();
}
