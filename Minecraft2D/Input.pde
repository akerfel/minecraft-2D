void keyPressed() {
    
    if (key == 'x') {
        for (int i = 0; i < 5; i++) {
            player.inventory.addBlock(new Stone());
        }
    }
    
    player.setMove(keyCode, true);
    
    int numberKeyClicked = int(key) - 49;
    if (numberKeyClicked >= 0 && numberKeyClicked <= 8) {
        player.inventory.hotbarIndexSelected = numberKeyClicked;
    }
    
    if (key == '+') {
        zoom(1);
    }
    else if (key == '-') {
        zoom(-1);
    }
    
    if (key == 'e') {
        if (inventoryIsOpen) {
            player.inventory.returnMouseGrabbedItemToInventory();
        }
        inventoryIsOpen = !inventoryIsOpen;
    }
    
    if (key == '.') {
        setViewDistance(viewDistance - 2);   
    }
    
    if (key == 'f') {
        rightMouseButtonDown = true;   
    }
    
    // hacks
    
    if (key == 'h') {
        Cheats.canWalkThroughWalls = !Cheats.canWalkThroughWalls;
        if (Cheats.canWalkThroughWalls) {
            println("Player can walk through walls");    
        }
        else {
            println("Player can not walk through walls");    
        }
    }
    
    if (key == CODED) {
        if (keyCode == SHIFT) {
            player.isRunning = true;    
        }
        if (keyCode == ALT) {
            player.isRunningSuperSpeed = true;    
        }
    }
}

void keyReleased() {
    player.setMove(keyCode, false);
    
    if (key == 'f') {
        rightMouseButtonDown = false;   
    }
    
    if (key == CODED) {
        if (keyCode == SHIFT) {
            player.isRunning = false;    
        }
        if (keyCode == ALT) {
            player.isRunningSuperSpeed = false;    
        }
    }
}

void mousePressed() {
    if (mouseButton == RIGHT) {
        rightMouseButtonDown = true;
    }
    else if (mouseButton == LEFT) {
        leftMouseButtonDown = true;
        if (inventoryIsOpen) {
            ItemSlot clickedItemSlot = getInventorySlotWhichMouseHovers();
            if (clickedItemSlot != null) {
                ItemSlot currentMouseHeldItemSlot = player.inventory.mouseHeldItemSlot;
                int inventoryXindex = (mouseX - inventoryUpperLeftXPixel) / pixelsPerItemSlot;
                int inventoryYindex = (mouseY - inventoryUpperLeftYPixel) / pixelsPerItemSlot;
                player.inventory.grabbedXindex = inventoryXindex;
                player.inventory.grabbedYindex = inventoryYindex;
                player.inventory.grid[inventoryXindex][inventoryYindex] = currentMouseHeldItemSlot;
                player.inventory.mouseHeldItemSlot = clickedItemSlot;
            }
        }
    }
}

void mouseReleased() {
    if (mouseButton == RIGHT) {
        rightMouseButtonDown = false;
    }
    else if (mouseButton == LEFT) {
        leftMouseButtonDown = false;
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
    }
    else {
        // Scroll up
        if (event.getCount() > 0) {
            player.inventory.hotbarIndexSelected++;
            if (player.inventory.hotbarIndexSelected >= inventoryWidth) {
                player.inventory.hotbarIndexSelected = 0;    
            }
        }
        // Scroll down
        else {
            player.inventory.hotbarIndexSelected--;
            if (player.inventory.hotbarIndexSelected < 0) {
                player.inventory.hotbarIndexSelected = inventoryWidth - 1;    
            }
        }
    }
}

 
