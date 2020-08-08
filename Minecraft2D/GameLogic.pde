void updateLogic() {
    player.move();
    loadVisibleBlocks();    
    placeBlocksWithMouse();
    mineBlocksWithMouse();
    removeBlockDamageIfNotMining();
    maybeSpawnMob();
    removeFarMobs();
    updateMobs();
}

// This function is called each frame.
// I tried to only call this each time the player stepped on a new block, but it did not seem to improve the fps.
// That also introduced other problems (block would not be mined until stepped new block), so I chose to keep it like this.
void loadVisibleBlocks() {
    for (int x = 0; x < sightInBlocks; x++) {
        for (int y = 0; y < sightInBlocks; y++) {
            visibleBlocks[x][y] = getBlock(player.coords.x + x - sightInBlocks/2, player.coords.y + y - sightInBlocks/2);
        }
    }    
}

void updateMobs() {
    for (Mob mob : mobs) {
        mob.update();    
    }
}

void removeBlockDamageIfNotMining() {
    if (!leftMouseButtonDown) {
        for (Block block : damagedBlocks) {
            block.removeDamage();    
        }
    }
}

void removeFarMobs() {
    Iterator<Mob> it = mobs.iterator();
    while (it.hasNext()) {
        Mob mob = it.next();
        if (player.coords.dist(mob.coords) > mobDespawnRange) {
            it.remove();
        }
    }
}

void maybeSpawnMob() {
    if (mobs.size() < maxMobs && random(0, 1) < mobSpaceChance) {
        spawnMob();    
    }
}

void spawnMob() {
    mobs.add(new Mob(player.coords.x + random(-mobSpawnRange, mobSpawnRange), player.coords.y + random(-mobSpawnRange, mobSpawnRange)));
}

void resetObjectsDependingOnPixelsPerBlock() {
    playerWidth = pixelsPerBlock / 2;
    mobWidth = pixelsPerBlock / 2;
}

void placeBlocksWithMouse() {
    if (rightMouseButtonDown) {
        HotbarCell cell = player.hotbar[player.hotbarIndexSelected];
        if (cell.item.type.equals("block")) {
            if (cell.amount != 0) {
                if (getDistance_BlocksFromPlayerToMouse() < player.reach && setMouseBlock((Block) cell.item)) {
                    cell.amount--;
                }
            }
        }
    }
}

void mineBlocksWithMouse() {
    if (leftMouseButtonDown) {
        Block mouseBlock = getMouseBlock();
        if (!mouseBlock.toString().equals("grass") && getDistance_BlocksFromPlayerToMouse() < player.reach) {
            if (mouseBlock.prcntBroken >= 1) {
                player.addBlockToInventory(mouseBlock);
                setMouseBlock(new Grass());    // Correct chunk grass color is handled inside function
            }
            else {
                mouseBlock.mineBlock();  
                damagedBlocks.add(mouseBlock);
            }
        }
    }
}

Block getMouseBlock() {
    PVector distancePlayerToMouse = getVector_BlocksFromPlayerToMouse();
    return getBlock(int(player.coords.x - distancePlayerToMouse.x), int(player.coords.y - distancePlayerToMouse.y));
}

boolean setMouseBlock(Block block) {
    PVector distancePlayerToMouse = getVector_BlocksFromPlayerToMouse();
    return setBlock(block, int(player.coords.x - distancePlayerToMouse.x), int(player.coords.y - distancePlayerToMouse.y));
}

PVector getVector_BlocksFromPlayerToMouse() {
    float xPixelsFromPlayerToMouse = width / 2 - mouseX;
    float yPixelsFromPlayerToMouse = width / 2 - mouseY;
    float xBlocksFromPlayerToMouse = xPixelsFromPlayerToMouse / pixelsPerBlock;
    float yBlocksFromPlayerToMouse = yPixelsFromPlayerToMouse / pixelsPerBlock;
    return new PVector(xBlocksFromPlayerToMouse, yBlocksFromPlayerToMouse);
}

// Returns a float, total distance (in block lengths) from mouse to player
float getDistance_BlocksFromPlayerToMouse() {
    PVector distancePlayerToMouse = getVector_BlocksFromPlayerToMouse();
    return distancePlayerToMouse.dist(new PVector(0, 0));    // simply pyth. theorem
}

// Returns true if actually changed the block.
// Example: if you try to replace a stone block with stone, the block will not change, so function returns false
boolean setBlock(Block block, float x, float y) {
    Chunk chunk = getChunk(new PVector(x, y));
    int xInChunk = int(x) % blocksPerChunk;
    int yInChunk = int(y) % blocksPerChunk;
    if (!block.toString().equals(chunk.blocks[xInChunk][yInChunk].toString())) {
        // Special case for grass. We need to access the special grassColorScheme for the chunk the block is placed in.
        if (block.toString().equals("grass")) { 
            chunk.blocks[xInChunk][yInChunk] = new Grass(getChunk(new PVector(x, y)).grassColorScheme);
        }
        else {
            chunk.blocks[xInChunk][yInChunk] = block;
        }
        return true;
    }
    return false;
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
        println("Generated chunks: " + generatedChunks.size());
        println(generatedChunks.keySet());
    }
    return generatedChunks.get(chunkCoords);
}

PVector calcChunkCoords(PVector coords) {
    return new PVector(int(coords.x / blocksPerChunk), int(coords.y / blocksPerChunk));
}

Block getBlock(float x, float y) {
    Chunk chunk = getChunk(new PVector(x, y));
    return chunk.blocks[int(x) % blocksPerChunk][int(y) % blocksPerChunk];
}

Block getPlayerBlock() {
    return getBlock(player.coords.x, player.coords.y);
}
