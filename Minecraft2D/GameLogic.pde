void updateLogic() {
    player.move();
    loadVisibleChunksIfNeeded();    
}

void setFireCenterChunk() {
    for (int x = 0; x < blocksPerChunk; x++) {
        for (int y = 0; y < blocksPerChunk; y++) {
            if (random(0, 1) < 0.05) {
                visibleChunks[4].blocks[x][y].c = color(200, 0, 0);
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
        println("Loading new chunks");
        println("Previous: " + previousChunkCoords);
        println("Current: " + currentChunkCoords);
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

void playerBlockChangeColor() {
    getPlayerBlock().c = color(0, 0, 255);
}

Block getBlock(float x, float y) {
    Chunk chunk = getChunk(new PVector(x, y));
    return chunk.blocks[int(x) % blocksPerChunk][int(y) % blocksPerChunk];
}

Block getPlayerBlock() {
    return getBlock(player.coords.x, player.coords.y);
}
