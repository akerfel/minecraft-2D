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
    setPlayerBlock(new Grass());
    state.inventoryIsOpen = false;
    state.debugScreenIsShowing = false;

    // Add some items to inventory
    state.player.inventory.addItem(new Tool(ToolMaterial.IRON, ToolType.SWORD));
    state.player.inventory.addItem(new Tool(ToolMaterial.DIAMOND, ToolType.PICK));
    state.player.inventory.addItem(new Tool(ToolMaterial.STONE, ToolType.SHOVEL));
    state.player.inventory.addItem(new Tool(ToolMaterial.DIAMOND, ToolType.AXE));
    state.player.inventory.addBlock(new Planks(), 128);
}
