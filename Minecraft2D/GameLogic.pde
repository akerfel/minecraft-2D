void updateLogic() {
    player.move();
    loadVisibleChunks();    
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

void loadVisibleChunks() {
    visibleChunks = new Chunk[9];
    println("Chunk coords: " + (int(player.coords.x / blocksPerChunk)) + ", " + int(player.coords.y / blocksPerChunk));
    println("Player coords: " + player.coords.x + ", " + player.coords.y);

    // Top row
    visibleChunks[0] = getChunkForPlayerCoords(new PVector(player.coords.x - blocksPerChunk, player.coords.y - blocksPerChunk));
    visibleChunks[1] = getChunkForPlayerCoords(new PVector(player.coords.x, player.coords.y - blocksPerChunk));
    visibleChunks[2] = getChunkForPlayerCoords(new PVector(player.coords.x + blocksPerChunk, player.coords.y - blocksPerChunk));
    
    // Middle row
    visibleChunks[3] = getChunkForPlayerCoords(new PVector(player.coords.x - blocksPerChunk, player.coords.y));
    visibleChunks[4] = getChunkForPlayerCoords(new PVector(player.coords.x, player.coords.y));
    visibleChunks[5] = getChunkForPlayerCoords(new PVector(player.coords.x + blocksPerChunk, player.coords.y));
    
    // Bottom row
    visibleChunks[6] = getChunkForPlayerCoords(new PVector(player.coords.x - blocksPerChunk, player.coords.y + blocksPerChunk));
    visibleChunks[7] = getChunkForPlayerCoords(new PVector(player.coords.x, player.coords.y + blocksPerChunk));
    visibleChunks[8] = getChunkForPlayerCoords(new PVector(player.coords.x + blocksPerChunk, player.coords.y + blocksPerChunk));
}

// Takes player coords, converts them into chunkCoords and loads that chunk from generatedChunks. 
// If chunk has not yet been generated, create it and it to generatedChunks (chunkCoords is key).
Chunk getChunkForPlayerCoords(PVector playerCoords) {
    PVector chunkCoords = new PVector(int(playerCoords.x / blocksPerChunk), int(playerCoords.y / blocksPerChunk));
    // The next two if statements ensure that the same chunk wont be loaded
    // for playerCoords [0, 0] and [0, -1].
    if (playerCoords.x < 0) {
        chunkCoords.x--;    
    }
    if (playerCoords.y < 0) {
        chunkCoords.y--;    
    }
    // Create chunk if does not exist
    if (!generatedChunks.containsKey(chunkCoords)) {
        generatedChunks.put(chunkCoords, new Chunk(chunkCoords));
    }
    return generatedChunks.get(chunkCoords);
}

void playerBlockChangeColor() {
    getPlayerBlock().c = color(0, 0, 255);
}

Block getBlock(PVector coords) {
    Chunk chunk = getChunkForPlayerCoords(player.coords);
    return chunk.blocks[int(player.coords.x) % blocksPerChunk][int(player.coords.y) % blocksPerChunk];
}

Block getPlayerBlock() {
    return getBlock(player.coords);
}
