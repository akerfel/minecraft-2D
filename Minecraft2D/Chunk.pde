public class Chunk {
    public Block[][] blocks;
    int x;
    int y;
    public color grassColorScheme; // Each chunk has a special color for grass
    float chanceStone;
    float chanceTree;
    
    public Chunk(PVector coords) {
        blocks = new Block[blocksPerChunk][blocksPerChunk];
        long chunkSeed = gameSeed + int(coords.x) + int(coords.y) * 1000;
        randomSeed(chunkSeed);
        grassColorScheme = color(random(0, 70), random(0, 70), random(0, 70));
        chanceStone = baseChanceStone * random(0.1, 1.3);
        chanceTree = baseChanceTree * random(0.1, 1.3);
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
