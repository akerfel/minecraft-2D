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
        for (int i = 0; i < blocksPerChunk; i++) {
            for (int j = 0; j < blocksPerChunk; j++) {
                if (random(0, 1) < chanceStone) {
                    blocks[i][j] = new Stone();
                }
                else if (random(0, 1) < chanceTree) {
                    blocks[i][j] = new Planks();
                }
                else {
                    blocks[i][j] = new Grass(grassColorScheme);
                }
            }
        }
    }
}
