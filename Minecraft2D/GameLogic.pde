import java.util.Iterator;

void updateLogic() {
    state.player.move();
    updateBlocks();
    updateMobs();
}

void updateBlocks() {
    loadVisibleBlocks();
    if (!state.inventoryIsOpen) {
        placeBlocksWithMouse();
        mineBlocksWithMouse();
    }
    removeBlockDamageIfNotMining();
}

void updateMobs() {
    maybeSpawnMob();
    removeFarMobs();
    updateMobsPos();
}

void makeViewDistanceFitZoomLevel() {
    int numBlocksVisible = width / settings.pixelsPerBlock;
    setViewDistance(numBlocksVisible + 4);
}

// This function is called each frame.
// I tried to only call this each time the state.player stepped on a new block, but it did not seem to improve the fps.
// That also introduced other problems (block would not be mined until stepped new block), so I chose to keep it like this.
void loadVisibleBlocks() {
    for (int x = 0; x < settings.viewDistance; x++) {
        for (int y = 0; y < settings.viewDistance; y++) {
            state.visibleBlocks[x][y] = getBlock(state.player.coords.x + x - settings.viewDistance/2, state.player.coords.y + y - settings.viewDistance/2);
        }
    }
}

void setNoStrokeModeDependingOnSetting() {
    if (settings.noStrokeMode) {
        noStroke();
    }
}

void zoom(int changeInPixelsPerBlock) {
    int oldPixelsPerBlock = settings.pixelsPerBlock;
    settings.pixelsPerBlock += changeInPixelsPerBlock;
    if (settings.pixelsPerBlock < 1) {
        settings.pixelsPerBlock = 1;
    }
    if (oldPixelsPerBlock != settings.pixelsPerBlock) {
        println("Pixels per block: " + settings.pixelsPerBlock + "x" + settings.pixelsPerBlock);
        resetObjectsDependingOnPixelsPerBlock();
        makeViewDistanceFitZoomLevel();
    }
}

void setViewDistance(int newViewDistance) {
    if (newViewDistance > 3) {
        settings.viewDistance = newViewDistance;
        state.visibleBlocks = new Block[settings.viewDistance][settings.viewDistance];
        println("Blocks rendered: " + settings.viewDistance + "x" + settings.viewDistance + " = " + (settings.viewDistance * settings.viewDistance));
    }
}

void updateMobsPos() {
    for (Mob mob : state.mobs) {
        mob.update();
    }
}

void removeBlockDamageIfNotMining() {
    if (!state.leftMouseButtonDown) {
        Iterator<Block> it = state.damagedBlocks.iterator();
        while (it.hasNext()) {
            it.next().removeDamage();
            it.remove();
        }
    }
}

void removeFarMobs() {
    Iterator<Mob> it = state.mobs.iterator();
    while (it.hasNext()) {
        Mob mob = it.next();
        if (state.player.coords.dist(mob.coords) > settings.mobDespawnRange) {
            it.remove();
        }
    }
}

void maybeSpawnMob() {
    if (state.mobs.size() < settings.maxMobs && random(0, 1) < settings.mobSpawnChance) {
        spawnMob();
    }
}

void spawnMob() {
    float xSpawn = int(state.player.coords.x + random(-settings.mobSpawnRange, settings.mobSpawnRange));
    float ySpawn = int(state.player.coords.y + random(-settings.mobSpawnRange, settings.mobSpawnRange));
    if (!getBlock(xSpawn, ySpawn).isWallOrWater()) {
        state.mobs.add(new Mob(xSpawn + 0.1, ySpawn + 0.1));    // + 0.1 so it does not spawn at exact corner of block (looks weird)
    }
}

void resetObjectsDependingOnPixelsPerBlock() {
    settings.playerWidth = settings.pixelsPerBlock / 2;
    settings.mobWidth = settings.pixelsPerBlock / 2;
}

void placeBlocksWithMouse() {
    if (state.rightMouseButtonDown) {
        ItemSlot cell = state.player.inventory.getHotbarSlot(state.player.inventory.hotbarIndexSelected);
        if (cell.item.type.equals("block")) {
            Block block = (Block) cell.item;
            if (cell.amount != 0) {
                if (getDistance_BlocksFromPlayerToMouse() < state.player.reach && getMouseBlock().stringID.equals("grass") && setMouseBlock(generateBlockObject(block.stringID))) {
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
    if (state.leftMouseButtonDown) {
        Block mouseBlock = getMouseBlock();
        if (mouseBlock.isMineable && getDistance_BlocksFromPlayerToMouse() < state.player.reach) {
            if (mouseBlock.prcntBroken >= 1) {
                state.player.inventory.addBlock(mouseBlock);
                setMouseBlock(new Grass());    // Correct chunk grass color is handled inside function
            } else {
                mouseBlock.mineBlock();
                state.damagedBlocks.add(mouseBlock);
            }
        }
    }
}

Block getMouseBlock() {
    PVector distancePlayerToMouse = getVector_BlocksFromPlayerToMouse();
    return getBlock(int(state.player.coords.x - distancePlayerToMouse.x), int(state.player.coords.y - distancePlayerToMouse.y));
}

// Returns the inventory slot which the mouse currently hovers.
// Note that this is not the same as state.player.mouseItemSlot
ItemSlot getInventorySlotWhichMouseHovers() {
    if (state.inventoryIsOpen) {
        if (mouseX < settings.inventoryUpperLeftXPixel || mouseY < settings.inventoryUpperLeftYPixel) return null;
        int inventoryXindex = (mouseX - settings.inventoryUpperLeftXPixel) / settings.pixelsPerItemSlot;
        int inventoryYindex = (mouseY - settings.inventoryUpperLeftYPixel) / settings.pixelsPerItemSlot;
        if (inventoryXindex < 0 || inventoryXindex >= settings.inventoryWidth || inventoryYindex < 0 || inventoryYindex >= settings.inventoryHeight) {
            return null;
        }
        if (state.player.inventory.grid[inventoryXindex][inventoryYindex].item != null) {
            System.out.println("Grabbed item: " + (state.player.inventory.grid[inventoryXindex][inventoryYindex].item));
        }
        return state.player.inventory.grid[inventoryXindex][inventoryYindex];
    }
    return null;
}

boolean setMouseBlock(Block block) {
    PVector distancePlayerToMouse = getVector_BlocksFromPlayerToMouse();
    return setBlock(block, int(state.player.coords.x - distancePlayerToMouse.x), int(state.player.coords.y - distancePlayerToMouse.y));
}

PVector getVector_BlocksFromPlayerToMouse() {
    float xPixelsFromPlayerToMouse = width / 2 - mouseX;
    float yPixelsFromPlayerToMouse = width / 2 - mouseY;
    float xBlocksFromPlayerToMouse = xPixelsFromPlayerToMouse / settings.pixelsPerBlock;
    float yBlocksFromPlayerToMouse = yPixelsFromPlayerToMouse / settings.pixelsPerBlock;
    return new PVector(xBlocksFromPlayerToMouse, yBlocksFromPlayerToMouse);
}

// Returns a float, total distance (in block lengths) from mouse to state.player
float getDistance_BlocksFromPlayerToMouse() {
    PVector distancePlayerToMouse = getVector_BlocksFromPlayerToMouse();
    return distancePlayerToMouse.dist(new PVector(0, 0));    // simply pyth. theorem
}

// Returns true if actually changed the block.
// Example: if you try to replace a stone block with stone, the block will not change, so function returns false
boolean setBlock(Block block, float x, float y) {
    Chunk chunk = getChunk(new PVector(x, y));
    int xInChunk = int(x) % settings.blocksPerChunk;
    int yInChunk = int(y) % settings.blocksPerChunk;
    if (!block.toString().equals(chunk.blocks[xInChunk][yInChunk].toString())) {
        // Special case for grass. We need to access the special grassColorScheme for the chunk the block is placed in.
        if (block.toString().equals("grass")) {
            chunk.blocks[xInChunk][yInChunk] = new Grass(getChunk(new PVector(x, y)).grassColorScheme);
        } else {
            chunk.blocks[xInChunk][yInChunk] = block;
        }
        return true;
    }
    return false;
}

// Takes state.player coords, converts them into chunkCoords and loads that chunk from state.generatedChunks.
// If chunk has not yet been generated, create it and add it to state.generatedChunks (chunkCoords is key).
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
    if (!state.generatedChunks.containsKey(chunkCoords)) {
        state.generatedChunks.put(chunkCoords, new Chunk(chunkCoords));
        println("Generated chunks: " + state.generatedChunks.size());
        //println(state.generatedChunks.keySet());
    }
    return state.generatedChunks.get(chunkCoords);
}

PVector calcChunkCoords(PVector coords) {
    return new PVector(int(coords.x / settings.blocksPerChunk), int(coords.y / settings.blocksPerChunk));
}

Block getBlock(float x, float y) {
    Chunk chunk = getChunk(new PVector(x, y));
    return chunk.blocks[int(x) % settings.blocksPerChunk][int(y) % settings.blocksPerChunk];
}

void setPlayerBlock(Block block) {
    setBlock(block, state.player.coords.x, state.player.coords.y);
}

Block getPlayerBlock() {
    return getBlock(state.player.coords.x, state.player.coords.y);
}

Chunk getPlayerChunk() {
    return getChunk(state.player.coords);
}

// Saves a chunk as a file
void chunkToFile(Chunk chunk) {
    String[] chunkString = new String[settings.blocksPerChunk];
    
    // Initialize the strings (otherwise they would all start with 'null');
    for (int y = 0; y < settings.blocksPerChunk; y++) {
        chunkString[y] = "";    
    }
    
    for (int y = 0; y < settings.blocksPerChunk; y++) {
        for (int x = 0; x < settings.blocksPerChunk; x++) {
            chunkString[y] += chunk.blocks[x][y] + " ";
        }
    }
    
    saveStrings("savedChunks/chunkString.txt", chunkString);
}
