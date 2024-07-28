void updateState() {
    updateBodies();
    updateBullets();
    state.player.handleEnemyAttack();
    handleMouseClicks();
    removeBlockDamageIfNotMining();
    loadVisibleBlocks();
    respawnIfPlayerIsDead();
}

void respawnIfPlayerIsDead() {
    if (state.player.isDead()) {
        state.player.hp = settings.playerMaxHP;
        state.player.inventory.setInventoryEmpty();
        state.player.coords = settings.spawnPoint.copy();
        removeAllMobs();
        closeInventory();
    }
}

float getDistancesBetweenBodiesInBlocks(Body b1, Body b2) {
    PVector b1copy = b1.coords.copy();
    return b1copy.sub(b2.coords).mag();
}

void updateBodies() {
    maybeSpawnMobs();
    removeDeadMobs();
    removeFarMobs();
    updateBodyPositions();
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
        //println("Pixels per block: " + settings.pixelsPerBlock + "x" + settings.pixelsPerBlock);
        makeViewDistanceFitZoomLevel();
    }
}

void setViewDistance(int newViewDistance) {
    if (newViewDistance > 3) {
        settings.viewDistance = newViewDistance;
        state.visibleBlocks = new Block[settings.viewDistance][settings.viewDistance];
        //println("Blocks rendered: " + settings.viewDistance + "x" + settings.viewDistance + " = " + (settings.viewDistance * settings.viewDistance));
    }
}

void updateBodyPositions() {
    for (Body body : state.bodies) {
        body.update();
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

// Modifies and return parameter vector.
// example input: (2.4, 4.3)
// output:        (2.0, 4.0)
PVector floorVector(PVector v) {
    v.x = floor(v.x);
    v.y = floor(v.y);
    return v;
}

void spawnMobIfNotCollidingWithAnother(Mob mobToSpawn) {
    if (!mobToSpawn.isCollidingWithAnotherBody()) {
        state.bodies.add(mobToSpawn);
    }
}

boolean setMouseBlock2d(Block block) {
    PVector distancePlayerToMouse = state.player.getVectorFromMouse();
    return setBlock(block, int(state.player.coords.x - distancePlayerToMouse.x), int(state.player.coords.y - distancePlayerToMouse.y));
}

boolean setMouseBlock3d(Block block) {
    PVector distancePlayerToMouse = state.player.getVectorFromMouse();
    return setBlock(block, int(state.player.coords.x - distancePlayerToMouse.x - settings.offsetFactor3d), int(state.player.coords.y - distancePlayerToMouse.y + settings.offsetFactor3d));
}

// Returns true if actually changed the block.
// Example: if you try to replace a stone block with stone, the block will not change, so function returns false
boolean setBlock(Block block, float x, float y) {
    Chunk chunk = getChunk(new PVector(x, y));
    int xInChunk = int(x) % settings.blocksPerChunk;
    int yInChunk = int(y) % settings.blocksPerChunk;
    if (block.itemID != chunk.blocks[xInChunk][yInChunk].itemID) {
        // Special case for grass. We need to access the special grassColorScheme for the chunk the block is placed in.
        if (block.itemID == ItemID.GRASS) {
            chunk.blocks[xInChunk][yInChunk] = (Block) createItem(ItemID.GRASS);
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
        //println("Generated chunks: " + state.generatedChunks.size());
        //println(state.generatedChunks.keySet());
    }
    return state.generatedChunks.get(chunkCoords);
}

PVector calcChunkCoords(PVector coords) {
    return new PVector(int(coords.x / settings.blocksPerChunk), int(coords.y / settings.blocksPerChunk));
}

Block getBlock(PVector vec) {
    return getBlock(vec.x, vec.y);
}

Block getBlock(float x, float y) {
    Chunk chunk = getChunk(new PVector(x, y));
    return chunk.blocks[int(x) % settings.blocksPerChunk][int(y) % settings.blocksPerChunk];
}

// Saves all generated chunks to a file. One row of blocks is saved as one line of characters.
// Each block is represented by the their respective characters as defined in
// the hashmap blockNamesToChars.
void saveGeneratedChunksToFile() {
    int numberOfLines = 2 + (2 + settings.blocksPerChunk) * state.generatedChunks.size();
    String[] chunkStrings = new String[numberOfLines];
    int currentLineNum = 0;

    // Initialize the strings. This allows for usage of += without first using = when setting values for strings.
    for (int y = 0; y < numberOfLines; y++) {
        chunkStrings[y] = "";
    }

    // Header of file
    chunkStrings[currentLineNum++] = "Saved " + state.generatedChunks.size() + " chunks.";
    currentLineNum++; // empty line

    // Chunks
    for (Map.Entry<PVector, Chunk> entry : state.generatedChunks.entrySet()) {
        PVector chunkCoords = entry.getKey();
        Chunk chunk = entry.getValue();
        chunkStrings[currentLineNum++] = "Chunk at chunk coordinates (" + int(chunkCoords.x) + "," + int(chunkCoords.y) + ")";
        addChunkStringsToArray(chunkStrings, currentLineNum, chunk);
        currentLineNum += settings.blocksPerChunk;
        currentLineNum++; // empty line
    }

    saveStrings("saves/myGameSave/chunkStrings.txt", chunkStrings);
}

// Converts the given chunk to strings and adds them to the given array, starting at startIndex.
void addChunkStringsToArray(String[] arrayToAddTo, int startIndex, Chunk chunk) {
    for (int y = 0; y < settings.blocksPerChunk; y++) {
        for (int x = 0; x < settings.blocksPerChunk; x++) {
            arrayToAddTo[startIndex + y] += getBlockChar(chunk.blocks[x][y].itemID);
        }
    }
}

char getBlockChar(ItemID blockID) {
    return settings.blockIDsToChars.get(blockID);
}

ItemID getBlockName(char blockChar) {
    return settings.blockCharsToIDs.get(blockChar);
}

public boolean squaresAreColliding(PVector coords1, PVector coords2, float width1, float width2) {
    float x1 = coords1.x;
    float y1 = coords1.y;
    float x2 = coords2.x;
    float y2 = coords2.y;
    
    float rectOneRight = x1 + width1;
    float rectOneLeft = x1;
    float rectOneBottom = y1 + width1;
    float rectOneTop = y1;
    
    float rectTwoRight = x2 + width2;
    float rectTwoLeft = x2;
    float rectTwoBottom = y2 + width2;
    float rectTwoTop = y2;

    return 
   (rectOneRight > rectTwoLeft && 
    rectOneLeft < rectTwoRight && 
    rectOneBottom > rectTwoTop && 
    rectOneTop < rectTwoBottom);
}

public boolean circlesAreColliding(PVector coords1, PVector coords2, float diameter1, float diameter2) {
    
    float r1 =  diameter1 / 2;
    float r2 =  diameter2 / 2;
    
    float x1 = coords1.x + r1;
    float y1 = coords1.y + r1;
    float x2 = coords2.x + r2;
    float y2 = coords2.y + r2;
    
    float dx = x2 - x1;
    float dy = y2 - y1;
    float distance = (float) Math.sqrt(dx * dx + dy * dy);
    
    return distance < (r1 + r2);
}

public boolean bodiesAreColliding(Body b1, Body b2) {
    if (b1 == b2) {
        return false;    
    }
    
    return circlesAreColliding(b1.coords, b2.coords, b1.diameterInBlocks, b2.diameterInBlocks);
}

boolean squareIsCollidingWithWall(PVector coords, float widthInBlocks) {
    int left = int(coords.x);
    int right = int(coords.x + widthInBlocks);
    int top = int(coords.y);
    int bottom = int(coords.y + widthInBlocks);
    
    return getBlock(left, top).isWall
        || getBlock(right, top).isWall
        || getBlock(left, bottom).isWall
        || getBlock(right, bottom).isWall;
}

boolean squareIsCollidingWithWallOrWater(PVector coords, float widthInBlocks) {
    int left = int(coords.x);
    int right = int(coords.x + widthInBlocks);
    int top = int(coords.y);
    int bottom = int(coords.y + widthInBlocks);
    
    return getBlock(left, top).isWallOrWater()
        || getBlock(right, top).isWallOrWater()
        || getBlock(left, bottom).isWallOrWater()
        || getBlock(right, bottom).isWallOrWater();
}

List<PVector> bresenhamLine(float x0, float y0, float x1, float y1) {
    List<PVector> line = new ArrayList<>();

    float dx = Math.abs(x1 - x0);
    float dy = Math.abs(y1 - y0);
    float sx = x0 < x1 ? 1 : -1;
    float sy = y0 < y1 ? 1 : -1;
    float err = dx - dy;

    while (true) {
        line.add(new PVector(x0, y0));
        if (x0 == x1 && y0 == y1) {
            break;
        }
        float e2 = 2 * err;
        if (e2 > -dy) {
            err -= dy;
            x0 += sx;
        }
        if (e2 < dx) {
            err += dx;
            y0 += sy;
        }
    }
    return line;
}
