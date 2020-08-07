void keyPressed() {
    
    if (key == 'x') {
        for (int i = 0; i < 5; i++) {
            player.addBlockToInventory(new Stone());
        }
        
    }
    
    if (key == 'c') {
        for (int i = 0; i < 5; i++) {
            player.addBlockToInventory(new Planks());
        }
    }
    
    player.setMove(keyCode, true);
    
    if (key == 'f') {
        setFireCenterChunk();
    }
    int numberKeyClicked = int(key) - 49;
    if (numberKeyClicked >= 0 && numberKeyClicked <= 8) {
        player.hotbarCellSelected = numberKeyClicked;
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
  if (event.getCount() > 0) {
      pixelsPerBlock -= 2;
  }
  else {
      pixelsPerBlock += 2;
  }
  resetObjectsDependingOnPixelsPerBlock();
}
 
