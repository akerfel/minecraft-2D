void mousePressed() {
    if (mouseButton == RIGHT) {
        float xPixelsFromPlayerToMouse = width / 2 - mouseX;
        float yPixelsFromPlayerToMouse = width / 2 - mouseY;
        int xBlocksFromPlayerToMouse = int(xPixelsFromPlayerToMouse) / pixelsPerBlock;
        int yBlocksFromPlayerToMouse = int(yPixelsFromPlayerToMouse) / pixelsPerBlock;
        println("Blocks from player to mouse in x: " + xBlocksFromPlayerToMouse);
        println("Blocks from player to mouse in x: " + yBlocksFromPlayerToMouse);
        //Block[][] blocksInRelevantChunk = getChunk(new PVector(player.coords.x - xBlocksFromPlayerToMouse, player.coords.y - yBlocksFromPlayerToMouse)).blocks;
        //blocksInRelevantChunk[int(player.coords.x) % blocksPerChunk][int(player.coords.y - 1) % blocksPerChunk] = new Stone();
        //println("made stone?");    
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
