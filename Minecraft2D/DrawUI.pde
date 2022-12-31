void drawFPS() {
  fill(220);
  text(int(frameRate), 20, 30); 
}

void drawInventory() {
    if (inventoryIsOpen) {
        stroke(0);
        rectMode(CENTER);
        for (int y = 0; y < inventoryHeight; y++) {
            for (int x = 0; x < inventoryWidth; x++) {
                drawItemSlotInInventory(x, y);
            }
        }
        rectMode(CORNER);
        if (noStrokeMode) {
            noStroke();   
        }
    }
}

void drawItemSlotInInventory(int xIndex, int yIndex) {
    fill(150, 150, 150);
    int x = width/2 + (xIndex - 4) * pixelsPerItemSlot;
    int y = height / 3 + yIndex * pixelsPerItemSlot;
    square(x, y, pixelsPerItemSlot);
    drawItemInInventory(x, y, xIndex, yIndex, pixelsPerItemSlot);
}

void drawItemInInventory(int x, int y, int xIndex, int yIndex, int pixelsPerItemSlot) {
    Item item = player.inventory[xIndex][yIndex].item;
    if (!(player.inventory[xIndex][yIndex].amount == 0)) {
        switch (item.type) {
            case "block":
                drawBlockInInventory(x, y, xIndex, yIndex, pixelsPerItemSlot);
                break;
            case "tool":
                drawToolInInventory(x, y, xIndex, yIndex, pixelsPerItemSlot);
                break;
        }  
    }
}

void drawBlockInInventory(int x, int y, int xIndex, int yIndex, int pixelsPerItemSlot) {
    Block block = (Block) player.inventory[xIndex][yIndex].item;
    
    // Can not call drawBlock() function here, because that ones size changes with pixelsPerBlock
    fill(block.c);
    square(x, y, pixelsPerItemSlot / 2);
    
    // Draw amount (text)
    textSize(24);
    textAlign(CENTER, BOTTOM);
    fill(255, 255, 255);
    text(player.inventory[xIndex][yIndex].amount, x, y + pixelsPerItemSlot / 2);
}

void drawToolInInventory(int x, int y, int xIndex, int yIndex, int pixelsPerItemSlot) {
    Tool tool = (Tool) player.inventory[xIndex][yIndex].item;
    
    fill(tool.c);
    circle(x, y, pixelsPerItemSlot / 2);
    
    // Draw letter for tool type (Temporary solution, before I add specific images for tools) 
    textSize(20);
    textAlign(CENTER, BOTTOM);
    fill(255, 255, 255);
    text(tool.toolType, x, y + pixelsPerItemSlot / 2);
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
    Item item = player.getHotbarSlot(hotbarIndex).item;
    if (!(player.getHotbarSlot(hotbarIndex).amount == 0)) {
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

void drawBlockInHotbar(int x, int y, int hotbarIndex, int pixelsPerItemSlot) {
    Block block = (Block) player.getHotbarSlot(hotbarIndex).item;
    
    // Can not call drawBlock() function here, because that ones size changes with pixelsPerBlock
    fill(block.c);
    square(x, y, pixelsPerItemSlot / 2);
    
    // Draw amount (text)
    textSize(24);
    textAlign(CENTER, BOTTOM);
    fill(255, 255, 255);
    text(player.getHotbarSlot(hotbarIndex).amount, x, height);
}

void drawToolInHotbar(int x, int y, int hotbarIndex, int pixelsPerItemSlot) {
    Tool tool = (Tool) player.getHotbarSlot(hotbarIndex).item;
    
    fill(tool.c);
    circle(x, y, pixelsPerItemSlot / 2);
    
    // Draw letter for tool type (Temporary solution, before I add specific images for tools) 
    textSize(20);
    textAlign(CENTER, BOTTOM);
    fill(255, 255, 255);
    text(tool.toolType, x, height);
}



void drawHotbar() {
    if (!inventoryIsOpen) {
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
}
