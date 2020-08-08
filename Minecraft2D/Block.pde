public class Block extends Item{
    String stringID;
    public boolean isWall;
    float prcntBroken;
    float timeDamagedLastTime;    // millis
    float hardness;
    String toolTypeForMining;
    boolean isMineable;
    
    public Block(String stringID, color c, boolean isWall, String toolTypeForMining, boolean isMineable) {
        super("block");
        this.stringID = stringID;
        this.c = c;
        this.isWall = isWall;
        this.prcntBroken = 0;
        this.hardness = 1.5;
        this.toolTypeForMining = toolTypeForMining;
        this.isMineable = isMineable;
    }
    
    boolean isWallOrWater() {
        return (isWall || stringID.equals("water"));
    }
    
    boolean isHoldingCorrectToolType() {
        return (toolTypeForMining.equals(((Tool) player.getHeldItem()).toolType));
    }
    
    public void mineBlock() {
        if (prcntBroken == 0) {
            timeDamagedLastTime = millis();
            prcntBroken = 0.1;
        }
        else {
            float toolTypeMult = 5;            // Higher = slower. 1.5 longer timer for correct tool type, 5 for incorrect tool type
            float toolMaterialMult = 1;        // Higher = faster. wood/stone/iron
            if (player.isHoldingTool() && isHoldingCorrectToolType()) {
                toolTypeMult = 1.5;
                toolMaterialMult = ((Tool) player.getHeldItem()).mult;
            }
            
            // ODD BEHAVIOR: Increasing numBreakingStages also increases breaking time.
            // Especially for high values. Keep numBreakingStages at <= 10 for now.
            float numBreakingStages = 10;    
            if (millis() - timeDamagedLastTime > hardness * 1.5 * toolTypeMult / toolMaterialMult * (1000.0 / numBreakingStages)) {
                if (prcntBroken < 1) {
                    timeDamagedLastTime = millis();
                    prcntBroken += 1.0 / numBreakingStages;
                    if (prcntBroken > 1) {
                        prcntBroken = 1;
                    }
                }
            }
        }
    }
    
    public void removeDamage() {
        if (prcntBroken > 0) {
            prcntBroken -= 0.1;
            if (prcntBroken < 0) {
                prcntBroken = 0;
            }
        }
    }
}
