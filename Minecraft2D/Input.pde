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
        printPlayerCraftableItemsInConsole();
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
            ItemSlot clickedItemSlot = getInventorySlotWhichMouseHovers();
            if (clickedItemSlot != null) {
                ItemSlot currentMouseHeldItemSlot = state.player.inventory.mouseHeldItemSlot;
                int inventoryXindex = (mouseX - settings.inventoryUpperLeftXPixel) / settings.pixelsPerItemSlot;
                int inventoryYindex = (mouseY - settings.inventoryUpperLeftYPixel) / settings.pixelsPerItemSlot;
                state.player.inventory.grabbedXindex = inventoryXindex;
                state.player.inventory.grabbedYindex = inventoryYindex;
                state.player.inventory.grid[inventoryXindex][inventoryYindex] = currentMouseHeldItemSlot;
                state.player.inventory.mouseHeldItemSlot = clickedItemSlot;
            }
        }
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
    state.inventoryIsOpen = !state.inventoryIsOpen;
    if (state.inventoryIsOpen) {
        state.player.inventory.returnMouseGrabbedItemToInventory();
        moveHotbarToBottomOfInventory();
    }
    else {
        moveHotbarToBottomOfScreen();
    }
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
        if (state.player.isHoldingGun() && heldGunIsReadyToShoot()) {
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
            if (state.player.getDistanceToMouse() < state.player.reach &&
                (getMouseBlock().itemID == ItemID.GRASS || getMouseBlock().itemID == ItemID.WATER) &&
                setMouseBlock((Block) createItem(block.itemID))) {
                slot.count--;
            }
        }
    }
}

PVector getCoordsWhichMouseHovers() {
    PVector vectorPlayerToMouse = state.player.getVectorFromMouse();
    return state.player.coords.copy().add(vectorPlayerToMouse);
}

Block getMouseBlock() {
    PVector distancePlayerToMouse = state.player.getVectorFromMouse();
    return getBlock(int(state.player.coords.x - distancePlayerToMouse.x), int(state.player.coords.y - distancePlayerToMouse.y));
}

void mineBlockWithMouse() {
    Block mouseBlock = getMouseBlock();
    if (mouseBlock.isMineable && state.player.getDistanceToMouse() < state.player.reach) {
        if (mouseBlock.prcntBroken >= 1) {
            state.player.inventory.addItem(mouseBlock);
            setMouseBlock((Block) createItem(ItemID.GRASS));    // Correct chunk grass color is handled inside function
        } else {
            mouseBlock.mineBlock();
            state.damagedBlocks.add(mouseBlock);
        }
    }
}

// Returns the inventory slot which the mouse currently hovers.
// Note that this is not the same as state.player.mouseItemSlot
ItemSlot getInventorySlotWhichMouseHovers() {
    if (state.inventoryIsOpen) {
        if (mouseX < settings.inventoryUpperLeftXPixel || mouseY < settings.inventoryUpperLeftYPixel) return null;
        int inventoryXindex = (mouseX - settings.inventoryUpperLeftXPixel) / settings.pixelsPerItemSlot;
        int inventoryYindex = (mouseY - settings.inventoryUpperLeftYPixel) / settings.pixelsPerItemSlot;
        if (inventoryXindex < 0 || inventoryXindex >= settings.inventoryWidth || inventoryYindex < 0 || inventoryYindex >= settings.inventoryHeight) {
            return null;
        }
        if (state.player.inventory.grid[inventoryXindex][inventoryYindex].item != null) {
            //println("Grabbed item: " + (state.player.inventory.grid[inventoryXindex][inventoryYindex].item));
        }
        return state.player.inventory.grid[inventoryXindex][inventoryYindex];
    }
    return null;
}
