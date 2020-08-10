void keyPressed() {
    
    if (key == 'x') {
        for (int i = 0; i < 5; i++) {
            player.addBlockToInventory(new Stone());
        }
        
    }
    
    player.setMove(keyCode, true);
    
    int numberKeyClicked = int(key) - 49;
    if (numberKeyClicked >= 0 && numberKeyClicked <= 8) {
        player.hotbarIndexSelected = numberKeyClicked;
    }
    
    if (key == '+') {
        setViewDistance(viewDistance + 2);   
    }
    else if (key == '-') {
        setViewDistance(viewDistance - 2);   
    }
    
    if (key == CODED) {
        if (keyCode == SHIFT) {
            player.isRunning = true;    
        }
        if (keyCode == CONTROL) {
            player.isRunningLikeUsainBolt = true;    
        }
    }
}

void keyReleased() {
    player.setMove(keyCode, false);
    if (key == CODED) {
        if (keyCode == SHIFT) {
            player.isRunning = false;    
        }
        if (keyCode == CONTROL) {
            player.isRunningLikeUsainBolt = false;    
        }
    }
}

void mousePressed() {
    if (mouseButton == RIGHT) {
        rightMouseButtonDown = true;
    }
    else if (mouseButton == LEFT) {
        leftMouseButtonDown = true;
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
    int oldPixelsPerBlock = pixelsPerBlock;
    int changeInPixels = 1;
    if (event.getCount() > 0) {
        pixelsPerBlock -= changeInPixels;
        if (pixelsPerBlock < 1) {
            pixelsPerBlock = 1;    
        }
    }
    else {
        pixelsPerBlock += changeInPixels;
    }
    if (oldPixelsPerBlock != pixelsPerBlock) {
        println("Pixels per block: " + pixelsPerBlock);
        resetObjectsDependingOnPixelsPerBlock();
        makeViewDistanceFitZoomLevel();
    }
}
 
