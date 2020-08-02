void mousePressed() {
    if (mouseButton == RIGHT) {
        float xPixelsFromPlayerToMouse = width / 2 - mouseX;
        float yPixelsFromPlayerToMouse = width / 2 - mouseY;
        float xBlocksFromPlayerToMouse = xPixelsFromPlayerToMouse / pixelsPerBlock;
        float yBlocksFromPlayerToMouse = yPixelsFromPlayerToMouse / pixelsPerBlock;
        println("Blocks from player to mouse in x: " + xBlocksFromPlayerToMouse);
        println("Blocks from player to mouse in y: " + yBlocksFromPlayerToMouse);
        Chunk clickedChunk = getChunk(new PVector(int(player.coords.x - xBlocksFromPlayerToMouse), int(player.coords.y - yBlocksFromPlayerToMouse)));
        if (clickedChunk == getChunk(player.coords)) {
            clickedChunk.blocks[int(constrain(player.coords.x % blocksPerChunk - xBlocksFromPlayerToMouse, 0, blocksPerChunk - 1))][int(constrain(player.coords.y % blocksPerChunk - yBlocksFromPlayerToMouse, 0, blocksPerChunk - 1))] = new Stone();
        }
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
