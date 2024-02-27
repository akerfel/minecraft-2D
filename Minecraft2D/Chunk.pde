public class Chunk {
    public Block[][] blocks;
    public color grassColorScheme;         // Each chunk has a special color for grass
    float chanceStone;                     // for each block
    PVector coords;

    public Chunk(PVector coords) {
        // Setup
        this.coords = coords;
        chanceStone = settings.chanceStone + random(-0.05, 0.05);
        setupBlockMatrix();
        setupSeed();
        setupColorScheme();
        
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
    
    private void setupColorScheme() {
        
    }
    
    private void placeBlocks() {
        float stoneNoiseScale = 0.07;
        float riverNoiseScale = 0.01;
        float ironNoiseScale = 0.1;
        float ironThreshold = 0.79;
        float waterColorScale = 0.1; // Adjust this scale for finer or coarser color variations
        
        for (int x = 0; x < settings.blocksPerChunk; x++) {
            for (int y = 0; y < settings.blocksPerChunk; y++) {
                float stoneNoiseVal = noise((x + coords.x * settings.blocksPerChunk) * stoneNoiseScale, (y + coords.y * settings.blocksPerChunk) * stoneNoiseScale);
                float riverNoiseVal = noise((x + coords.x * settings.blocksPerChunk) * riverNoiseScale, (y + coords.y * settings.blocksPerChunk) * riverNoiseScale);
                float ironNoiseVal = noise((x + coords.x * settings.blocksPerChunk) * ironNoiseScale, (y + coords.y * settings.blocksPerChunk) * ironNoiseScale);
                
                if (stoneNoiseVal < chanceStone) {
                    blocks[x][y] = new Stone();
                    if (ironNoiseVal > ironThreshold) {
                        int ironOreGroupSize = (int)(Math.random() * 7) + 2;
                        for (int i = 0; i < ironOreGroupSize; i++) {
                            if (x + i < settings.blocksPerChunk && y + i < settings.blocksPerChunk) {
                                blocks[x + i][y + i] = new IronOre();
                            }
                        }
                    }
                } 
                else if (riverNoiseVal > 0.4 && riverNoiseVal < 0.45) {
                    // Use Perlin noise for water color variations
                    float waterNoiseVal = noise((x + coords.x * settings.blocksPerChunk) * waterColorScale, (y + coords.y * settings.blocksPerChunk) * waterColorScale);
                    float r = map(waterNoiseVal, 0, 1, 0, 64); // Map noise value to a suitable range for red channel
                    float g = map(waterNoiseVal, 0, 1, 0, 64); // Map noise value to a suitable range for green channel
                    float b = map(waterNoiseVal, 0, 1, 128, 255); // Map noise value to a suitable range for blue channel
                    color waterColorScheme = color(r, g, b);
                    blocks[x][y] = new Water(waterColorScheme); 
                } else {
                    // Use Perlin noise for grass color variations
                    float grassNoiseVal = noise((x + coords.x * settings.blocksPerChunk) * waterColorScale, (y + coords.y * settings.blocksPerChunk) * waterColorScale);
                    float r = map(grassNoiseVal, 0, 1, 97, 157); // Map noise value to a suitable range for red channel
                    float g = map(grassNoiseVal, 0, 1, 148, 208); // Map noise value to a suitable range for green channel
                    float b = map(grassNoiseVal, 0, 1, 26, 86); // Map noise value to a suitable range for blue channel
                    color grassColorScheme = color(r, g, b);
                    blocks[x][y] = new Grass(grassColorScheme);
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
