import java.util.HashMap;

int gameSeed;
//HashMap<PVector, Chunk> visibleChunks = new HashMap<>();
float chanceGrass;
Chunk visibleChunk;    // atm just one, later will be at least 9
int pixelCount;    // pixels per side of block
HashMap<PVector, Chunk> generatedChunks;
Player player;

void setup() {
    size(1000, 1000);
    chanceGrass = 0.80;
    pixelCount = 50;
    generatedChunks = new HashMap<PVector, Chunk>();
    println("ey");
    player = new Player(4, 4);
    println("lmao");
    gameSeed = 1000000;
    loadInitalVisibleChunks();
}

void loadInitalVisibleChunks() {
    visibleChunk = getChunkForPlayerCoords(player.coords);
}

Chunk getChunkForPlayerCoords(PVector playerCoords) {
    PVector chunkCoords = new PVector(playerCoords.x / 16, playerCoords.y / 16);
    if (!generatedChunks.containsKey(chunkCoords)) {
        generatedChunks.put(chunkCoords, new Chunk(chunkCoords));
    }
    return generatedChunks.get(chunkCoords);
}

void draw() {
    background(0, 0, 0);
    drawVisibleChunk();
    drawPlayer();
}

void drawVisibleChunk() {
    drawChunk(visibleChunk);
}

void drawChunk(Chunk chunk) {
    for (int i = 0; i < 16; i++) {
        for (int j = 0; j < 16; j++) {
            fill(112, 112, 112);       // Stone color
            if (chunk.blocks[i][j].isGrass) {
                fill(127, 178, 56);    // Grass color
            }
            square(0 + i * pixelCount, 0 + j * pixelCount, pixelCount);
        }
    }
}

void drawPlayer() {
    rectMode(CENTER);
    fill(216, 127, 51);
    square(player.coords.x * pixelCount + pixelCount / 2, player.coords.y * pixelCount + pixelCount / 2, pixelCount / 2);    
    rectMode(CORNER);
}
