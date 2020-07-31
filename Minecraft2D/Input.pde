void keyPressed() {
    player.setMove(keyCode, true);
    
    if (key == 'f') {
        for (int x = 0; x < blocksPerChunk; x++) {
            for (int y = 0; y < blocksPerChunk; y++) {
                if (random(0, 1) < 0.05) {
                    visibleChunks[4].blocks[x][y].c = color(200, 0, 0);
                }
            }
        }
    }
}
 
void keyReleased() {
    player.setMove(keyCode, false);
}
