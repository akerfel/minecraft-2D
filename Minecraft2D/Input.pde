void keyPressed() {
    player.setMove(keyCode, true);
    
    if (key == 'f') {
        setFireCenterChunk();
    }
    if (key == 'c') {
        playerBlockChangeColor();
    }
}
 
void keyReleased() {
    player.setMove(keyCode, false);
}
