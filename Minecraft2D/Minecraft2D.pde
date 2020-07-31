import java.util.HashMap;

int gameSeed;
//HashMap<PVector, Chunk> visibleChunks = new HashMap<>();
float chanceGrass;
Chunk[] visibleChunks;    // atm just one, later will be at least 9
int pixelCount;    // pixels per side of block
HashMap<PVector, Chunk> generatedChunks;
Player player;
int blocksPerChunk;

void setup() {
    size(1200, 1200);
    blocksPerChunk = 16;
    chanceGrass = 0.80;
    pixelCount = 25;
    generatedChunks = new HashMap<PVector, Chunk>();
    player = new Player(1024, 1024);
    gameSeed = 1000000;
    loadInitalVisibleChunks();
}

void loadInitalVisibleChunks() {
    visibleChunks = new Chunk[9];
    println(new PVector(int(player.coords.x / blocksPerChunk), int(player.coords.y / blocksPerChunk)));
    // Top row
    visibleChunks[0] = getChunkForPlayerCoords(new PVector(player.coords.x - blocksPerChunk, player.coords.y - blocksPerChunk));
    visibleChunks[1] = getChunkForPlayerCoords(new PVector(player.coords.x, player.coords.y - blocksPerChunk));
    visibleChunks[2] = getChunkForPlayerCoords(new PVector(player.coords.x + blocksPerChunk, player.coords.y - blocksPerChunk));
    
    // Middle row
    visibleChunks[3] = getChunkForPlayerCoords(new PVector(player.coords.x - blocksPerChunk, player.coords.y));
    visibleChunks[4] = getChunkForPlayerCoords(new PVector(player.coords.x, player.coords.y));
    visibleChunks[5] = getChunkForPlayerCoords(new PVector(player.coords.x + blocksPerChunk, player.coords.y));
    
    // Bottom row
    visibleChunks[6] = getChunkForPlayerCoords(new PVector(player.coords.x - blocksPerChunk, player.coords.y + blocksPerChunk));
    visibleChunks[7] = getChunkForPlayerCoords(new PVector(player.coords.x, player.coords.y + blocksPerChunk));
    visibleChunks[8] = getChunkForPlayerCoords(new PVector(player.coords.x + blocksPerChunk, player.coords.y + blocksPerChunk));
}



Chunk getChunkForPlayerCoords(PVector playerCoords) {
    PVector chunkCoords = new PVector(int(playerCoords.x / blocksPerChunk), int(playerCoords.y / blocksPerChunk));
    // The next two if statements ensure that the same chunk wont be loaded
    // for playerCoords [0, 0] and [0, -1].
    if (playerCoords.x < 0) {
        chunkCoords.x--;    
    }
    if (playerCoords.y < 0) {
        chunkCoords.y--;    
    }
    if (!generatedChunks.containsKey(chunkCoords)) {
        generatedChunks.put(chunkCoords, new Chunk(chunkCoords));
    }
    return generatedChunks.get(chunkCoords);
}

void draw() {
    background(0, 0, 0);
    drawVisibleChunks();
    drawPlayer();
}

void drawVisibleChunks() {
    
    int xPlayerOffset = int(player.coords.x) % blocksPerChunk;
    int yPlayerOffset = int(player.coords.y) % blocksPerChunk;
    
    // Top row
    drawChunk(visibleChunks[0], 0, 0, xPlayerOffset, yPlayerOffset);
    drawChunk(visibleChunks[1], 1, 0, xPlayerOffset, yPlayerOffset);
    drawChunk(visibleChunks[2], 2, 0, xPlayerOffset, yPlayerOffset);
    
    // Middle row
    drawChunk(visibleChunks[3], 0, 1, xPlayerOffset, yPlayerOffset);
    drawChunk(visibleChunks[4], 1, 1, xPlayerOffset, yPlayerOffset);
    drawChunk(visibleChunks[5], 2, 1, xPlayerOffset, yPlayerOffset);
    
    // Bottom row
    drawChunk(visibleChunks[6], 0, 2, xPlayerOffset, yPlayerOffset);
    drawChunk(visibleChunks[7], 1, 2, xPlayerOffset, yPlayerOffset);
    drawChunk(visibleChunks[8], 2, 2, xPlayerOffset, yPlayerOffset);
}

void drawChunk(Chunk chunk, int xChunkOffset, int yChunkOffset, int xPlayerOffset, int yPlayerOffset) {
    
    for (int i = 0; i < blocksPerChunk; i++) {
        for (int j = 0; j < blocksPerChunk; j++) {
            fill(chunk.blocks[i][j].c);
            square(pixelCount * (8 + xChunkOffset * blocksPerChunk + i - xPlayerOffset), pixelCount * (8 + yChunkOffset * blocksPerChunk  + j - yPlayerOffset), pixelCount);
        }
    }
}

void drawPlayer() {
    fill(216, 127, 51);
    square(width/2 + pixelCount / 4, height/2 + pixelCount / 4, pixelCount / 2);    
}
