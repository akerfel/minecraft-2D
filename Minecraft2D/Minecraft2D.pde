// This function is called once, at startup
void setup() {
    size(1200, 1200);
    initializeCheats();
    intializeSettings();
    intializeGameState();
}

// This function is called 60 times per second
void draw() {
    updateLogic();
    drawEverything();
}
