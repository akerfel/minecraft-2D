void drawUI() {
    drawInventoryIfOpen();
    drawHotbar();
    drawFPS();    
}

void drawFPS() {
  fill(220);
  text(int(frameRate), 20, 30); 
}

void drawInventoryIfOpen() {
    if (inventoryIsOpen) {
        stroke(0);
        for (int y = 0; y < inventoryHeight; y++) {
            for (int x = 0; x < inventoryWidth; x++) {
                ItemSlot itemSlot = player.inventory.grid[x][y];
                int xPixel = inventoryUpperLeftXPixel + x * pixelsPerItemSlot;
                int yPixel = inventoryUpperLeftYPixel + y * pixelsPerItemSlot;
                drawItemSlot(itemSlot, xPixel, yPixel, false);
            }
        }
        if (noStrokeMode) {
            noStroke();   
        }
    }
}

// This function is similar to drawInventoryIfOpen, except the y coordinate is fixed,
// and the currently selected hotbar slot will be highlighted.
void drawHotbar() {
    stroke(0);
    int yPixel = height - pixelsPerItemSlot;
    for (int x = 0; x < inventoryWidth; x++) {
        int xPixel = inventoryUpperLeftXPixel + x * pixelsPerItemSlot;
        ItemSlot itemSlot = player.inventory.getHotbarSlot(x);
        boolean highlightBackground = false;
        if (x == player.inventory.hotbarIndexSelected) {
            highlightBackground = true;
        }
        drawItemSlot(itemSlot, xPixel, yPixel, highlightBackground);
    }
    if (noStrokeMode) {
        noStroke();   
    }
}

void drawMouseItemSlot() {
    stroke(0);
    if (player.inventory.mouseHeldItemSlot.amount != 0) {
        drawItemInItemSlot(player.inventory.mouseHeldItemSlot, mouseX, mouseY);
    }
    if (noStrokeMode) {
        noStroke();   
    }
}

// Draws an itemSlot with center at (xPixel, yPixel)
void drawItemSlot(ItemSlot itemSlot, int xPixel, int yPixel, boolean highlightBackground) {
    drawItemSlotBackground(xPixel, yPixel, highlightBackground);
    // We will specifiy the center of each itemSlot
    int xPixelCenterOfItemSlot = xPixel + pixelsPerItemSlot / 2;
    int yPixelCenterOfItemSlot = yPixel + pixelsPerItemSlot / 2;
    drawItemInItemSlot(itemSlot, xPixelCenterOfItemSlot, yPixelCenterOfItemSlot);
}

void drawItemSlotBackground(int xPixel, int yPixel, boolean highlightBackground) {
    fill(150, 150, 150);    
    if (highlightBackground) {
        fill(210, 210, 210);
    }
    square(xPixel, yPixel, pixelsPerItemSlot);    
}

// (xPixel, yPixel) should be the center of the drawn Item.
void drawItemInItemSlot(ItemSlot itemSlot, int xPixel, int yPixel) {
    rectMode(CENTER);
    Item item = itemSlot.item;
    if (itemSlot.amount != 0) {
        switch (item.type) {
            case "block":
                drawBlockInItemSlot(itemSlot, xPixel, yPixel);
                break;
            case "tool":
                drawToolInItemSlot(itemSlot, xPixel, yPixel);
                break;
        }
    }
    rectMode(CORNER);
}

void drawBlockInItemSlot(ItemSlot itemSlot, int xPixel, int yPixel) {
    rectMode(CENTER);
    Block block = (Block) itemSlot.item;
    
    // Can not call drawBlock() function here, because that ones size changes with pixelsPerBlock
    fill(block.c);
    square(xPixel, yPixel, pixelsPerItemSlot / 2);
    
    // Write amount
    textSize(24);
    textAlign(CENTER, BOTTOM);
    fill(255, 255, 255);
    text(itemSlot.amount, xPixel, yPixel);
    rectMode(CORNER);
    
    // Write tool name (temporary solution, until specific images for tools are added) 
    textSize(20);
    textAlign(CENTER, BOTTOM);
    fill(255, 255, 255);
    text(block.toString(), xPixel, yPixel + pixelsPerItemSlot / 2);
    rectMode(CORNER);
}

void drawToolInItemSlot(ItemSlot itemSlot, int xPixel, int yPixel) {
    rectMode(CENTER);
    Tool tool = (Tool) itemSlot.item;
    
    fill(tool.c);
    circle(xPixel, yPixel, pixelsPerItemSlot / 2);
    
    textSize(20);
    textAlign(CENTER, BOTTOM);
    fill(255, 255, 255);
    text(tool.toolType, xPixel, yPixel + pixelsPerItemSlot / 2);
    rectMode(CORNER);
}
