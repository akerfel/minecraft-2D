void drawEverything() {
    background(0, 0, 0);
    drawVisibleBlocks();
    drawMobs();
    drawPlayer();
    drawHotbar();
}

void drawVisibleBlocks() {
    for (float x = 0; x < sightInBlocks; x++) {
        for (float y = 0; y < sightInBlocks; y++) {
            float xPos = width/2 + (x - sightInBlocks/2) * pixelsPerBlock;
            float yPos = height/2 + (y - sightInBlocks/2) * pixelsPerBlock;
            float xPlayerPixelOffset = (player.coords.x % 1) * pixelsPerBlock;
            float yPlayerPixelOffset = (player.coords.y % 1) * pixelsPerBlock;
            drawBlock(visibleBlocks[int(x)][int(y)], xPos - xPlayerPixelOffset, yPos - yPlayerPixelOffset);
        }
    }
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

void drawMobs() {
    for (Mob mob : mobs) {
        drawMob(mob);    
    }
}

void drawMob(Mob mob) {
    float xBlocksToPlayer = mob.coords.x - player.coords.x;
    float yBlocksToPlayer = mob.coords.y - player.coords.y;
    float x = width/2 + xBlocksToPlayer * pixelsPerBlock;
    float y = height/2 + yBlocksToPlayer * pixelsPerBlock;
    fill(mob.c);
    square(x, y, mobWidth);
}

/*
void drawMobsInChunk(Chunk chunk, float xStart, float yStart) {
    for (Mob mob : mobs) {
        if (getChunk(mob.coords) == chunk) {
            float xInChunk = mob.coords.x % blocksPerChunk;
            float yInChunk = mob.coords.y % blocksPerChunk;
            drawMob(mob, xStart + xInChunk * pixelsPerBlock, yStart + yInChunk * pixelsPerBlock);
        }
    }
}
*/

void drawPlayer() {
    fill(216, 127, 51);
    square(width/2, height/2, playerWidth);    
}

void drawHotbar() {
    rectMode(CENTER);
    int pixelsPerCell = 60;
    for (int i = 0; i < 9; i++) {
        drawHotbarCell(pixelsPerCell, i);
        
    }
    rectMode(CORNER);
}

void drawHotbarCell(int pixelsPerCell, int hotbarIndex) {
    if (hotbarIndex == player.hotbarIndexSelected) {
        fill(210, 210, 210);
    }
    else {
        fill(150, 150, 150);
    }
    int x = width/2 + (hotbarIndex - 4) * pixelsPerCell;
    int y = height - pixelsPerCell / 2;
    square(x, y, pixelsPerCell);
    drawItemInHotbar(x, y, hotbarIndex, pixelsPerCell);    
}

void drawItemInHotbar(int x,int y, int hotbarIndex, int pixelsPerCell) {
    Item item = player.hotbar[hotbarIndex].item;
    if (!(player.hotbar[hotbarIndex].amount == 0)) {
        switch (item.type) {
            case "block":
                drawBlockInHotbar(x, y, hotbarIndex, pixelsPerCell);
                break;
            case "tool":
                drawToolInHotbar(x, y, hotbarIndex, pixelsPerCell);
                break;
        }  
    }
}

void drawBlockInHotbar(int x,int y, int hotbarIndex, int pixelsPerCell) {
    Block block = (Block) player.hotbar[hotbarIndex].item;
    
    // Can not call drawBlock() function here, because that ones size changes with pixelsPerBlock
    fill(block.c);
    square(x, y, pixelsPerCell / 2);
    
    // Draw amount (text)
    textSize(24);
    textAlign(CENTER, BOTTOM);
    fill(255, 255, 255);
    text(player.hotbar[hotbarIndex].amount, x, height);
}

void drawToolInHotbar(int x,int y, int hotbarIndex, int pixelsPerCell) {
    Tool tool = (Tool) player.hotbar[hotbarIndex].item;
    
    fill(tool.c);
    circle(x, y, pixelsPerCell / 2);
    
    // Draw letter for tool type (Temporary solution, before I add specific images for tools) 
    textSize(20);
    textAlign(CENTER, BOTTOM);
    fill(255, 255, 255);
    text(tool.toolType, x, height);
}
