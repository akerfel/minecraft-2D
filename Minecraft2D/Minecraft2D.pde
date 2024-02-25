// Global variables
Cheats cheats;
Settings settings;
State state;            // Game state

// This function is called once, at startup
void setup() {
    fullScreen();
    //size(1200, 1200);

    // Initialize cheats, settings and state
    cheats = new Cheats();
    intializeCheats();
    settings = new Settings();
    initializeSettings();
    state = new State();
    intializeState();
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
    background(0, 0, 0);
    drawWorld();
    drawUI();
}
