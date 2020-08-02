void updateLogic() {
    player.move();
    loadVisibleChunksIfNeeded();    
    placeBlocksWithMouse();
}

void resetObjectsDependingOnPixelsPerBlock() {
    playerWidth = pixelsPerBlock / 2;
}

void placeBlocksWithMouse() {
    if (rightMouseButtonDown) {
        HotbarCell cell = player.hotbar[player.hotbarCellSelected];
        if (cell.amount != 0) {
            if (setMouseBlock(cell.block.toString())) {
                println("Placed " + cell.block.toString() + "        " + random(0, 100));
                cell.amount--;
            }
        }
    }
    if (leftMouseButtonDown) {
        if (!getMouseBlock().toString().equals("Grass")) {
            player.addBlockToInventory(getMouseBlock());
        }
        setMouseBlock(new Grass());    // Correct chunk grass color is handled inside function
    }
}

boolean setMouseBlock(String blockName) {
    switch (blockName) {
        case "Stone":
            return setMouseBlock(new Stone());
        case "Planks":
            return setMouseBlock(new Planks());
    }
    return false;
}

Block getMouseBlock() {
    float xPixelsFromPlayerToMouse = width / 2 - mouseX;
    float yPixelsFromPlayerToMouse = width / 2 - mouseY;
    float xBlocksFromPlayerToMouse = xPixelsFromPlayerToMouse / pixelsPerBlock;
    float yBlocksFromPlayerToMouse = yPixelsFromPlayerToMouse / pixelsPerBlock;
    Chunk clickedChunk = getChunk(new PVector(int(player.coords.x - xBlocksFromPlayerToMouse), int(player.coords.y - yBlocksFromPlayerToMouse)));
    int xInChunk = int(constrain(player.coords.x % blocksPerChunk - xBlocksFromPlayerToMouse, 0, blocksPerChunk - 1));
    int yInChunk = int(constrain(player.coords.y % blocksPerChunk - yBlocksFromPlayerToMouse, 0, blocksPerChunk - 1));
    return clickedChunk.blocks[xInChunk][yInChunk];
}

boolean setMouseBlock(Block block) {
    float xPixelsFromPlayerToMouse = width / 2 - mouseX;
    float yPixelsFromPlayerToMouse = width / 2 - mouseY;
    float xBlocksFromPlayerToMouse = xPixelsFromPlayerToMouse / pixelsPerBlock;
    float yBlocksFromPlayerToMouse = yPixelsFromPlayerToMouse / pixelsPerBlock;
    Chunk clickedChunk = getChunk(new PVector(int(player.coords.x - xBlocksFromPlayerToMouse), int(player.coords.y - yBlocksFromPlayerToMouse)));
    int xInChunk = int(constrain(player.coords.x % blocksPerChunk - xBlocksFromPlayerToMouse, 0, blocksPerChunk - 1));
    int yInChunk = int(constrain(player.coords.y % blocksPerChunk - yBlocksFromPlayerToMouse, 0, blocksPerChunk - 1));
    
    if (clickedChunk == getChunk(player.coords) && !block.toString().equals(clickedChunk.blocks[xInChunk][yInChunk].toString())) {
        if (block.toString().equals("Grass")) { // Special case for grass. We need to access the special grassColorScheme for the chunk the block is placed in.
            clickedChunk.blocks[xInChunk][yInChunk] = new Grass(getChunk(player.coords).grassColorScheme);
        }
        else {
            clickedChunk.blocks[xInChunk][yInChunk] = block;
        }
        return true;
    }
    return false;
}

void setFireCenterChunk() {
    for (int x = 0; x < blocksPerChunk; x++) {
        for (int y = 0; y < blocksPerChunk; y++) {
            if (random(0, 1) < 0.05) {
                Block block = visibleChunks[4].blocks[x][y];
                if (block.toString() == "Grass") {
                    visibleChunks[4].blocks[x][y].c = color(200, 0, 0);
                }
            }
        }
    }    
}

void initalLoadChunks() {
    loadVisibleChunks();
}

void loadVisibleChunksIfNeeded() {
    PVector previousChunkCoords = currentChunkCoords;
    currentChunkCoords = calcChunkCoords(player.coords);
    
    if (!(currentChunkCoords.x == previousChunkCoords.x && currentChunkCoords.y == previousChunkCoords.y)) {
        //println("Showing different chunks");
        //println("Previous: " + previousChunkCoords);
        //println("Current: " + currentChunkCoords);
        loadVisibleChunks();
    }
}


void loadVisibleChunks() {

    // Top row
    visibleChunks[0] = getChunk(new PVector(player.coords.x - blocksPerChunk, player.coords.y - blocksPerChunk));
    visibleChunks[1] = getChunk(new PVector(player.coords.x, player.coords.y - blocksPerChunk));
    visibleChunks[2] = getChunk(new PVector(player.coords.x + blocksPerChunk, player.coords.y - blocksPerChunk));
    
    // Middle row
    visibleChunks[3] = getChunk(new PVector(player.coords.x - blocksPerChunk, player.coords.y));
    visibleChunks[4] = getChunk(new PVector(player.coords.x, player.coords.y));
    visibleChunks[5] = getChunk(new PVector(player.coords.x + blocksPerChunk, player.coords.y));
    
    // Bottom row
    visibleChunks[6] = getChunk(new PVector(player.coords.x - blocksPerChunk, player.coords.y + blocksPerChunk));
    visibleChunks[7] = getChunk(new PVector(player.coords.x, player.coords.y + blocksPerChunk));
    visibleChunks[8] = getChunk(new PVector(player.coords.x + blocksPerChunk, player.coords.y + blocksPerChunk));    
}

// Takes player coords, converts them into chunkCoords and loads that chunk from generatedChunks. 
// If chunk has not yet been generated, create it and it to generatedChunks (chunkCoords is key).
Chunk getChunk(PVector coords) {
    PVector chunkCoords = calcChunkCoords(coords);
    // The next two if statements ensure that the same chunk wont be loaded
    // for playerCoords [0, 0] and [0, -1].
    if (coords.x < 0) {
        chunkCoords.x--;    
    }
    if (coords.y < 0) {
        chunkCoords.y--;    
    }
    // Create chunk if does not exist
    if (!generatedChunks.containsKey(chunkCoords)) {
        generatedChunks.put(chunkCoords, new Chunk(chunkCoords));
    }
    return generatedChunks.get(chunkCoords);
}

PVector calcChunkCoords(PVector coords) {
    return new PVector(int(coords.x / blocksPerChunk), int(coords.y / blocksPerChunk));
}

void placeStoneAbovePlayer() {
    Block[][] blocksInRelevantChunk = getChunk(new PVector(player.coords.x, player.coords.y - 1)).blocks;
    blocksInRelevantChunk[int(player.coords.x) % blocksPerChunk][int(player.coords.y - 1) % blocksPerChunk] = new Stone();
}

Block getBlock(float x, float y) {
    Chunk chunk = getChunk(new PVector(x, y));
    return chunk.blocks[int(x) % blocksPerChunk][int(y) % blocksPerChunk];
}

Block getPlayerBlock() {
    return getBlock(player.coords.x, player.coords.y);
}
