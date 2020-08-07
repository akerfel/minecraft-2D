void drawEverything() {
    background(0, 0, 0);
    drawVisibleChunks();    
    drawPlayer();
    drawHotbar();
}

// Draws the 9 curretly visible chunks, and the mobs inside them
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

// Draws a chunk, and the mobs inside it
// xStart and yStart are the exact pixel that the chunks should be started drawing at (the "reference point")
void drawChunk(Chunk chunk, float xStart, float yStart) {
    for (int i = 0; i < blocksPerChunk; i++) {
        for (int j = 0; j < blocksPerChunk; j++) {
            drawBlock(chunk.blocks[i][j], xStart + i * pixelsPerBlock, yStart + j * pixelsPerBlock);
        }
    }
    
    drawMobsInChunk(chunk, xStart, yStart);
}

void drawBlock(Block block, float x, float y) {
    fill(block.c);
    square(x, y, pixelsPerBlock);
    if (block.prcntBroken > 0) {
        drawBlockBreakingTexture(block, x, y);
    }
}

void drawBlockBreakingTexture(Block block, float x, float y) {
    fill(block.prcntBroken * 255);
    circle(x + pixelsPerBlock/2, y + pixelsPerBlock/2, (block.prcntBroken * pixelsPerBlock));
}

void drawMobsInChunk(Chunk chunk, float xStart, float yStart) {
    for (Mob mob : mobs) {
        if (getChunk(mob.coords) == chunk) {
            float xInChunk = mob.coords.x % blocksPerChunk;
            float yInChunk = mob.coords.y % blocksPerChunk;
            drawMob(mob, xStart + xInChunk * pixelsPerBlock, yStart + yInChunk * pixelsPerBlock);
        }
    }
}

void drawMob(Mob mob, float x, float y) {
    fill(mob.c);
    square(x, y, mobWidth);
}

void drawPlayer() {
    fill(216, 127, 51);
    square(width/2, height/2, playerWidth);    
}

void drawHotbar() {
    rectMode(CENTER);
    int pixelsPerCell = 60;
    for (int i = 0; i < 9; i++) {
        if (i == player.hotbarCellSelected) {
            fill(210, 210, 210);
        }
        else {
            fill(150, 150, 150);
        }
        int x = width/2 + (i - 4) * pixelsPerCell;
        int y = height - pixelsPerCell / 2;
        square(x, y, pixelsPerCell);
        if (!(player.hotbar[i].amount == 0)) {
            
            // Can not call drawBlock() function here, because that ones size changes with pixelsPerBlock
            fill(player.hotbar[i].block.c);
            square(x, y, pixelsPerCell / 2);
            
            // Draw amount (text)
            textSize(24);
            textAlign(CENTER, BOTTOM);
            fill(255, 255, 255);
            text(player.hotbar[i].amount, x, height);
        }
    }
    rectMode(CORNER);
}
