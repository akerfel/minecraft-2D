import java.util.Iterator; //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//

// Global variables
Settings settings;
State state;            // Game state

// This function is called once, at startup
void setup() {
    //fullScreen();
    size(1200, 1200);

    settings = new Settings();
    settings.initialize();

    state = new State();
    state.intialize();
}

// This is the main game loop (called ~60 times per second)
void draw() {
    updateState();
    drawState();
}

void updateState() {
    updateBodies();
    updateBlocks();
}

void drawState() {
    background(0);
    drawWorld();
    drawUI();
}

void updateBlocks() {
    loadVisibleBlocks();
    placeOrMineBlock();
    removeBlockDamageIfNotMining();
}

void updateBodies() {
    maybeSpawnMobs();
    removeFarMobs();
    updateBodyPositions();
}

void placeOrMineBlock() {
    if (!state.inventoryIsOpen) {
        placeBlockWithMouse();
        mineBlockWithMouse();
    }
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

void removeFarMobs() {
    Iterator<Body> it = state.bodies.iterator();
    while (it.hasNext()) {
        Body body = it.next();
        if (body instanceof Mob) {
            if (state.player.coords.dist(((Mob) body).coords) > settings.mobDespawnRange) {
                it.remove();
            }
        }
    }
}

void maybeSpawnMobs() {
    if (state.bodies.size() < settings.maxMobs) {
        if (random(0, 1) < settings.pigSpawnChance) {
            spawnMob(MobType.PIG);
        }
        if (random(0, 1) < settings.zombieSpawnChance) {
            spawnMob(MobType.ZOMBIE);
        }
    }
}

void spawnMob(MobType mobType) {
    float xSpawn = int(state.player.coords.x + random(-settings.mobSpawnRange, settings.mobSpawnRange));
    float ySpawn = int(state.player.coords.y + random(-settings.mobSpawnRange, settings.mobSpawnRange));
    if (!getBlock(xSpawn, ySpawn).isWallOrWater()) {
        switch(mobType) {
        case PIG:
            spawnMobIfNotCollidingWithAnother(new Pig(xSpawn + 0.1, ySpawn + 0.1));
            return;
        case ZOMBIE: 
            spawnMobIfNotCollidingWithAnother(new Zombie(xSpawn + 0.1, ySpawn + 0.1)); 
            return;
        }   
    }   
}

void spawnMobIfNotCollidingWithAnother(Mob mobToSpawn) {
    if (!mobToSpawn.isCollidingWithAnotherBody()) {
        state.bodies.add(mobToSpawn);
    }
}
 
void placeBlockWithMouse() { 
    if (state.rightMouseButtonDown) {
        ItemSlot slot = state.player.inventory.getHotbarSlot(state.player.inventory.hotbarIndexSelected);   
        if (slot.item.itemType == ItemType.BLOCK) {   
            Block block = (Block) slot.item;
            if (slot.getCount() != 0) {
                if (getDistance_BlocksFromPlayerToMouse() < state.player.reach &&
                    (getMouseBlock().itemID == ItemID.GRASS || getMouseBlock().itemID == ItemID.WATER) &&
                    setMouseBlock((Block) createItem(block.itemID))) {
                    slot.count--;
                }
            }
        }
    }
}

void mineBlockWithMouse() {
    if (state.leftMouseButtonDown) {
        Block mouseBlock = getMouseBlock();
        if (mouseBlock.isMineable && getDistance_BlocksFromPlayerToMouse() < state.player.reach) {
            if (mouseBlock.prcntBroken >= 1) {
                state.player.inventory.addItem(mouseBlock);
                setMouseBlock((Block) createItem(ItemID.GRASS));    // Correct chunk grass color is handled inside function
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
            //println("Grabbed item: " + (state.player.inventory.grid[inventoryXindex][inventoryYindex].item));
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
    float yPixelsFromPlayerToMouse = height / 2 - mouseY;
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

Block getBlockRelativeToPlayer(int xdiff, int ydiff) {
    return getBlock(state.player.coords.x + xdiff, state.player.coords.y + ydiff);
}

Chunk getPlayerChunk() {
    return getChunk(state.player.coords);
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

public boolean bodiesAreColliding(Body b1, Body b2) {
    if (b1 == b2) {
        return false;    
    }
    
    return squaresAreColliding(b1.coords, b2.coords, b1.widthInBlocks, b2.widthInBlocks);
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
