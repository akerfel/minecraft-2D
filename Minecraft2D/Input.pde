void keyPressed() {
    if (key == 'x') {
        for (int i = 0; i < 5; i++) {
            state.player.inventory.addItem(createItem(ItemID.STONE));
        }
    }

    state.player.setMove(keyCode, true);

    int numberKeyClicked = int(key) - 49;
    if (numberKeyClicked >= 0 && numberKeyClicked <= 8) {
        state.player.inventory.hotbarIndexSelected = numberKeyClicked;
    }

    if (key == '+') {
        zoom(1);
    } else if (key == '-') {
        zoom(-1);
    }

    if (key == 'e') {
        openOrCloseInventory();
    }

    if (key == 'c') {
        state.craftingMenuIsOpen = !state.craftingMenuIsOpen;
    }

    if (key == '.') {
        setViewDistance(settings.viewDistance - 2);
    }

    if (key == 'f') {
        state.rightMouseButtonDown = true;
    }

    if (key == 't') {
        saveGeneratedChunksToFile();
    }

    if (key == CODED) {
        if (keyCode == SHIFT) {
            state.player.isRunning = true;
        }
        //if (keyCode == ALT) {
        //    state.player.isRunningSuperSpeed = true;
        //}
        // F3 has keycode 114
        if (keyCode == 114) {
            state.debugScreenIsShowing = !state.debugScreenIsShowing;
        }
    }
}

void keyReleased() {
    state.player.setMove(keyCode, false);

    if (key == 'f') {
        state.rightMouseButtonDown = false;
    }

    if (key == CODED) {
        if (keyCode == SHIFT) {
            state.player.isRunning = false;
        }
        if (keyCode == ALT) {
            state.player.isRunningSuperSpeed = false;
        }
    }
}

void mousePressed() {
    if (mouseButton == RIGHT) {
        state.rightMouseButtonDown = true;
    } else if (mouseButton == LEFT) {
        state.leftMouseButtonDown = true;
        if (state.inventoryIsOpen) {
            handleInventoryClick();
        }
    }
}

void handleInventoryClick() {
    ItemSlot clickedItemSlot = getItemSlotWhichMouseHovers();
    if (clickedItemSlot != null) {
        int inventoryXindex = (mouseX - settings.inventoryUpperLeftXPixel) / settings.pixelsPerItemSlot;
        int inventoryYindex = (mouseY - settings.inventoryUpperLeftYPixel) / settings.pixelsPerItemSlot;
        ItemSlot grabbedSlot = state.player.inventory.grid[inventoryXindex][inventoryYindex];
        grabbedSlot.swapWith(state.player.inventory.mouseHeldItemSlot);
    }
}

void mouseReleased() {
    if (mouseButton == RIGHT) {
        state.rightMouseButtonDown = false;
    } else if (mouseButton == LEFT) {
        state.leftMouseButtonDown = false;
    }
}

void mouseWheel(MouseEvent event) {
    if (keyPressed && key == 't') {
        // Scroll up
        if (event.getCount() > 0) {
            zoom(-1);
        }
        // Scroll down
        else {
            zoom(1);
        }
    } else {
        // Scroll up
        if (event.getCount() > 0) {
            state.player.inventory.hotbarIndexSelected++;
            if (state.player.inventory.hotbarIndexSelected >= settings.inventoryWidth) {
                state.player.inventory.hotbarIndexSelected = 0;
            }
        }
        // Scroll down
        else {
            state.player.inventory.hotbarIndexSelected--;
            if (state.player.inventory.hotbarIndexSelected < 0) {
                state.player.inventory.hotbarIndexSelected = settings.inventoryWidth - 1;
            }
        }
    }
}

void openOrCloseInventory() {
    if (state.inventoryIsOpen) {
        closeInventory();
    } else {
        openInventory();
    }
}

void closeInventory() {
    state.inventoryIsOpen = false;
    moveHotbarToBottomOfScreen();
    state.player.inventory.returnMouseGrabbedItemToInventory();
}

void openInventory() {
    state.inventoryIsOpen = true;
    moveHotbarToBottomOfInventory();
}

void moveHotbarToBottomOfScreen() {
    for (int x = 0; x < settings.inventoryWidth; x++) {
        ItemSlot slot = state.player.inventory.getHotbarSlot(x);
        slot.yPixel = height - settings.pixelsPerItemSlot;
    }
}

void moveHotbarToBottomOfInventory() {
    for (int x = 0; x < settings.inventoryWidth; x++) {
        ItemSlot slot = state.player.inventory.getHotbarSlot(x);
        slot.yPixel = settings.inventoryUpperLeftYPixel + (settings.inventoryHeight - 1) * settings.pixelsPerItemSlot;
    }
}

void handleMouseClicks() {
    handleLeftClick();
    handleRightClick();
}

void handleLeftClick() {
    if (state.leftMouseButtonDown) {
        if (state.player.isHoldingItemWhichCanMine()) {
            mineBlockWithMouse();
        }
        if (state.player.isHoldingGun()) {
            shootPlayerGun();
        }
    }
}


void handleRightClick() {
    if (!state.inventoryIsOpen) {
        if (state.rightMouseButtonDown) {
            placeBlockWithMouse();
        }
    }
}

void placeBlockWithMouse() {
    if (state.player.selectedItemIsBlock()) {
        ItemSlot slot = state.player.getSelectedItemSlot();
        Block block = (Block) slot.item;
        if (slot.getCount() != 0) {
            if (state.player.getDistanceToMouse() < state.player.reach &&! getMouseBlock2d().isWall &&
                setMouseBlock2d((Block) createItem(block.itemID))) {
                slot.count--;
            }
        }
    }
}

PVector getCoordsWhichMouseHovers() {
    PVector vectorPlayerToMouse = state.player.getVectorFromMouse();
    return state.player.coords.copy().add(vectorPlayerToMouse);
}

Block getMouseBlock2d() {
    PVector distancePlayerToMouse = state.player.getVectorFromMouse();
    return getBlock(int(state.player.coords.x - distancePlayerToMouse.x), int(state.player.coords.y - distancePlayerToMouse.y));
}

Block getMouseBlock3d() {
    PVector distancePlayerToMouse = state.player.getVectorFromMouse();
    return getBlock(int(state.player.coords.x - distancePlayerToMouse.x - settings.offsetFactor3d), int(state.player.coords.y - distancePlayerToMouse.y + settings.offsetFactor3d));
}

void mineBlockWithMouse() {
    Block mouseBlock = getMouseBlock3d();
    if (mouseBlock.isMineable && state.player.getDistanceToMouse() < state.player.reach) {
        if (mouseBlock.prcntBroken >= 1) {
            state.player.inventory.addItem(mouseBlock);
            setMouseBlock3d((Block) createItem(ItemID.GRASS));    // Correct chunk grass color is handled inside function
        } else {
            mouseBlock.mineBlock();
            state.damagedBlocks.add(mouseBlock);
        }
    }
}

// Returns the ItemSlot which the mouse currently hovers.
ItemSlot getItemSlotWhichMouseHovers() {
    if (state.inventoryIsOpen) {
        for (int y = 0; y < settings.inventoryHeight; y++) {
            for (int x = 0; x < settings.inventoryWidth; x++) {
                ItemSlot slot = state.player.inventory.grid[x][y];
                if (slot.mouseCurrentlyHovers()) {
                    return slot;
                }
            }
        }
        
        for (ItemSlot craftableSlot : state.player.craftableItems) {
            if (craftableSlot.mouseCurrentlyHovers()) {
                state.player.craftItem(craftableSlot);
            }
        }
    }
    return null;
}
