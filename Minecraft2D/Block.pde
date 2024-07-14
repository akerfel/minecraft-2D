public class Block extends Item {
    public boolean isWall;
    float prcntBroken;
    float timeDamagedLastTime;    // millis
    float hardness;
    ToolType toolTypeForMining;
    boolean isMineable;

    public Block(ItemID ID, color c, boolean isWall, ToolType toolTypeForMining, boolean isMineable) {
        super(ID, ItemType.BLOCK, true);
        this.c = c;
        this.isWall = isWall;
        this.prcntBroken = 0;
        this.hardness = 1.5;
        this.toolTypeForMining = toolTypeForMining;
        this.isMineable = isMineable;
    }

    boolean isWallOrWater() {
        return (isWall || itemID == ItemID.WATER);
    }

    boolean isHoldingCorrectToolType() {
        Item heldItem = state.player.inventory.getHeldItem();
        Tool tool = (Tool) heldItem;
        return (toolTypeForMining == tool.toolType); //<>// //<>// //<>// //<>//
    }

    public void mineBlock() {
        if (prcntBroken == 0) {
            timeDamagedLastTime = millis();
            prcntBroken = 0.1;
        } else {
            float toolMultiplier = 1;        // Higher = faster. wood/stone/iron/etc
            if (state.player.inventory.isHoldingTool() && isHoldingCorrectToolType()) {
                println("CORRECT TOOL");
                toolMultiplier = ((Tool) state.player.inventory.getHeldItem()).mult;
                println("MULTIPLIER: " + toolMultiplier);
            }

            // ODD BEHAVIOR: Increasing numBreakingStages also increases breaking time.
            // Especially for high values. Keep numBreakingStages at <= 10 for now.
            float numBreakingStages = 10;
            if (millis() - timeDamagedLastTime > hardness * 1.5 / toolMultiplier * (1000.0 / numBreakingStages)) {
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
