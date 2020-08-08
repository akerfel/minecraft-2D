public class Chunk {
    public Block[][] blocks;
    public color grassColorScheme; // Each chunk has a special color for grass
    float chanceStone;
    float chanceTree;
    
    public Chunk(PVector coords) {
        blocks = new Block[blocksPerChunk][blocksPerChunk];
        long chunkSeed = gameSeed + int(coords.x) + int(coords.y) * 1000;
        randomSeed(chunkSeed);
        placeGrassAndStone();
        placeTrees();
        placeRivers();
    }
    
    void placeGrassAndStone() {
        grassColorScheme = color(random(0, 70), random(0, 70), random(0, 70));
        chanceStone = baseChanceStone * random(0.1, 1.3);
        for (int x = 0; x < blocksPerChunk; x++) {
            for (int y = 0; y < blocksPerChunk; y++) {
                if (random(0, 1) < chanceStone) {
                    blocks[x][y] = new Stone();
                }
                else {
                    blocks[x][y] = new Grass(grassColorScheme);
                }
            }
        }
    }
    
    void placeRivers() {
        for (int x = 0; x < blocksPerChunk; x++) {
            for (int y = 0; y < blocksPerChunk; y++) {
                if (random(0, 1) < chanceRiver) {
                    makeRiver(x, y);
                }
            }
        } 
    }
    
    void makeRiver(int xCord, int yCord) {
        int startWidth = int(random(3, 5));
        int currentWidth = startWidth;
        int lengthRiver = constrain(int(random(40, 400)), 1, blocksPerChunk - yCord - 3);
        float chanceTurnRight = 0.2;
        float chanceTurnLeft = 0.2;
        for (int y = 0; y < lengthRiver; y++) {
            for (int x = 0; x < currentWidth; x++) {
                // Place row of wates (unless too close to edge of chunk)
                if (xCord + x > 1 && xCord + x < blocksPerChunk) {
                    blocks[xCord + x][yCord + y] = new Water();
                }
            }
            // Change width of river
            if (random(0, 1) < 0.2) {
                currentWidth += int(random(-2, 2));
                currentWidth = constrain(currentWidth, startWidth - 1, startWidth + 1);
            }
            // Change start xpos of the next row of water
            if (random(0, 1) < chanceTurnRight) {
                xCord++;
            }
            if (random(0, 1) <= chanceTurnLeft) {
                xCord--;
            }
        }
    }
    
    void placeTrees() {
        chanceTree = baseChanceTree * random(0.1, 1.3);
        for (int x = 1; x < blocksPerChunk - 1; x++) {
            for (int y = 1; y < blocksPerChunk - 1; y++) {
                if (random(0, 1) < chanceTree) {
                    makeTree(x, y);
                }
            }
        }    
    }
    
    
    
    void makeTree(int x, int y) {
        // Top row
        blocks[x-1][y-1] = new Leaves();
        blocks[x][y-1] = new Leaves();
        blocks[x+1][y-1] = new Leaves();
        // Middle row
        blocks[x-1][y] = new Leaves();
        blocks[x][y] = new Wood();
        blocks[x+1][y] = new Leaves();
        // Bottom row
        blocks[x-1][y+1] = new Leaves();
        blocks[x][y+1] = new Leaves();
        blocks[x+1][y+1] = new Leaves();
    }
    
}
