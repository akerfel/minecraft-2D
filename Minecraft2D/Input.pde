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
        zoom(1);
    }
    else if (key == '-') {
        zoom(-1);
    }
    
    if (key == 'e') {
        inventoryShowing = !inventoryShowing;    
    }
    
    if (key == '.') {
        setViewDistance(viewDistance - 2);   
    }
    
    if (key == 'f') {
        rightMouseButtonDown = true;   
    }
    
    // hacks
    
    if (key == 'h') {
        cheatWalkThroughWalls = !cheatWalkThroughWalls;
        if (cheatWalkThroughWalls) {
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
            player.isRunningLikeUsainBolt = true;    
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
    if (event.getCount() > 0) {
        zoom(-1);
    }
    else {
        zoom(1);
    }
}
 
