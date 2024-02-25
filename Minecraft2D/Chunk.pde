public class Chunk {
    public Block[][] blocks;
    public color grassColorScheme;         // Each chunk has a special color for grass
    float chanceStone;                     // for each block
    float chanceTree;
    PVector coords;

    public Chunk(PVector coords) {
        // Setup
        this.coords = coords;
        chanceStone = settings.chanceStone + random(-0.05, 0.05);
        chanceTree = settings.chanceTree;
        setupBlockMatrix();
        setupSeed();
        setupColorScheme();
        
        // Place blocks
        placeGrassAndStoneAndWater();
        placeNormalTrees();
    }
    
    private void setupBlockMatrix() {
        blocks = new Block[settings.blocksPerChunk][settings.blocksPerChunk];    
    }
    
    private void setupSeed() {
        long chunkSeed = state.worldSeed + int(coords.x) + int(coords.y) * 1000;
        randomSeed(chunkSeed);    
    }
    
    private void setupColorScheme() {
        grassColorScheme = color(random(0, 40), random(0, 40), random(0, 40));
    }
    
    private void placeGrassAndStoneAndWater() {
        float stoneNoiseScale = 0.07; 
        float riverNoiseScale = 0.01; 
        float ironNoiseScale = 0.08; // Adjust as needed for rarity of iron ore
        float ironThreshold = 0.8;  // Adjust as needed for rarity of iron ore
    
        for (int x = 0; x < settings.blocksPerChunk; x++) {
            for (int y = 0; y < settings.blocksPerChunk; y++) {
                float stoneNoiseVal = noise((x + coords.x * settings.blocksPerChunk) * stoneNoiseScale, (y + coords.y * settings.blocksPerChunk) * stoneNoiseScale);
                float riverNoiseVal = noise((x + coords.x * settings.blocksPerChunk) * riverNoiseScale, (y + coords.y * settings.blocksPerChunk) * riverNoiseScale);
                float ironNoiseVal = noise((x + coords.x * settings.blocksPerChunk) * ironNoiseScale, (y + coords.y * settings.blocksPerChunk) * ironNoiseScale);
                
                if (stoneNoiseVal < chanceStone) {
                    blocks[x][y] = new Stone();
                    if (ironNoiseVal > ironThreshold) {
                        int ironOreGroupSize = (int)(Math.random() * 7) + 2; // Randomize group size between 2 and 8
                        for (int i = 0; i < ironOreGroupSize; i++) {
                            if (x + i < settings.blocksPerChunk && y + i < settings.blocksPerChunk) {
                                blocks[x + i][y + i] = new IronOre(); // Place iron ore blocks in a diagonal pattern
                            }
                        }
                    }
                } else {
                    blocks[x][y] = new Grass(grassColorScheme);
                }
    
                if (riverNoiseVal > 0.5 && riverNoiseVal < 0.55) {
                    blocks[x][y] = new Water(); 
                }
    
                
            }
        }
    }
    
    private void placeNormalTrees() {
        float treeNoiseScale = 0.05;
        for (int x = 0; x < settings.blocksPerChunk; x++) {
            for (int y = 0; y < settings.blocksPerChunk; y++) {
                if (x < settings.blocksPerChunk - 2 && y < settings.blocksPerChunk - 2) {
                    float treeNoiseVal = noise((x + coords.x * settings.blocksPerChunk) * treeNoiseScale, (y + coords.y * settings.blocksPerChunk) * treeNoiseScale);
                    float treeChance = map(treeNoiseVal, 0, 1, 0, 0.01);
                    if (random(1) < treeChance && blocks[x][y] instanceof Grass) {
                        makeTree(x, y);
                    }
                }
            }
        }
    }

     private void placeBigTrees() {
        for (int x = 0; x < settings.blocksPerChunk - 5; x++) {
            for (int y = 0; y < settings.blocksPerChunk - 5; y++) {
                if (random(0, 1) < chanceTree) {
                    makeBigTree(x, y);
                }
            }
        }
    }

    // (x, y) is the top left square of the tree
     private void makeTree(int x, int y) {
        // Top row
        makeLeaf(x, y);
        makeLeaf(x+1, y);
        makeLeaf(x+2, y);

        // Middle row
        makeLeaf(x, y+1);
        blocks[x+1][y+1] = new Wood();
        makeLeaf(x+2, y+1);

        // Bottom row
        makeLeaf(x, y+2);
        makeLeaf(x+1, y+2);
        makeLeaf(x+2, y+2);
    }

    // (x, y) is the top left square of the tree
     private void makeBigTree(int x, int y) {

        // Horizontal row 1 of 4
        makeLeaf(x, y);
        makeLeaf(x+1, y);
        makeLeaf(x+2, y);
        makeLeaf(x+3, y);

        // Horizontal row 2 of 4
        makeLeaf(x, y+1);
        blocks[x+1][y+1] = new Wood();
        blocks[x+2][y+1] = new Wood();
        makeLeaf(x+3, y+1);

        // Horizontal row 3 of 4
        makeLeaf(x, y+2);
        blocks[x+1][y+2] = new Wood();
        blocks[x+2][y+2] = new Wood();
        makeLeaf(x+3, y+2);

        // Horizontal row 4 of 4
        makeLeaf(x, y+3);
        makeLeaf(x+1, y+3);
        makeLeaf(x+2, y+3);
        makeLeaf(x+3, y+3);
    }

     private void makeLeaf(int x, int y) {
        if (!blocks[x][y].name.equals("wood")) {
            blocks[x][y] = new Leaves();
        }
    }
}
