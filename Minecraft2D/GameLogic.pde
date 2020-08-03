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
    PVector distancePlayerToMouse = calcBlocksFromPlayerToMouse();
    return getBlock(int(player.coords.x - distancePlayerToMouse.x), int(player.coords.y - distancePlayerToMouse.y));
}

boolean setMouseBlock(Block block) {
    PVector distancePlayerToMouse = calcBlocksFromPlayerToMouse();
    return setBlock(block, int(player.coords.x - distancePlayerToMouse.x), int(player.coords.y - distancePlayerToMouse.y));
}

PVector calcBlocksFromPlayerToMouse() {
    float xPixelsFromPlayerToMouse = width / 2 - mouseX;
    float yPixelsFromPlayerToMouse = width / 2 - mouseY;
    float xBlocksFromPlayerToMouse = xPixelsFromPlayerToMouse / pixelsPerBlock;
    float yBlocksFromPlayerToMouse = yPixelsFromPlayerToMouse / pixelsPerBlock;
    return new PVector(xBlocksFromPlayerToMouse, yBlocksFromPlayerToMouse);
}

// Returns true if actually changed the block.
// Example: if you try to replace a stone block with stone, the block will not change, so function returns false
boolean setBlock(Block block, float x, float y) {
    Chunk chunk = getChunk(new PVector(x, y));
    int xInChunk = int(x) % blocksPerChunk;
    int yInChunk = int(y) % blocksPerChunk;
    if (!block.toString().equals(chunk.blocks[xInChunk][yInChunk].toString())) {
        // Special case for grass. We need to access the special grassColorScheme for the chunk the block is placed in.
        if (block.toString().equals("Grass")) { 
            chunk.blocks[xInChunk][yInChunk] = new Grass(getChunk(new PVector(x, y)).grassColorScheme);
        }
        else {
            chunk.blocks[xInChunk][yInChunk] = block;
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
