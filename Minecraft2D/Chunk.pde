public class Chunk {
    public Block[][] blocks;
    int x;
    int y;
    
    public Chunk(PVector coords) {
        blocks = new Block[16][16];
        long chunkSeed = gameSeed + int(coords.x) + int(coords.y) * 1000;
        randomSeed(chunkSeed);
        for (int i = 0; i < 16; i++) {
            for (int j = 0; j < 16; j++) {
                blocks[i][j] = new Block(random(0, 1) < chanceGrass);
            }
        }
    }
}
