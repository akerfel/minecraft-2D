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
    boolean craftingMenuIsOpen;
    boolean debugScreenIsShowing;
}

void intializeState() {
    // Will be stored in the game save
    state.worldSeed = int(random(0, 100000000));
    state.generatedChunks = new HashMap<PVector, Chunk>();
    state.player = new Player(11111, 11111);
    state.mobs = new ArrayList<Mob>();

    // Will not be stored in the game save
    setViewDistance(settings.viewDistance);
    makeViewDistanceFitZoomLevel();
    loadVisibleBlocks();
    state.damagedBlocks = new ArrayList<Block>();
    state.rightMouseButtonDown = false;
    state.leftMouseButtonDown = false;
    setPlayerBlock((Block) createItem(ItemID.GRASS));
    state.inventoryIsOpen = false;
    state.debugScreenIsShowing = false;

    // Add some items to inventory
    state.player.inventory.addItem(createItem(ItemID.IRON_SWORD));
    state.player.inventory.addItem(createItem(ItemID.DIAMOND_PICKAXE));
    state.player.inventory.addItem(createItem(ItemID.STONE_SHOVEL));
    state.player.inventory.addItem(createItem(ItemID.DIAMOND_AXE));
    state.player.inventory.addItem(createItem(ItemID.PLANKS), 128);
    state.player.inventory.addItem(createItem(ItemID.WORKBENCH), 5);
    state.player.inventory.addItem(createItem(ItemID.WOOD_PICKAXE));
}
