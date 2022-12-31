// Will be stored in the game save
int worldSeed;
HashMap<PVector, Chunk> generatedChunks;
Player player;
ArrayList<Mob> mobs;

// Will not be stored in the game save
Block[][] visibleBlocks;
ArrayList<Block> damagedBlocks;
boolean rightMouseButtonDown;
boolean leftMouseButtonDown;
boolean A_isPressed, D_IsPressed, W_isPressed, S_isPressed;
boolean inventoryIsOpen;

void intializeGameState() {
    
    // Will be stored in the game save
    worldSeed = int(random(0, 100000000));
    generatedChunks = new HashMap<PVector, Chunk>();
    player = new Player(1000000, 1000000);
    mobs = new ArrayList<Mob>();
    
    // Will not be stored in the game save
    setViewDistance(viewDistance);
    makeViewDistanceFitZoomLevel();
    loadVisibleBlocks();
    damagedBlocks = new ArrayList<Block>();
    rightMouseButtonDown = false;
    leftMouseButtonDown = false;
    setPlayerBlock(new Grass());
    inventoryIsOpen = false;
    
    // Add some items to inventory
    player.inventory.addItem(new Tool("iron", "sword"));
    player.inventory.addItem(new Tool("diamond", "pick"));
    player.inventory.addItem(new Tool("stone", "shovel"));
    player.inventory.addItem(new Tool("diamond", "axe"));
    player.inventory.addBlock(new Planks(), 128);
}
