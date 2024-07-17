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
        if (state.inventoryIsOpen) {
            state.player.inventory.returnMouseGrabbedItemToInventory();
        }
        state.craftingMenuIsOpen = false;
        state.inventoryIsOpen = !state.inventoryIsOpen;
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

void handleMouseClicks() {
    handleLeftClick();
    handleRightClick();
}

void handleLeftClick() {
    if (state.leftMouseButtonDown) {
        if (playerIsHoldingItemWhichCanMine()) {
            mineBlockWithMouse();
        }
        if (playerIsHoldingGun() && heldGunIsReadyToShoot()) {
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
    if (selectedItemIsBlock()) {   
        ItemSlot slot = getSelectedItemSlot();   
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
