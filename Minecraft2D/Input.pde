void keyPressed() {
    player.setMove(keyCode, true);
    
    if (key == 'f') {
        setFireCenterChunk();
    }
}
 
void keyReleased() {
    player.setMove(keyCode, false);
}
