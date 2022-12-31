public class State {
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
}

void intializeState() {
    // Will be stored in the game save
    state.worldSeed = int(random(0, 100000000));
    state.generatedChunks = new HashMap<PVector, Chunk>();
    state.player = new Player(1000000, 1000000);
    state.mobs = new ArrayList<Mob>();

    // Will not be stored in the game save
    setViewDistance(settings.viewDistance);
    makeViewDistanceFitZoomLevel();
    loadVisibleBlocks();
    state.damagedBlocks = new ArrayList<Block>();
    state.rightMouseButtonDown = false;
    state.leftMouseButtonDown = false;
    setPlayerBlock(new Grass());
    state.inventoryIsOpen = false;

    // Add some items to inventory
    state.player.inventory.addItem(new Tool("iron", "sword"));
    state.player.inventory.addItem(new Tool("diamond", "pick"));
    state.player.inventory.addItem(new Tool("stone", "shovel"));
    state.player.inventory.addItem(new Tool("diamond", "axe"));
    state.player.inventory.addBlock(new Planks(), 128);
}