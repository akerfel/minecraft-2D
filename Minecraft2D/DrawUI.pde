void drawUI() {
    drawInventoryIfOpen();
    drawCraftingMenuIfOpen();
    drawHotbar();
    drawDebugMenuIfOpen();
    drawMouseItemSlot();
}

void drawDebugMenuIfOpen() {
    if (state.debugScreenIsShowing) {
        fill(240);
        textAlign(CORNER);

        // FPS
        text("fps: " + int(frameRate), 5, 20);

        // The player's current block coordinates
        text("Block: " + int(state.player.coords.x) + " / " + int(state.player.coords.y), 5, 40);

        // The player's current chunk coordinates
        //PVector playerChunkCoords = blockCoordsToChunkCoords(state.player.coords);
        //text("Chunk: " + int(playerChunkCoords.x) + " / " + int(playerChunkCoords.y), 5, 60);
    }
}

void drawInventoryIfOpen() {
    if (state.inventoryIsOpen) {
        for (int y = 0; y < settings.inventoryHeight; y++) {
            for (int x = 0; x < settings.inventoryWidth; x++) {
                ItemSlot itemSlot = state.player.inventory.grid[x][y];
                drawItemSlot(itemSlot, false);
            }
        }
    }
}

void drawCraftingMenuIfOpen() {
    if (state.inventoryIsOpen) {
       for (ItemSlot itemSlot : state.player.updateCraftableItems()) {
           drawItemSlot(itemSlot, true);
       }
    }
}

// This function is similar to drawInventoryIfOpen, except the y coordinate is fixed,
// and the currently selected hotbar slot will be highlighted.
void drawHotbar() {
    stroke(0);
    for (int x = 0; x < settings.inventoryWidth; x++) {
        ItemSlot itemSlot = state.player.inventory.getHotbarSlot(x);
        boolean highlightBackground = false;
        if (x == state.player.inventory.hotbarIndexSelected) {
            highlightBackground = true;
        }
        drawItemSlot(itemSlot, highlightBackground);
    }
    if (settings.noStrokeMode) {
        noStroke();
    }
}

void drawMouseItemSlot() {
    stroke(0);
    if (state.player.inventory.mouseHeldItemSlot.getCount() != 0) {
        drawItemInItemSlot(state.player.inventory.mouseHeldItemSlot, mouseX, mouseY);
    }
    if (settings.noStrokeMode) {
        noStroke();
    }
}

// Draws an itemSlot with center at (xPixel, yPixel)
void drawItemSlot(ItemSlot itemSlot, boolean highlightBackground) {
    stroke(0);
    int xPixel = itemSlot.xPixel;
    int yPixel = itemSlot.yPixel;
    drawItemSlotBackground(xPixel, yPixel, highlightBackground);
    // We will specifiy the center of each itemSlot
    int xPixelCenterOfItemSlot = xPixel + settings.pixelsPerItemSlot / 2;
    int yPixelCenterOfItemSlot = yPixel + settings.pixelsPerItemSlot / 2;
    drawItemInItemSlot(itemSlot, xPixelCenterOfItemSlot, yPixelCenterOfItemSlot);
    if (settings.noStrokeMode) {
        noStroke();
    }
}

void drawItemSlotBackground(int xPixel, int yPixel, boolean highlightBackground) {
    fill(150, 150, 150);
    if (highlightBackground) {
        fill(210, 210, 210);
    }
    square(xPixel, yPixel, settings.pixelsPerItemSlot);
}

// (xPixel, yPixel) should be the center of the drawn Item.
void drawItemInItemSlot(ItemSlot itemSlot, int xPixel, int yPixel) {
    rectMode(CENTER);
    Item item = itemSlot.item;
    if (itemSlot.getCount() != 0) {
        switch (item.itemType) {
        case BLOCK:
            drawBlockInItemSlot(itemSlot, xPixel, yPixel);
            break;
        case TOOL:
            drawToolInItemSlot(itemSlot, xPixel, yPixel);
            break;
        case GUN:
            drawGunInItemSlot(itemSlot, xPixel, yPixel);
            break;
        case BULLET:
            drawBulletInItemSlot(itemSlot, xPixel, yPixel);
            break;
        }
    }
    rectMode(CORNER);
}

void drawBlockInItemSlot(ItemSlot itemSlot, int xPixel, int yPixel) {
    rectMode(CENTER);
    Block block = (Block) itemSlot.item;

    // Can not call drawBlock() function here, because that ones size changes with settings.pixelsPerBlock
    fill(block.c);
    square(xPixel, yPixel, settings.pixelsPerItemSlot / 2);

    // Write amount
    textSize(24);
    textAlign(CENTER, BOTTOM);
    fill(255, 255, 255);
    text(itemSlot.getCount(), xPixel, yPixel);
    rectMode(CORNER);

    // Write tool name (temporary solution, until specific images for tools are added)
    textSize(10);
    textAlign(CENTER, BOTTOM);
    fill(255, 255, 255);
    text(block.toString(), xPixel, yPixel + settings.pixelsPerItemSlot / 2);
    rectMode(CORNER);
}

void drawToolInItemSlot(ItemSlot itemSlot, int xPixel, int yPixel) {
    rectMode(CENTER);
    Tool tool = (Tool) itemSlot.item;

    fill(tool.c);
    circle(xPixel, yPixel, settings.pixelsPerItemSlot / 2);

    textSize(15);
    textAlign(CENTER, BOTTOM);
    fill(255, 255, 255);
    String toolName = tool.toString().substring(tool.toString().lastIndexOf("_") + 1);
    text(toolName, xPixel, yPixel + settings.pixelsPerItemSlot / 2);
    rectMode(CORNER);
}

void drawBulletInItemSlot(ItemSlot itemSlot, int xPixel, int yPixel) {
    Item bullet = itemSlot.item;
    rectMode(CENTER);

    fill(bullet.c);
    circle(xPixel, yPixel, settings.pixelsPerItemSlot / 5);

    // Write amount
    textSize(24);
    textAlign(CENTER, BOTTOM);
    fill(255, 255, 255);
    text(itemSlot.getCount(), xPixel, yPixel);
    rectMode(CORNER);

    textSize(15);
    textAlign(CENTER, BOTTOM);
    fill(255, 255, 255);
    text("BULLET", xPixel, yPixel + settings.pixelsPerItemSlot / 2);
    rectMode(CORNER);
}

void drawGunInItemSlot(ItemSlot itemSlot, int xPixel, int yPixel) {
    rectMode(CENTER);
    MachineGun gun = (MachineGun) itemSlot.item;

    fill(gun.c);
    rect(xPixel, yPixel, settings.pixelsPerItemSlot / 2, settings.pixelsPerItemSlot / 4);

    textSize(10);
    textAlign(CENTER, BOTTOM);
    fill(255, 255, 255);
    String gunName = gun.toString();
    text(gunName, xPixel, yPixel + settings.pixelsPerItemSlot / 2);
    rectMode(CORNER);
}
