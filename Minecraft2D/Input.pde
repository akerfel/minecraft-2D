void keyPressed() {
    player.setMove(keyCode, true);
    
    if (key == 'f') {
        setFireCenterChunk();
    }
    int numberKeyClicked = int(key) - 48;
    if (numberKeyClicked >= 1 && numberKeyClicked <= 9) {
        player.hotbarSlotSelected = numberKeyClicked;
        println("Selected hotbar slot " + player.hotbarSlotSelected);
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
 
