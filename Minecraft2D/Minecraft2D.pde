import java.util.Iterator;

// Global variables
Cheats cheats;
Settings settings;
State state;            // Game state

// This function is called once, at startup
void setup() {
    //fullScreen();
    size(1200, 1200);

    cheats = new Cheats();
    cheats.intialize();

    settings = new Settings();
    settings.initialize();

    state = new State();
    state.intialize();
}

// This is the main game loop (called ~60 times per second)
void draw() {
    updateLogic();
    drawEverything();
}

void updateLogic() {
    state.player.move();
    updateBlocks();
    updateMobs();
}

void drawEverything() {
    background(0);
    drawWorld();
    drawUI();
    println("mobs: " + state.mobs.size());
}

void keyPressed() {
    if (key == 'x') {
        for (int i = 0; i < 5; i++) {
            state.player.inventory.addItem(createItem(ItemID.STONE));
        }
    }

    state.player.setMove(keyCode, true);

    int numberKeyClicked = int(key) - 49;
    if (numberKeyClicked >= 0 && numberKeyClicked <= 8) {
        state.player.inventory.hotbarIndexSelected = numberKeyClicked;
    }

    if (key == '+') {
        zoom(1);
    } else if (key == '-') {
        zoom(-1);
    }

    if (key == 'e') {
        if (state.inventoryIsOpen) {
            state.player.inventory.returnMouseGrabbedItemToInventory();
        }
        state.craftingMenuIsOpen = false;
        state.inventoryIsOpen = !state.inventoryIsOpen;
    }

    if (key == 'c') {
        state.craftingMenuIsOpen = !state.craftingMenuIsOpen;
        printPlayerCraftableItemsInConsole();
    }

    if (key == '.') {
        setViewDistance(settings.viewDistance - 2);
    }

    if (key == 'f') {
        state.rightMouseButtonDown = true;
    }

    if (key == 't') {
        saveGeneratedChunksToFile();
    }

    if (key == 'h') {
        cheats.canWalkThroughWalls = !cheats.canWalkThroughWalls;
        if (cheats.canWalkThroughWalls) {
            println("Player can walk through walls");
        } else {
            println("Player can not walk through walls");
        }
    }

    if (key == CODED) {
        if (keyCode == SHIFT) {
            state.player.isRunning = true;
        }
        //if (keyCode == ALT) {
        //    state.player.isRunningSuperSpeed = true;
        //}
        // F3 has keycode 114
        if (keyCode == 114) {
            state.debugScreenIsShowing = !state.debugScreenIsShowing;
        }
    }
}

void keyReleased() {
    state.player.setMove(keyCode, false);

    if (key == 'f') {
        state.rightMouseButtonDown = false;
    }

    if (key == CODED) {
        if (keyCode == SHIFT) {
            state.player.isRunning = false;
        }
        if (keyCode == ALT) {
            state.player.isRunningSuperSpeed = false;
        }
    }
}

void mousePressed() {
    if (mouseButton == RIGHT) {
        state.rightMouseButtonDown = true;
    } else if (mouseButton == LEFT) {
        state.leftMouseButtonDown = true;
        if (state.inventoryIsOpen) {
            ItemSlot clickedItemSlot = getInventorySlotWhichMouseHovers();
            if (clickedItemSlot != null) {
                ItemSlot currentMouseHeldItemSlot = state.player.inventory.mouseHeldItemSlot;
                int inventoryXindex = (mouseX - settings.inventoryUpperLeftXPixel) / settings.pixelsPerItemSlot;
                int inventoryYindex = (mouseY - settings.inventoryUpperLeftYPixel) / settings.pixelsPerItemSlot;
                state.player.inventory.grabbedXindex = inventoryXindex;
                state.player.inventory.grabbedYindex = inventoryYindex;
                state.player.inventory.grid[inventoryXindex][inventoryYindex] = currentMouseHeldItemSlot;
                state.player.inventory.mouseHeldItemSlot = clickedItemSlot;
            }
        }
    }
}

void mouseReleased() {
    if (mouseButton == RIGHT) {
        state.rightMouseButtonDown = false;
    } else if (mouseButton == LEFT) {
        state.leftMouseButtonDown = false;
    }
}

void mouseWheel(MouseEvent event) {
    if (keyPressed && key == 't') {
        // Scroll up
        if (event.getCount() > 0) {
            zoom(-1);
        }
        // Scroll down
        else {
            zoom(1);
        }
    } else {
        // Scroll up
        if (event.getCount() > 0) {
            state.player.inventory.hotbarIndexSelected++;
            if (state.player.inventory.hotbarIndexSelected >= settings.inventoryWidth) {
                state.player.inventory.hotbarIndexSelected = 0;
            }
        }
        // Scroll down
        else {
            state.player.inventory.hotbarIndexSelected--;
            if (state.player.inventory.hotbarIndexSelected < 0) {
                state.player.inventory.hotbarIndexSelected = settings.inventoryWidth - 1;
            }
        }
    }
}

void updateBlocks() {
    loadVisibleBlocks();
    placeOrMineBlock();
    removeBlockDamageIfNotMining();
}

void updateMobs() {
    maybeSpawnMobs();
    removeFarMobs();
    updateMobsPos();
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
        println("Pixels per block: " + settings.pixelsPerBlock + "x" + settings.pixelsPerBlock);
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

void maybeSpawnMobs() {
    if (state.mobs.size() < settings.maxMobs) {
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
        } //<>// //<>//
    }
}

void spawnMobIfNotCollidingWithAnother(Mob mobToSpawn) {
    if (!mobToSpawn.isCollidingWithAnotherMob()) {
        state.mobs.add(mobToSpawn);
    }
}

void placeBlockWithMouse() {
    if (state.rightMouseButtonDown) {
        ItemSlot slot = state.player.inventory.getHotbarSlot(state.player.inventory.hotbarIndexSelected); //<>// //<>//
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

public float getMobWidthInPixel() {
    return settings.mobWidthInBlocks * settings.pixelsPerBlock;    
}

public boolean mobsAreColliding(Mob m1, Mob m2) {
    if (m1 == m2) {
        return false;    
    }
    
    float w = settings.mobWidthInBlocks;
    float x1 = m1.coords.x;
    float y1 = m1.coords.y;
    float x2 = m2.coords.x;
    float y2 = m2.coords.y;
    
    float rectOneRight = x1 + w;
    float rectOneLeft = x1;
    float rectOneBottom = y1 + w;
    float rectOneTop = y1;
    
    float rectTwoRight = x2 + w;
    float rectTwoLeft = x2;
    float rectTwoBottom = y2 + w;
    float rectTwoTop = y2;

    return 
   (rectOneRight > rectTwoLeft && 
    rectOneLeft < rectTwoRight && 
    rectOneBottom > rectTwoTop && 
    rectOneTop < rectTwoBottom);
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
