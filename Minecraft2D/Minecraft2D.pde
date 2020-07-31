import java.util.HashMap;

int gameSeed;
//HashMap<PVector, Chunk> visibleChunks = new HashMap<>();
float chanceGrass;
Chunk[] visibleChunks;    // atm just one, later will be at least 9
int pixelCount;    // pixels per side of block
HashMap<PVector, Chunk> generatedChunks;
Player player;

void setup() {
    size(1000, 1000);
    chanceGrass = 0.80;
    pixelCount = 10;
    generatedChunks = new HashMap<PVector, Chunk>();
    player = new Player(4, 4);
    gameSeed = 1000000;
    loadInitalVisibleChunks();
}

void loadInitalVisibleChunks() {
    visibleChunks = new Chunk[9];
    
    // Top row
    visibleChunks[0] = getChunkForPlayerCoords(new PVector(player.coords.x - 16, player.coords.y - 16));
    visibleChunks[1] = getChunkForPlayerCoords(new PVector(player.coords.x, player.coords.y - 16));
    visibleChunks[2] = getChunkForPlayerCoords(new PVector(player.coords.x + 16, player.coords.y - 16));
    
    // Middle row
    visibleChunks[3] = getChunkForPlayerCoords(new PVector(player.coords.x - 16, player.coords.y));
    visibleChunks[4] = getChunkForPlayerCoords(new PVector(player.coords.x, player.coords.y));
    visibleChunks[5] = getChunkForPlayerCoords(new PVector(player.coords.x + 16, player.coords.y));
    
    // Bottom row
    visibleChunks[6] = getChunkForPlayerCoords(new PVector(player.coords.x - 16, player.coords.y + 16));
    visibleChunks[7] = getChunkForPlayerCoords(new PVector(player.coords.x, player.coords.y + 16));
    visibleChunks[8] = getChunkForPlayerCoords(new PVector(player.coords.x + 16, player.coords.y + 16));
}



Chunk getChunkForPlayerCoords(PVector playerCoords) {
    PVector chunkCoords = new PVector(int(playerCoords.x / 16), int(playerCoords.y / 16));
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
    // Top row
    drawChunk(visibleChunks[0], 0, 0);
    drawChunk(visibleChunks[1], 1, 0);
    drawChunk(visibleChunks[2], 2, 0);
    
    // Middle row
    drawChunk(visibleChunks[3], 0, 1);
    drawChunk(visibleChunks[4], 1, 1);
    drawChunk(visibleChunks[5], 2, 1);
    
    // Bottom row
    drawChunk(visibleChunks[6], 0, 2);
    drawChunk(visibleChunks[7], 1, 2);
    drawChunk(visibleChunks[8], 2, 2);
}

void drawChunk(Chunk chunk, int xChunkOffset, int yChunkOffset) {
    for (int i = 0; i < 16; i++) {
        for (int j = 0; j < 16; j++) {
            fill(chunk.blocks[i][j].c);
            square(xChunkOffset * pixelCount * 16 + i * pixelCount, yChunkOffset * pixelCount * 16  + j * pixelCount, pixelCount);
        }
    }
}

void drawPlayer() {
    rectMode(CENTER);
    fill(216, 127, 51);
    square(width/2, height/2, pixelCount / 2);    
    rectMode(CORNER);
}
