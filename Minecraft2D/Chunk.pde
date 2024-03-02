public class Chunk {
    public Block[][] blocks;
    float chanceStone;                     // for each block
    PVector coords;

    public Chunk(PVector coords) {
        // Setup
        this.coords = coords;
        chanceStone = settings.chanceStone + random(-0.05, 0.05);
        setupBlockMatrix();
        setupSeed();
        
        // Place blocks
        placeBlocks();
        placeNormalTrees();
    }
    
    private void setupBlockMatrix() {
        blocks = new Block[settings.blocksPerChunk][settings.blocksPerChunk];    
    }
    
    private void setupSeed() {
        long chunkSeed = state.worldSeed + int(coords.x) + int(coords.y) * 1000;
        randomSeed(chunkSeed);    
    }
    
    private void placeBlocks() {
        float stoneNoiseScale = 0.07;
        float riverNoiseScale = 0.01;
        float ironNoiseScale = 0.1;
        float ironThreshold = 0.79;
    
        for (int x = 0; x < settings.blocksPerChunk; x++) {
            for (int y = 0; y < settings.blocksPerChunk; y++) {
                float stoneNoiseVal = noise((x + coords.x * settings.blocksPerChunk) * stoneNoiseScale, (y + coords.y * settings.blocksPerChunk) * stoneNoiseScale);
                float riverNoiseVal = noise((x + coords.x * settings.blocksPerChunk) * riverNoiseScale, (y + coords.y * settings.blocksPerChunk) * riverNoiseScale);
                float ironNoiseVal = noise((x + coords.x * settings.blocksPerChunk) * ironNoiseScale, (y + coords.y * settings.blocksPerChunk) * ironNoiseScale);
                
                if (stoneNoiseVal < chanceStone) {
                    blocks[x][y] = (Block) createItem(ItemID.STONE);
                    if (ironNoiseVal > ironThreshold) {
                        int ironOreGroupSize = (int)(Math.random() * 7) + 2;
                        for (int i = 0; i < ironOreGroupSize; i++) {
                            if (x + i < settings.blocksPerChunk && y + i < settings.blocksPerChunk) {
                                blocks[x + i][y + i] = (Block) createItem(ItemID.IRON_ORE);
                            }
                        }
                    }
                } else {
                    blocks[x][y] = (Block) createItem(ItemID.GRASS);
                }
    
                if (riverNoiseVal > 0.5 && riverNoiseVal < 0.55) {
                    blocks[x][y] = (Block) createItem(ItemID.WATER); 
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
                    if (random(1) < treeChance && blocks[x][y].itemID == ItemID.GRASS) {
                        makeTree(x, y);
                    }
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
        blocks[x+1][y+1] = (Block) createItem(ItemID.WOOD);
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
        blocks[x+1][y+1] = (Block) createItem(ItemID.WOOD);
        blocks[x+2][y+1] = (Block) createItem(ItemID.WOOD);
        makeLeaf(x+3, y+1);

        // Horizontal row 3 of 4
        makeLeaf(x, y+2);
        blocks[x+1][y+2] = (Block) createItem(ItemID.WOOD);
        blocks[x+2][y+2] = (Block) createItem(ItemID.WOOD);
        makeLeaf(x+3, y+2);

        // Horizontal row 4 of 4
        makeLeaf(x, y+3);
        makeLeaf(x+1, y+3);
        makeLeaf(x+2, y+3);
        makeLeaf(x+3, y+3);
    }

     private void makeLeaf(int x, int y) {
        if (!(blocks[x][y].itemID == ItemID.WOOD)) {
            blocks[x][y] = (Block) createItem(ItemID.LEAVES);
        }
    }
}
