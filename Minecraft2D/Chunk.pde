public class Chunk {
    public Block[][] blocks;
    int x;
    int y;
    color colorScheme;
    
    public Chunk(PVector coords) {
        blocks = new Block[blocksPerChunk][blocksPerChunk];
        long chunkSeed = gameSeed + int(coords.x) + int(coords.y) * 1000;
        randomSeed(chunkSeed);
        color colorScheme = color(random(0, 70), random(0, 70), random(0, 70));
        for (int i = 0; i < blocksPerChunk; i++) {
            for (int j = 0; j < blocksPerChunk; j++) {
                color baseColorStone = color(112, 112, 112);
                color baseColorGrass = color(127, 178, 56);
                
                color finalColor = baseColorStone;
                boolean isWall = true;
                if (random(0, 1) < chanceGrass) {
                    // Each chunk has its own grass color
                    finalColor = baseColorGrass + colorScheme;
                    isWall = false;
                }
                
                blocks[i][j] = new Block(finalColor, isWall);
            }
        }
    }
}
