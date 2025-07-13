public class State {
    // Will be stored in the game save
    int worldSeed;
    HashMap<PVector, Chunk> generatedChunks;
    Player player;
    ArrayList<Body> bodies;
    ArrayList<Bullet> bullets;

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
        this.generatedChunks = new HashMap<>();
        this.player = new Player(settings.spawnPoint.x, settings.spawnPoint.y);
        this.bodies = new ArrayList<>();
        this.bullets = new ArrayList<>();
        bodies.add(player);
    
        // Will not be stored in the game save
        setViewDistance(settings.viewDistance);
        makeViewDistanceFitZoomLevel();
        loadVisibleBlocks();
        this.damagedBlocks = new ArrayList<Block>();
        this.rightMouseButtonDown = false;
        this.leftMouseButtonDown = false;
        state.player.setBlockStandingOn((Block) createItem(ItemID.GRASS));
        this.inventoryIsOpen = false;
        this.debugScreenIsShowing = false;
        closeInventory();
    
        // Add some items to inventory
        this.player.inventory.addItem(createItem(ItemID.MACHINE_GUN));
        this.player.inventory.addItem(createItem(ItemID.FLAME_THROWER));
        this.player.inventory.addItem(createItem(ItemID.DIAMOND_PICKAXE));
        this.player.inventory.addItem(createItem(ItemID.STONE_SHOVEL));
        this.player.inventory.addItem(createItem(ItemID.DIAMOND_AXE));
        this.player.inventory.addItem(createItem(ItemID.PLANKS), 64);
        this.player.inventory.addItem(createItem(ItemID.STONE), 64);
        this.player.inventory.addItem(createItem(ItemID.IRON_BULLET), 99999);
    }
}
