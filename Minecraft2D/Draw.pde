

void drawEverything() {
    background(0, 0, 0);
    drawVisibleBlocks();
    drawMobs();
    drawPlayer();
    drawHotbar();
    drawInventory();
    drawFPS();
}

void drawFPS() {
  fill(220);
  text(int(frameRate), 20, 30); 
}

void drawInventory() {
    
}

void drawVisibleBlocks() {
    // xPixels and yPixels store the top left corner pixel positions of each block
    float[] xPixels = new float[viewDistance];
    float[] yPixels = new float[viewDistance];
    float xPlayerPixelOffset = (player.coords.x % 1) * pixelsPerBlock;
    float yPlayerPixelOffset = (player.coords.y % 1) * pixelsPerBlock;
    for (float i = 0; i < viewDistance; i++) {
        // x
        float xPos = width/2 + (i - viewDistance/2) * pixelsPerBlock;
        xPixels[int(i)] = xPos - xPlayerPixelOffset;
        // y
        float yPos = height/2 + (i - viewDistance/2) * pixelsPerBlock;
        yPixels[int(i)] = yPos - yPlayerPixelOffset;
    }
            
    for (int y = 0; y < viewDistance; y++) {
        for (int x = 0; x < viewDistance; x++) {
            drawBlock(visibleBlocks[int(x)][int(y)], xPixels[x], yPixels[y]);
        }
    }
}

void drawBlock(Block block, float x, float y) {
    fill(block.c);
    square(x, y, pixelsPerBlock + 1);
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

void drawPlayer() {
    fill(216, 127, 51);
    square(width/2, height/2, playerWidth);    
}

void drawHotbar() {
    stroke(0);
    rectMode(CENTER);
    for (int i = 0; i < 9; i++) {
        drawItemSlotInHotbar(i);
        
    }
    rectMode(CORNER);
    if (noStrokeMode) {
        noStroke();   
    }
}

void drawItemSlotInHotbar(int hotbarIndex) {
    if (hotbarIndex == player.hotbarIndexSelected) {
        fill(210, 210, 210);
    }
    else {
        fill(150, 150, 150);
    }
    int x = width/2 + (hotbarIndex - 4) * pixelsPerItemSlot;
    int y = height - pixelsPerItemSlot / 2;
    square(x, y, pixelsPerItemSlot);
    drawItemInHotbar(x, y, hotbarIndex, pixelsPerItemSlot);    
}

void drawItemInHotbar(int x, int y, int hotbarIndex, int pixelsPerItemSlot) {
    Item item = player.hotbar[hotbarIndex].item;
    if (!(player.hotbar[hotbarIndex].amount == 0)) {
        switch (item.type) {
            case "block":
                drawBlockInHotbar(x, y, hotbarIndex, pixelsPerItemSlot);
                break;
            case "tool":
                drawToolInHotbar(x, y, hotbarIndex, pixelsPerItemSlot);
                break;
        }  
    }
}

void drawBlockInHotbar(int x,int y, int hotbarIndex, int pixelsPerItemSlot) {
    Block block = (Block) player.hotbar[hotbarIndex].item;
    
    // Can not call drawBlock() function here, because that ones size changes with pixelsPerBlock
    fill(block.c);
    square(x, y, pixelsPerItemSlot / 2);
    
    // Draw amount (text)
    textSize(24);
    textAlign(CENTER, BOTTOM);
    fill(255, 255, 255);
    text(player.hotbar[hotbarIndex].amount, x, height);
}

void drawToolInHotbar(int x,int y, int hotbarIndex, int pixelsPerItemSlot) {
    Tool tool = (Tool) player.hotbar[hotbarIndex].item;
    
    fill(tool.c);
    circle(x, y, pixelsPerItemSlot / 2);
    
    // Draw letter for tool type (Temporary solution, before I add specific images for tools) 
    textSize(20);
    textAlign(CENTER, BOTTOM);
    fill(255, 255, 255);
    text(tool.toolType, x, height);
}
