public class Block {
    public color c;
    public boolean isWall;
    float prcntBroken;
    int timeDamagedLastTime;    // millis
    float hardness;
    
    public Block(color c, boolean isWall) {
        this.c = c;
        this.isWall = isWall;
        this.prcntBroken = 0;
        timeDamagedLastTime = millis();
        hardness = 1.5;
    }
    
    public void damage() {
        if (millis() - timeDamagedLastTime > hardness * 1.5 * 5 * 100) {
            if (prcntBroken < 1) {
                prcntBroken += 0.1;
                timeDamagedLastTime = millis();
                println("Damaged block" + random(0, 100));
            }
        }
    }
}
