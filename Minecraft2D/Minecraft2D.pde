// Global variables
Cheats cheats;
State state;

// This function is called once, at startup
void setup() {
    size(1200, 1200);
    cheats = new Cheats();
    intializeSettings();
    state = new State();
    intializeState();
    
    // Add some items to inventory
    state.player.inventory.addItem(new Tool("iron", "sword"));
    state.player.inventory.addItem(new Tool("diamond", "pick"));
    state.player.inventory.addItem(new Tool("stone", "shovel"));
    state.player.inventory.addItem(new Tool("diamond", "axe"));
    state.player.inventory.addBlock(new Planks(), 128);    
}

// This function is called 60 times per second
void draw() {
    updateLogic();
    drawEverything();
}
