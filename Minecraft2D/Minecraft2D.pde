import java.util.Iterator;

// Global variables
Cheats cheats;
Settings settings;
State state;            // Game state

enum ToolType {
    SWORD,
    PICKAXE,
    SHOVEL,
    AXE,
    HOE,
    NOTYPE
}

enum ToolMaterial {
    WOOD,
    STONE,
    IRON,
    GOLD,
    DIAMOND
}

enum ItemType {
    BLOCK,
    TOOL,
    OTHER
}

public enum ItemID {
    DIRT,
    GRASS,
    LEAVES,
    PLANKS,
    SAND,
    STONE,
    IRON_ORE,
    WATER,
    WOOD,
   
    WORKBENCH,
    
    WOOD_SWORD,
    WOOD_PICKAXE,
    WOOD_SHOVEL,
    WOOD_AXE,
    WOOD_HOE,
    
    STONE_SWORD,
    STONE_PICKAXE,
    STONE_SHOVEL,
    STONE_AXE,
    STONE_HOE,
    
    IRON_SWORD,
    IRON_PICKAXE,
    IRON_SHOVEL,
    IRON_AXE,
    IRON_HOE,
    
    GOLD_SWORD,
    GOLD_PICKAXE,
    GOLD_SHOVEL,
    GOLD_AXE,
    GOLD_HOE,
    
    DIAMOND_SWORD,
    DIAMOND_PICKAXE,
    DIAMOND_SHOVEL,
    DIAMOND_AXE,
    DIAMOND_HOE
}

// This function is called once, at startup
void setup() {
    //fullScreen();
    size(1200, 1200);

    // Initialize cheats, settings and state
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
}

// --- Input.java ---

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

// --- GameLogic.java

void updateBlocks() {
    loadVisibleBlocks();
    placeOrMineBlock();
    removeBlockDamageIfNotMining();
}

void updateMobs() {
    maybeSpawnMob();
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

void placeBlockWithMouse() {
    if (state.rightMouseButtonDown) {
        ItemSlot slot = state.player.inventory.getHotbarSlot(state.player.inventory.hotbarIndexSelected); //<>//
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

// This method holds all item definitions. All item objects should be created with this method.
Item createItem(ItemID itemID) {
    switch (itemID) {
        case DIRT:
            return new Block(itemID, color(151, 109, 77), false, ToolType.SHOVEL, true);
        case GRASS:
            return new Block(itemID, color(127, 178, 56) + color(random(-15, 15), random(-15, 15), random(-15, 15)), false, ToolType.SHOVEL, false);
        case LEAVES:
            return new Block(itemID, color(0, 124, 0) + color(random(-30, 30), random(-0, 30), random(-30, 30)), true, ToolType.AXE, true);
        case PLANKS:
            return new Block(itemID, color(194, 155, 115), true, ToolType.AXE, true);
        case SAND:
            return new Block(itemID, color(247, 233, 163), false, ToolType.SHOVEL, true);
        case STONE:
            return new Block(itemID, color(112, 112, 112) + color(random(-8, 8), random(-8, 8), random(-8, 8)), true, ToolType.PICKAXE, true);
        case IRON_ORE:
            return new Block(itemID, color(223, 223, 225), true, ToolType.PICKAXE, true);
        case WATER:
            return new Block(itemID, color(64, 64, 255) + color(random(-15, 15), random(-15, 15), 0), false, ToolType.NOTYPE, false);
        case WOOD:
            return new Block(itemID, color(174, 125, 90), true, ToolType.AXE, true);
        case WORKBENCH:
            return new Block(itemID, color(217, 177, 140), true, ToolType.AXE, true);

        case WOOD_SWORD:
            return new Tool(itemID, ToolType.SWORD, ToolMaterial.WOOD, settings.woodToolMiningMultiplier, settings.colorWoodTool);
        case WOOD_PICKAXE:
            return new Tool(itemID, ToolType.PICKAXE, ToolMaterial.WOOD, settings.woodToolMiningMultiplier, settings.colorWoodTool);
        case WOOD_SHOVEL:
            return new Tool(itemID, ToolType.SHOVEL, ToolMaterial.WOOD, settings.woodToolMiningMultiplier, settings.colorWoodTool);
        case WOOD_AXE:
            return new Tool(itemID, ToolType.AXE, ToolMaterial.WOOD, settings.woodToolMiningMultiplier, settings.colorWoodTool);
        case WOOD_HOE:
            return new Tool(itemID, ToolType.HOE, ToolMaterial.WOOD, settings.woodToolMiningMultiplier, settings.colorWoodTool);
        
        case STONE_SWORD:
            return new Tool(itemID, ToolType.SWORD, ToolMaterial.STONE, settings.stoneToolMiningMultiplier, settings.colorStoneTool);
        case STONE_PICKAXE:
            return new Tool(itemID, ToolType.PICKAXE, ToolMaterial.STONE, settings.stoneToolMiningMultiplier, settings.colorStoneTool);
        case STONE_SHOVEL:
            return new Tool(itemID, ToolType.SHOVEL, ToolMaterial.STONE, settings.stoneToolMiningMultiplier, settings.colorStoneTool);
        case STONE_AXE:
            return new Tool(itemID, ToolType.AXE, ToolMaterial.STONE, settings.stoneToolMiningMultiplier, settings.colorStoneTool);
        case STONE_HOE:
            return new Tool(itemID, ToolType.HOE, ToolMaterial.STONE, settings.stoneToolMiningMultiplier, settings.colorStoneTool);
        
        case IRON_SWORD:
            return new Tool(itemID, ToolType.SWORD, ToolMaterial.IRON, settings.ironToolMiningMultiplier, settings.colorIronTool);
        case IRON_PICKAXE:
            return new Tool(itemID, ToolType.PICKAXE, ToolMaterial.IRON, settings.ironToolMiningMultiplier, settings.colorIronTool);
        case IRON_SHOVEL:
            return new Tool(itemID, ToolType.SHOVEL, ToolMaterial.IRON, settings.ironToolMiningMultiplier, settings.colorIronTool);
        case IRON_AXE:
            return new Tool(itemID, ToolType.AXE, ToolMaterial.IRON, settings.ironToolMiningMultiplier, settings.colorIronTool);
        case IRON_HOE:
            return new Tool(itemID, ToolType.HOE, ToolMaterial.IRON, settings.ironToolMiningMultiplier, settings.colorIronTool);
            
        case GOLD_SWORD:
            return new Tool(itemID, ToolType.SWORD, ToolMaterial.GOLD, settings.goldToolMiningMultiplier, settings.colorGoldTool);
        case GOLD_PICKAXE:
            return new Tool(itemID, ToolType.PICKAXE, ToolMaterial.GOLD, settings.goldToolMiningMultiplier, settings.colorGoldTool);
        case GOLD_SHOVEL:
            return new Tool(itemID, ToolType.SHOVEL, ToolMaterial.GOLD, settings.goldToolMiningMultiplier, settings.colorGoldTool);
        case GOLD_AXE:
            return new Tool(itemID, ToolType.AXE, ToolMaterial.GOLD, settings.goldToolMiningMultiplier, settings.colorGoldTool);
        case GOLD_HOE:
            return new Tool(itemID, ToolType.HOE, ToolMaterial.GOLD, settings.goldToolMiningMultiplier, settings.colorGoldTool);
        
        case DIAMOND_SWORD:
            return new Tool(itemID, ToolType.SWORD, ToolMaterial.DIAMOND, settings.diamondToolMiningMultiplier, settings.colorDiamondTool);
        case DIAMOND_PICKAXE:
            return new Tool(itemID, ToolType.PICKAXE, ToolMaterial.DIAMOND, settings.diamondToolMiningMultiplier, settings.colorDiamondTool);
        case DIAMOND_SHOVEL:
            return new Tool(itemID, ToolType.SHOVEL, ToolMaterial.DIAMOND, settings.diamondToolMiningMultiplier, settings.colorDiamondTool);
        case DIAMOND_AXE:
            return new Tool(itemID, ToolType.AXE, ToolMaterial.DIAMOND, settings.diamondToolMiningMultiplier, settings.colorDiamondTool);
        case DIAMOND_HOE:
            return new Tool(itemID, ToolType.HOE, ToolMaterial.DIAMOND, settings.diamondToolMiningMultiplier, settings.colorDiamondTool);
        
        default:
            throw new IllegalArgumentException("Invalid ItemID: " + itemID);
    }
}

private void mapBlockNamesToCharacters() {// Maps block names to block chars.
    // E.g. "wood" could map to "w".
    settings.blockIDsToChars = Map.ofEntries(
        entry(ItemID.DIRT, 'd'),
        entry(ItemID.GRASS, '_'),
        entry(ItemID.LEAVES, 'l'),
        entry(ItemID.PLANKS, 'p'),
        entry(ItemID.SAND, 's'),
        entry(ItemID.STONE, 'S'),
        entry(ItemID.WATER, '~'),
        entry(ItemID.WOOD, 'w'),
        entry(ItemID.IRON_ORE, 'i')
    );

    // blockCharsToNames is a reverse map of blockNamesToChars
    settings.blockCharsToIDs =
        settings.blockIDsToChars.entrySet()
        .stream()
        .collect(Collectors.toMap(Map.Entry::getValue, Map.Entry::getKey));
}

// DrawWorld.java

void drawWorld() {
    drawVisibleBlocks();
    drawMobs();
    drawPlayer();
}

void drawVisibleBlocks() {
    // xPixels and yPixels store the top left corner pixel positions of each block
    float[] xPixels = new float[settings.viewDistance];
    float[] yPixels = new float[settings.viewDistance];
    float xPlayerPixelOffset = (state.player.coords.x % 1) * settings.pixelsPerBlock;
    float yPlayerPixelOffset = (state.player.coords.y % 1) * settings.pixelsPerBlock;
    for (float i = 0; i < settings.viewDistance; i++) {
        float xPos = width/2 + (i - settings.viewDistance/2) * settings.pixelsPerBlock;
        float yPos = height/2 + (i - settings.viewDistance/2) * settings.pixelsPerBlock;
        xPixels[int(i)] = xPos - xPlayerPixelOffset;
        yPixels[int(i)] = yPos - yPlayerPixelOffset;
    }

    for (int y = 0; y < settings.viewDistance; y++) {
        for (int x = 0; x < settings.viewDistance; x++) {
            drawBlock(state.visibleBlocks[int(x)][int(y)], xPixels[x], yPixels[y]);
        }
    }
}

void drawBlock(Block block, float xPixel, float yPixel) {
    fill(block.c);
    square(xPixel, yPixel, settings.pixelsPerBlock + 1);
    
    if (settings.drawInnerSquaresInBlocks) {
        drawInnerSquareInBlock(block, xPixel, yPixel);
    }
    
    if (block.prcntBroken > 0) {
        drawBlockBreakingTexture(block, xPixel, yPixel);
    }
}

private void drawInnerSquareInBlock(Block block, float xPixel, float yPixel) {
    int colorDiff = 10;
    int innerRedValue = max(0, int(red(block.c)) - colorDiff);
    int innerGreenValue = max(0, int(green(block.c)) - colorDiff);
    int innerBlueValue = max(0, int(blue(block.c)) - colorDiff);
    color innerColor = color(innerRedValue, innerGreenValue, innerBlueValue);
    fill(innerColor);
    int offset = int(settings.pixelsPerBlock * settings.offsetInnerSquare);
    square(xPixel + offset, yPixel + offset, settings.pixelsPerBlock - offset * 2);
}

void drawBlockBreakingTexture(Block block, float xPixel, float yPixel) {
    fill(block.prcntBroken * 255);
    circle(xPixel + settings.pixelsPerBlock/2, yPixel + settings.pixelsPerBlock/2, (block.prcntBroken * settings.pixelsPerBlock));
}

void drawMobs() {
    for (Mob mob : state.mobs) {
        drawMob(mob);
    }
}

void drawMob(Mob mob) {
    float xBlocksToPlayer = mob.coords.x - state.player.coords.x;
    float yBlocksToPlayer = mob.coords.y - state.player.coords.y;
    float x = width/2 + xBlocksToPlayer * settings.pixelsPerBlock;
    float y = height/2 + yBlocksToPlayer * settings.pixelsPerBlock;
    fill(mob.c);
    square(x, y, settings.mobWidth);
}

void drawPlayer() {
    fill(216, 127, 51);
    square(width/2, height/2, settings.playerWidth);
}

// DrawUI.java

void drawUI() {
    drawInventoryIfOpen();
    drawCraftingMenuIfOpen();
    drawHotbar();
    drawDebugMenuIfOpen();
    drawMouseItemSlot();
}

void drawDebugMenuIfOpen() {
    if (state.debugScreenIsShowing) {
        fill(240);
        textAlign(CORNER);

        // FPS
        text("fps: " + int(frameRate), 5, 20);

        // The player's current block coordinates
        text("Block: " + int(state.player.coords.x) + " / " + int(state.player.coords.y), 5, 40);

        // The player's current chunk coordinates
        //PVector playerChunkCoords = blockCoordsToChunkCoords(state.player.coords);
        //text("Chunk: " + int(playerChunkCoords.x) + " / " + int(playerChunkCoords.y), 5, 60);
    }
}

void drawInventoryIfOpen() {
    if (state.inventoryIsOpen) {
        stroke(0);
        for (int y = 0; y < settings.inventoryHeight; y++) {
            for (int x = 0; x < settings.inventoryWidth; x++) {
                ItemSlot itemSlot = state.player.inventory.grid[x][y];
                int xPixel = settings.inventoryUpperLeftXPixel + x * settings.pixelsPerItemSlot;
                int yPixel = settings.inventoryUpperLeftYPixel + y * settings.pixelsPerItemSlot;
                drawItemSlot(itemSlot, xPixel, yPixel, false);
            }
        }
        if (settings.noStrokeMode) {
            noStroke();
        }
    }
}

void drawCraftingMenuIfOpen() {
        
}

public void printPlayerCraftableItemsInConsole() {
    println("");
    println("Craftable items:");
    for (ItemCount itemCount : state.player.getHandCraftableItems()) {
        println(itemCount.item + " * " + itemCount.count);
    }    
}

// This function is similar to drawInventoryIfOpen, except the y coordinate is fixed,
// and the currently selected hotbar slot will be highlighted.
void drawHotbar() {
    stroke(0);
    int yPixel = height - settings.pixelsPerItemSlot;
    for (int x = 0; x < settings.inventoryWidth; x++) {
        int xPixel = settings.inventoryUpperLeftXPixel + x * settings.pixelsPerItemSlot;
        ItemSlot itemSlot = state.player.inventory.getHotbarSlot(x);
        boolean highlightBackground = false;
        if (x == state.player.inventory.hotbarIndexSelected) {
            highlightBackground = true;
        }
        drawItemSlot(itemSlot, xPixel, yPixel, highlightBackground);
    }
    if (settings.noStrokeMode) {
        noStroke();
    }
}

void drawMouseItemSlot() {
    stroke(0);
    if (state.player.inventory.mouseHeldItemSlot.getCount() != 0) {
        drawItemInItemSlot(state.player.inventory.mouseHeldItemSlot, mouseX, mouseY);
    }
    if (settings.noStrokeMode) {
        noStroke();
    }
}

// Draws an itemSlot with center at (xPixel, yPixel)
void drawItemSlot(ItemSlot itemSlot, int xPixel, int yPixel, boolean highlightBackground) {
    drawItemSlotBackground(xPixel, yPixel, highlightBackground);
    // We will specifiy the center of each itemSlot
    int xPixelCenterOfItemSlot = xPixel + settings.pixelsPerItemSlot / 2;
    int yPixelCenterOfItemSlot = yPixel + settings.pixelsPerItemSlot / 2;
    drawItemInItemSlot(itemSlot, xPixelCenterOfItemSlot, yPixelCenterOfItemSlot);
}

void drawItemSlotBackground(int xPixel, int yPixel, boolean highlightBackground) {
    fill(150, 150, 150);
    if (highlightBackground) {
        fill(210, 210, 210);
    }
    square(xPixel, yPixel, settings.pixelsPerItemSlot);
}

// (xPixel, yPixel) should be the center of the drawn Item.
void drawItemInItemSlot(ItemSlot itemSlot, int xPixel, int yPixel) {
    rectMode(CENTER);
    Item item = itemSlot.item;
    if (itemSlot.getCount() != 0) {
        switch (item.itemType) {
        case BLOCK:
            drawBlockInItemSlot(itemSlot, xPixel, yPixel);
            break;
        case TOOL:
            drawToolInItemSlot(itemSlot, xPixel, yPixel);
            break;
        }
    }
    rectMode(CORNER);
}

void drawBlockInItemSlot(ItemSlot itemSlot, int xPixel, int yPixel) {
    rectMode(CENTER);
    Block block = (Block) itemSlot.item;

    // Can not call drawBlock() function here, because that ones size changes with settings.pixelsPerBlock
    fill(block.c);
    square(xPixel, yPixel, settings.pixelsPerItemSlot / 2);

    // Write amount
    textSize(24);
    textAlign(CENTER, BOTTOM);
    fill(255, 255, 255);
    text(itemSlot.getCount(), xPixel, yPixel);
    rectMode(CORNER);

    // Write tool name (temporary solution, until specific images for tools are added)
    textSize(10);
    textAlign(CENTER, BOTTOM);
    fill(255, 255, 255);
    text(block.toString(), xPixel, yPixel + settings.pixelsPerItemSlot / 2);
    rectMode(CORNER);
}

void drawToolInItemSlot(ItemSlot itemSlot, int xPixel, int yPixel) {
    rectMode(CENTER);
    Tool tool = (Tool) itemSlot.item;

    fill(tool.c);
    circle(xPixel, yPixel, settings.pixelsPerItemSlot / 2);

    textSize(15);
    textAlign(CENTER, BOTTOM);
    fill(255, 255, 255);
    String toolName = tool.toString().substring(tool.toString().lastIndexOf("_") + 1);
    text(toolName, xPixel, yPixel + settings.pixelsPerItemSlot / 2);
    rectMode(CORNER);
}
