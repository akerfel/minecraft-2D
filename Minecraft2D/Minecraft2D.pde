import java.util.Iterator; //<>//

// Global variables
Settings settings;
State state;            // Game state

// This function is called once, at startup
void setup() {
    //fullScreen();
    size(1200, 1200);

    settings = new Settings();
    settings.initialize();

    state = new State();
    state.intialize();
}

// This is the main game loop (called ~60 times per second)
void draw() {
    updateState();
    drawEverything();
}

void drawEverything() {
    background(0);
    drawWorld();
    drawUI();
}
