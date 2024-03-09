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
    
    public void intialize() {
        // Will be stored in the game save
        this.worldSeed = int(random(0, 100000000));
        this.generatedChunks = new HashMap<PVector, Chunk>();
        this.player = new Player(11111, 11111);
        this.mobs = new ArrayList<Mob>();
    
        // Will not be stored in the game save
        setViewDistance(settings.viewDistance);
        makeViewDistanceFitZoomLevel();
        loadVisibleBlocks();
        this.damagedBlocks = new ArrayList<Block>();
        this.rightMouseButtonDown = false;
        this.leftMouseButtonDown = false;
        setPlayerBlock((Block) createItem(ItemID.GRASS));
        this.inventoryIsOpen = false;
        this.debugScreenIsShowing = false;
    
        // Add some items to inventory
        this.player.inventory.addItem(createItem(ItemID.IRON_SWORD));
        this.player.inventory.addItem(createItem(ItemID.DIAMOND_PICKAXE));
        this.player.inventory.addItem(createItem(ItemID.STONE_SHOVEL));
        this.player.inventory.addItem(createItem(ItemID.DIAMOND_AXE));
        this.player.inventory.addItem(createItem(ItemID.PLANKS), 128);
        this.player.inventory.addItem(createItem(ItemID.WORKBENCH), 5);
        this.player.inventory.addItem(createItem(ItemID.WOOD_PICKAXE));
    }
}
