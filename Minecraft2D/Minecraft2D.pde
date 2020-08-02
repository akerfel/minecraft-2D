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

void setup() {
    size(1200, 1200);
    
    // Settings
    pixelsPerBlock = 16;
    blocksPerChunk = 16;
    playerWidth = pixelsPerBlock / 2;
    baseChanceStone = 0.08;
    gameSeed = 1337;
    
    // Game objects
    generatedChunks = new HashMap<PVector, Chunk>();
    player = new Player(8004, 8004);
    currentChunkCoords = calcChunkCoords(player.coords);
    visibleChunks = new Chunk[9];
    initalLoadChunks();
}

void draw() {
    updateLogic();
    drawEverything();
}
