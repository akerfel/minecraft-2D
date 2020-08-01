void drawEverything() {
    background(0, 0, 0);
    drawVisibleChunks();
    drawPlayer();
}

void drawVisibleChunks() {
    float xPlayerOffset = player.coords.x % blocksPerChunk;
    float yPlayerOffset = player.coords.y % blocksPerChunk;
    
    float pixelsPerChunk = pixelsPerBlock * blocksPerChunk;
    
    // "x and y" = pixel position of upper left corner of chunk
    // The start positions of all chunks are calculated in relation to the middle chunks start position
    float xCenterChunk = width / 2 - xPlayerOffset * pixelsPerBlock;
    float yCenterChunk = height / 2 - yPlayerOffset * pixelsPerBlock;
    
    // North chunk
    float xNorthChunk = xCenterChunk; 
    float yNorthChunk = yCenterChunk - pixelsPerChunk;
    
    // South chunk
    float xSouthChunk = xCenterChunk; 
    float ySouthChunk = yCenterChunk + pixelsPerChunk;
    
    // West chunk
    float xWestChunk = xCenterChunk - pixelsPerChunk;
    float yWestChunk = yCenterChunk;
    
    // East chunk
    float xEastChunk = xCenterChunk + pixelsPerChunk;
    float yEastChunk = yCenterChunk;
    
    // Northwest chunk
    float xNorthWestChunk = xWestChunk;
    float yNorthWestChunk = yNorthChunk;
    
    // Northeast chunk
    float xNorthEastChunk = xEastChunk;
    float yNorthEastChunk = yNorthChunk;
    
    // Southwest chunk
    float xSouthWestChunk = xWestChunk;
    float ySouthWestChunk = ySouthChunk;
    
    // Southeast chunk
    float xSouthEastChunk = xEastChunk;
    float ySouthEastChunk = ySouthChunk;
    
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

void drawChunk(Chunk chunk, float xStart, float yStart) {
    for (int i = 0; i < blocksPerChunk; i++) {
        for (int j = 0; j < blocksPerChunk; j++) {
            drawBlock(chunk.blocks[i][j], xStart + i * pixelsPerBlock, yStart + j * pixelsPerBlock);
        }
    }
}

void drawBlock(Block block, float x, float y) {
    fill(block.c);
    square(x, y, pixelsPerBlock);
}

void drawPlayer() {
    fill(216, 127, 51);
    square(width/2 + pixelsPerBlock / 4, height/2 + pixelsPerBlock / 4, pixelsPerBlock / 2);    
}
