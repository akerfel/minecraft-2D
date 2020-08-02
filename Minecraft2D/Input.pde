void keyPressed() {
    player.setMove(keyCode, true);
    
    if (key == 'f') {
        setFireCenterChunk();
    }
    if (key == 'c') {
        playerBlockChangeColor();
    }
    if (key == CODED) {
        if (keyCode == SHIFT) {
            player.isRunning = true;    
        }
    }
}
 
void keyReleased() {
    player.setMove(keyCode, false);
    if (key == CODED) {
        if (keyCode == SHIFT) {
            player.isRunning = false;    
        }
    }
}
