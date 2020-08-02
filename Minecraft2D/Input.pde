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

void keyPressed() {
    player.setMove(keyCode, true);
    
    if (key == 'f') {
        setFireCenterChunk();
    }
    if (key == ' ') {
        placeStoneAbovePlayer();
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

void mouseWheel(MouseEvent event) {
  if (event.getCount() > 0) {
      pixelsPerBlock -= 2;
  }
  else {
      pixelsPerBlock += 2;
  }
  resetObjectsDependingOnPixelsPerBlock();
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
