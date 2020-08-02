void mousePressed() {
    float xPixelsFromPlayerToMouse = width / 2 - mouseX;
    float yPixelsFromPlayerToMouse = width / 2 - mouseY;
    float xBlocksFromPlayerToMouse = xPixelsFromPlayerToMouse / pixelsPerBlock;
    float yBlocksFromPlayerToMouse = yPixelsFromPlayerToMouse / pixelsPerBlock;
    println("Blocks from player to mouse in x: " + xBlocksFromPlayerToMouse);
    println("Blocks from player to mouse in y: " + yBlocksFromPlayerToMouse);
    Chunk clickedChunk = getChunk(new PVector(int(player.coords.x - xBlocksFromPlayerToMouse), int(player.coords.y - yBlocksFromPlayerToMouse)));
    if (clickedChunk == getChunk(player.coords)) {
        if (mouseButton == RIGHT) {
            clickedChunk.blocks[int(constrain(player.coords.x % blocksPerChunk - xBlocksFromPlayerToMouse, 0, blocksPerChunk - 1))][int(constrain(player.coords.y % blocksPerChunk - yBlocksFromPlayerToMouse, 0, blocksPerChunk - 1))] = new Stone();
        }
        else if (mouseButton == LEFT) {
            clickedChunk.blocks[int(constrain(player.coords.x % blocksPerChunk - xBlocksFromPlayerToMouse, 0, blocksPerChunk - 1))][int(constrain(player.coords.y % blocksPerChunk - yBlocksFromPlayerToMouse, 0, blocksPerChunk - 1))] = new Grass(getChunk(player.coords).grassColorScheme);
        }
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
