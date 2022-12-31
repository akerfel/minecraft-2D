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
        rectMode(CENTER);
        for (int y = 0; y < inventoryHeight; y++) {
            for (int x = 0; x < inventoryWidth; x++) {
                ItemSlot itemSlot = player.inventory[x][y];
                int xPixel = width / 2 + (x - 4) * pixelsPerItemSlot;
                int yPixel = height / 2 + (y - inventoryHeight / 2) * pixelsPerItemSlot;
                drawItemSlot(itemSlot, xPixel, yPixel, false);
            }
        }
        rectMode(CORNER);
        if (noStrokeMode) {
            noStroke();   
        }
    }
}

// This function is similar to drawInventoryIfOpen, except the y coordinate is fixed,
// and the currently selected hotbar slot will be highlighted.
void drawHotbar() {
    stroke(0);
    rectMode(CENTER);
    int yPixel = height - pixelsPerItemSlot / 2;
    for (int x = 0; x < inventoryWidth; x++) {
        int xPixel = width / 2 + (x - 4) * pixelsPerItemSlot;
        ItemSlot itemSlot = player.getHotbarSlot(x);
        boolean highlightBackground = false;
        if (x == player.hotbarIndexSelected) {
            highlightBackground = true;
        }
        drawItemSlot(itemSlot, xPixel, yPixel, highlightBackground);
    }
    rectMode(CORNER);
    if (noStrokeMode) {
        noStroke();   
    }
}

// Draws an itemSlot with center at (xPixel, yPixel)
void drawItemSlot(ItemSlot itemSlot, int xPixel, int yPixel, boolean highlightBackground) {
    drawItemSlotBackground(xPixel, yPixel, highlightBackground);
    drawItemInItemSlot(itemSlot, xPixel, yPixel);
}

void drawItemSlotBackground(int xPixel, int yPixel, boolean highlightBackground) {
    fill(150, 150, 150);    
    if (highlightBackground) {
        fill(210, 210, 210);
    }
    square(xPixel, yPixel, pixelsPerItemSlot);    
}

void drawItemInItemSlot(ItemSlot itemSlot, int xPixel, int yPixel) {
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
}

void drawBlockInItemSlot(ItemSlot itemSlot, int xPixel, int yPixel) {
    Block block = (Block) itemSlot.item;
    
    // Can not call drawBlock() function here, because that ones size changes with pixelsPerBlock
    fill(block.c);
    square(xPixel, yPixel, pixelsPerItemSlot / 2);
    
    // Write amount
    textSize(24);
    textAlign(CENTER, BOTTOM);
    fill(255, 255, 255);
    text(itemSlot.amount, xPixel, yPixel + pixelsPerItemSlot / 2);
}

void drawToolInItemSlot(ItemSlot itemSlot, int xPixel, int yPixel) {
    Tool tool = (Tool) itemSlot.item;
    
    fill(tool.c);
    circle(xPixel, yPixel, pixelsPerItemSlot / 2);
    
    // Write tool name (temporary solution, until specific images for tools are added) 
    textSize(20);
    textAlign(CENTER, BOTTOM);
    fill(255, 255, 255);
    text(tool.toolType, xPixel, yPixel + pixelsPerItemSlot / 2);
}
