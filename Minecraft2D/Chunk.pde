public class Chunk {
    public Block[][] blocks;
    public color grassColorScheme;         // Each chunk has a special color for grass
    float chanceStone;                     // for each block
    float chanceTree;
    ChunkType type;

    public Chunk(PVector coords) {
        // Setup
        setupBlockMatrix();
        setupSeed(coords);
        setupChunkType();
        setupColorScheme();
        
        // Place blocks
        placeGrassAndStone();
        placeTrees();
        placeRivers();
    }
    
    private void setupBlockMatrix() {
        blocks = new Block[settings.blocksPerChunk][settings.blocksPerChunk];    
    }
    
    private void setupSeed(PVector coords) {
        long chunkSeed = state.worldSeed + int(coords.x) + int(coords.y) * 1000;
        randomSeed(chunkSeed);    
    }
    
    private void setupChunkType() {
        type = ChunkType.DEFAULT;    
        chanceStone = settings.baseChanceStone * random(0.1, 1.3);
        chanceTree = settings.baseChanceTree * random(0.1, 1.3);
        
        if (random(0, 1) < settings.chanceBigTreesChunk) {
            type = ChunkType.BIG_TREES;
        }
        else if (random(0, 1) < settings.chanceForestChunk) {
            type = ChunkType.FOREST;
            chanceTree = settings.chanceTreeInForestChunk + random(-0.05, 0.05);
        }
        else if (random(0, 1) < settings.chanceMountainChunk) {
            type = ChunkType.MOUNTAIN;
            chanceStone = settings.chanceStoneInMountainChunk + random(-0.05, 0.05);
            chanceTree = settings.chanceTreeInMountainChunk;
        }
    }
    
    private void setupColorScheme() {
        grassColorScheme = color(random(0, 40), random(0, 40), random(0, 40));
    }
    
    private void placeGrassAndStone() {
        for (int x = 0; x < settings.blocksPerChunk; x++) {
            for (int y = 0; y < settings.blocksPerChunk; y++) {
                if (random(0, 1) < chanceStone) {
                    blocks[x][y] = new Stone();
                } else {
                    blocks[x][y] = new Grass(grassColorScheme);
                }
            }
        }
    }
    
    private void placeRivers() {
        for (int x = 0; x < settings.blocksPerChunk; x++) {
            for (int y = 0; y < settings.blocksPerChunk; y++) {
                if (random(0, 1) < settings.chanceRiver) {
                    makeRiver(x, y);
                }
            }
        }
    }

     private void makeRiver(int xCord, int yCord) {
        int startWidth = int(random(3, 5));
        int currentWidth = startWidth;
        int lengthRiver = constrain(int(random(40, 400)), 1, settings.blocksPerChunk - yCord - 3);
        float chanceTurnRight = 0.2;
        float chanceTurnLeft = 0.2;
        for (int y = 0; y < lengthRiver; y++) {
            for (int x = 0; x < currentWidth; x++) {
                // Place row of wates (unless too close to edge of chunk)
                if (xCord + x > 1 && xCord + x < settings.blocksPerChunk) {
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

     private void placeTrees() {
        if (type == ChunkType.BIG_TREES) {
            placeBigTrees();
            return;
        }
        placeNormalTrees();
    }
    
    private void placeNormalTrees() {
        for (int x = 0; x < settings.blocksPerChunk - 2; x++) {
            for (int y = 0; y < settings.blocksPerChunk - 2; y++) {
                if (random(0, 1) < chanceTree) {
                    makeTree(x, y);
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
