import java.util.HashMap;

int gameSeed;
//HashMap<PVector, Chunk> visibleChunks = new HashMap<>();
float chanceGrass;
Chunk[] visibleChunks;    // atm just one, later will be at least 9
int pixelsPerBlock;    // pixels per side of block
HashMap<PVector, Chunk> generatedChunks;
Player player;
int blocksPerChunk;

void setup() {
    size(1200, 1200);
    blocksPerChunk = 32;
    chanceGrass = 0.80;
    pixelsPerBlock = 12;
    generatedChunks = new HashMap<PVector, Chunk>();
    player = new Player(1024 + blocksPerChunk / 2, 1024 + blocksPerChunk / 2);
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
    
    int pixelsPerChunk = pixelsPerBlock * blocksPerChunk;
    
    // "x and y" = pixel position of upper left corner of chunk
    // The start positions of all chunks are calculated in relation to the middle chunks start position
    int xCenterChunk = width / 2 - xPlayerOffset * pixelsPerBlock;
    int yCenterChunk = height / 2 - yPlayerOffset * pixelsPerBlock;
    
    // North chunk
    int xNorthChunk = xCenterChunk; 
    int yNorthChunk = yCenterChunk - pixelsPerChunk;
    
    // South chunk
    int xSouthChunk = xCenterChunk; 
    int ySouthChunk = yCenterChunk + pixelsPerChunk;
    
    // West chunk
    int xWestChunk = xCenterChunk - pixelsPerChunk;
    int yWestChunk = yCenterChunk;
    
    // East chunk
    int xEastChunk = xCenterChunk + pixelsPerChunk;
    int yEastChunk = yCenterChunk;
    
    // Northwest chunk
    int xNorthWestChunk = xWestChunk;
    int yNorthWestChunk = yNorthChunk;
    
    // Northeast chunk
    int xNorthEastChunk = xEastChunk;
    int yNorthEastChunk = yNorthChunk;
    
    // Southwest chunk
    int xSouthWestChunk = xWestChunk;
    int ySouthWestChunk = ySouthChunk;
    
    // Southeast chunk
    int xSouthEastChunk = xEastChunk;
    int ySouthEastChunk = ySouthChunk;
    
    // Draw upper row of chunks
    drawChunk(visibleChunks[0], xNorthWestChunk, yNorthWestChunk);
    drawChunk(visibleChunks[1], xNorthChunk, yNorthChunk);
    drawChunk(visibleChunks[2], xNorthEastChunk, yNorthEastChunk);
    
    // Draw middle row of chunks
    drawChunk(visibleChunks[3], xWestChunk, yWestChunk);
    drawChunk(visibleChunks[4], xCenterChunk, yCenterChunk);
    drawChunk(visibleChunks[5], xEastChunk, yEastChunk);
    
    // Draw lower row of chunks
    drawChunk(visibleChunks[6], xSouthWestChunk, ySouthWestChunk);
    drawChunk(visibleChunks[7], xSouthChunk, ySouthChunk);
    drawChunk(visibleChunks[8], xSouthEastChunk, ySouthEastChunk);
    
}

void drawChunk(Chunk chunk, int xStart, int yStart) {
    for (int i = 0; i < blocksPerChunk; i++) {
        for (int j = 0; j < blocksPerChunk; j++) {
            drawBlock(chunk.blocks[i][j], xStart + i * pixelsPerBlock, yStart + j * pixelsPerBlock);
        }
    }
}

void drawBlock(Block block, int x, int y) {
    fill(block.c);
    square(x, y, pixelsPerBlock);
}

// OLD ONE
void drawChunk(Chunk chunk, int xChunkOffset, int yChunkOffset, int xPlayerOffset, int yPlayerOffset) {
    int pixelWidthChunk = pixelsPerBlock * blocksPerChunk;
    
    int xUpperLeftCornerMiddleChunk = width / 2 - pixelWidthChunk / 2;
    int yUpperLeftCornerMiddleChunk = height / 2 - pixelWidthChunk / 2;
    
    for (int i = 0; i < blocksPerChunk; i++) {
        for (int j = 0; j < blocksPerChunk; j++) {
            fill(chunk.blocks[i][j].c);
            square(pixelsPerBlock * (8 + xChunkOffset * blocksPerChunk + i - xPlayerOffset), pixelsPerBlock * (8 + yChunkOffset * blocksPerChunk  + j - yPlayerOffset), pixelsPerBlock);
        }
    }
}

void drawPlayer() {
    fill(216, 127, 51);
    square(width/2 + pixelsPerBlock / 4, height/2 + pixelsPerBlock / 4, pixelsPerBlock / 2);    
}
