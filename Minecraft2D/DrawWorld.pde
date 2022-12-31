void drawWorld() {
    drawVisibleBlocks();
    drawMobs();
    drawPlayer();    
}

void drawVisibleBlocks() {
    // xPixels and yPixels store the top left corner pixel positions of each block
    float[] xPixels = new float[viewDistance];
    float[] yPixels = new float[viewDistance];
    float xPlayerPixelOffset = (state.player.coords.x % 1) * pixelsPerBlock;
    float yPlayerPixelOffset = (state.player.coords.y % 1) * pixelsPerBlock;
    for (float i = 0; i < viewDistance; i++) {
        float xPos = width/2 + (i - viewDistance/2) * pixelsPerBlock;
        float yPos = height/2 + (i - viewDistance/2) * pixelsPerBlock;
        xPixels[int(i)] = xPos - xPlayerPixelOffset;
        yPixels[int(i)] = yPos - yPlayerPixelOffset;
    }
            
    for (int y = 0; y < viewDistance; y++) {
        for (int x = 0; x < viewDistance; x++) {
            drawBlock(state.visibleBlocks[int(x)][int(y)], xPixels[x], yPixels[y]);
        }
    }
}

void drawBlock(Block block, float xPixel, float yPixel) {
    fill(block.c);
    square(xPixel, yPixel, pixelsPerBlock + 1);
    if (block.prcntBroken > 0) {
        drawBlockBreakingTexture(block, xPixel, yPixel);
    }
}

void drawBlockBreakingTexture(Block block, float xPixel, float yPixel) {
    fill(block.prcntBroken * 255);
    circle(xPixel + pixelsPerBlock/2, yPixel + pixelsPerBlock/2, (block.prcntBroken * pixelsPerBlock));
}

void drawMobs() {
    for (Mob mob : state.mobs) {
        drawMob(mob);    
    }
}

void drawMob(Mob mob) {
    float xBlocksToPlayer = mob.coords.x - state.player.coords.x;
    float yBlocksToPlayer = mob.coords.y - state.player.coords.y;
    float x = width/2 + xBlocksToPlayer * pixelsPerBlock;
    float y = height/2 + yBlocksToPlayer * pixelsPerBlock;
    fill(mob.c);
    square(x, y, mobWidth);
}

void drawPlayer() {
    fill(216, 127, 51);
    square(width/2, height/2, playerWidth);    
}
