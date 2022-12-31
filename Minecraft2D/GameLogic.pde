void updateLogic() {
    player.move();
    updateBlocks();
    updateMobs();
}

void updateBlocks() {
    loadVisibleBlocks();    
    placeBlocksWithMouse();
    mineBlocksWithMouse();
    removeBlockDamageIfNotMining();
}

void updateMobs() {
    maybeSpawnMob();
    removeFarMobs();
    updateMobsPos();    
}

void makeViewDistanceFitZoomLevel() {
    int numBlocksVisible = width / pixelsPerBlock;
    setViewDistance(numBlocksVisible + 4);
}

// This function is called each frame.
// I tried to only call this each time the player stepped on a new block, but it did not seem to improve the fps.
// That also introduced other problems (block would not be mined until stepped new block), so I chose to keep it like this.
void loadVisibleBlocks() {
    for (int x = 0; x < viewDistance; x++) {
        for (int y = 0; y < viewDistance; y++) {
            visibleBlocks[x][y] = getBlock(player.coords.x + x - viewDistance/2, player.coords.y + y - viewDistance/2);
        }
    }    
}

void settingsSetup() {
    if (noStrokeMode) {
        noStroke();   
    }
}

void zoom(int changeInPixelsPerBlock) {
    int oldPixelsPerBlock = pixelsPerBlock;
    pixelsPerBlock += changeInPixelsPerBlock;
    if (pixelsPerBlock < 1) {
        pixelsPerBlock = 1;    
    }
    if (oldPixelsPerBlock != pixelsPerBlock) {
        println("Pixels per block: " + pixelsPerBlock + "x" + pixelsPerBlock);
        resetObjectsDependingOnPixelsPerBlock();
        makeViewDistanceFitZoomLevel();
    }
}

void setViewDistance(int newViewDistance) {
    if (newViewDistance > 3) {
        viewDistance = newViewDistance;
        visibleBlocks = new Block[viewDistance][viewDistance];
        println("Blocks rendered: " + viewDistance + "x" + viewDistance + " = " + (viewDistance * viewDistance));
    }
}

void updateMobsPos() {
    for (Mob mob : mobs) {
        mob.update();    
    }
}

void removeBlockDamageIfNotMining() {
    if (!leftMouseButtonDown) {
        Iterator<Block> it = damagedBlocks.iterator();
        while (it.hasNext()) {
            it.next().removeDamage();
            it.remove();            
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
    if (mobs.size() < maxMobs && random(0, 1) < mobSpawnChance) {
        spawnMob();    
    }
}

void spawnMob() {
    float xSpawn = int(player.coords.x + random(-mobSpawnRange, mobSpawnRange));
    float ySpawn = int(player.coords.y + random(-mobSpawnRange, mobSpawnRange));
    if (!getBlock(xSpawn, ySpawn).isWallOrWater()) {
        mobs.add(new Mob(xSpawn + 0.1, ySpawn + 0.1));    // + 0.1 so it does not spawn at exact corner of block (looks weird)
    }
}

void resetObjectsDependingOnPixelsPerBlock() {
    playerWidth = pixelsPerBlock / 2;
    mobWidth = pixelsPerBlock / 2;
}

void placeBlocksWithMouse() {
    if (rightMouseButtonDown) {
        ItemSlot cell = player.inventory.getHotbarSlot(player.inventory.hotbarIndexSelected);
        if (cell.item.type.equals("block")) {
            Block block = (Block) cell.item;
            if (cell.amount != 0) {
                if (getDistance_BlocksFromPlayerToMouse() < player.reach && getMouseBlock().stringID.equals("grass") && setMouseBlock(generateBlockObject(block.stringID))) {
                    cell.amount--;
                }
            }
        }
    }
}

Block generateBlockObject(String stringID) {
    switch (stringID) {
        case "dirt":
            return new Dirt();
        case "grass":
            return new Grass();
        case "leaves":
            return new Leaves();
        case "planks":
            return new Planks();
        case "sand":
            return new Sand();
        case "stone":
            return new Stone();
        case "water":
            return new Water();
        case "wood":
            return new Wood();
    }
    return new Grass();
}

void mineBlocksWithMouse() {
    if (leftMouseButtonDown) {
        Block mouseBlock = getMouseBlock();
        if (mouseBlock.isMineable && getDistance_BlocksFromPlayerToMouse() < player.reach) {
            if (mouseBlock.prcntBroken >= 1) {
                player.inventory.addBlockToInventory(mouseBlock);
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

// Returns the inventory slot which the mouse currently hovers. 
// Note that this is not the same as player.mouseItemSlot
ItemSlot getInventorySlotWhichMouseHovers() {
    if (inventoryIsOpen) {
        int inventoryXindex = (mouseX - inventoryUpperLeftXPixel) / pixelsPerItemSlot;
        int inventoryYindex = (mouseY - inventoryUpperLeftYPixel) / pixelsPerItemSlot;
        if (inventoryXindex < 0 || inventoryXindex >= inventoryWidth || inventoryYindex < 0 || inventoryYindex >= inventoryHeight) {
            return null;    
        }
        if (player.inventory.grid[inventoryXindex][inventoryYindex].item != null) {
            System.out.println("Grabbed item: " + (player.inventory.grid[inventoryXindex][inventoryYindex].item));
        }
        return player.inventory.grid[inventoryXindex][inventoryYindex];
    }
    return null;
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
// If chunk has not yet been generated, create it and add it to generatedChunks (chunkCoords is key).
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
        //println(generatedChunks.keySet());
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

void setPlayerBlock(Block block) {
    setBlock(block, player.coords.x, player.coords.y);
}

Block getPlayerBlock() {
    return getBlock(player.coords.x, player.coords.y);
}
