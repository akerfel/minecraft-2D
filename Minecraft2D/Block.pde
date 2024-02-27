public class Block extends Item {
    public boolean isWall;
    float prcntBroken;
    float timeDamagedLastTime;    // millis
    float hardness;
    ToolType toolTypeForMining;
    boolean isMineable;

    public Block(String name, color c, boolean isWall, ToolType toolTypeForMining, boolean isMineable) {
        super("block", name);
        this.c = c;
        this.isWall = isWall;
        this.prcntBroken = 0;
        this.hardness = 1.5;
        this.toolTypeForMining = toolTypeForMining;
        this.isMineable = isMineable;
    }

    boolean isWallOrWater() {
        return (isWall || name.equals("water"));
    }

    boolean isHoldingCorrectToolType() {
        return (toolTypeForMining.equals(((Tool) state.player.inventory.getHeldItem()).toolType));
    }

    public void mineBlock() {
        if (prcntBroken == 0) {
            timeDamagedLastTime = millis();
            prcntBroken = 0.1;
        } else {
            float toolTypeMult = 5;            // Higher = slower. 1.5 longer timer for correct tool type, 5 for incorrect tool type
            float toolMaterialMult = 1;        // Higher = faster. wood/stone/iron
            if (state.player.inventory.isHoldingTool() && isHoldingCorrectToolType()) {
                toolTypeMult = 1.5;
                toolMaterialMult = ((Tool) state.player.inventory.getHeldItem()).mult;
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
    
    public String toString() {
        return name;    
    }
}

public class Dirt extends Block {
    public Dirt() {
        super(ItemIDs.DIRT, color(151, 109, 77), false, ToolType.SHOVEL, true);
    }
}

public class Grass extends Block {
    public Grass() {
        super(ItemIDs.GRASS, color(127, 178, 56) + color(random(-15, 15), random(-15, 15), random(-15, 15)), false, ToolType.SHOVEL, false);
    }

    public Grass(color colorScheme) {
        super(ItemIDs.GRASS, colorScheme, false, ToolType.SHOVEL, false);
    }
}

public class Leaves extends Block {
    public Leaves() {
        super(ItemIDs.LEAVES, color(0, 124, 0) + color(random(-30, 30), random(-0, 30), random(-30, 30)), true, ToolType.AXE, true);
        this.hardness = 0.2;
    }
}

public class Planks extends Block {
    public Planks() {
        super(ItemIDs.PLANKS, color(194, 155, 115), true, ToolType.AXE, true);
    }
}

public class Sand extends Block {
    public Sand() {
        super(ItemIDs.SAND, color(247, 233, 163), false, ToolType.SHOVEL, true);
    }
}

public class Stone extends Block {
    public Stone() {
        super(ItemIDs.STONE, color(112, 112, 112) + color(random(-8, 8), random(-8, 8), random(-8, 8)), true, ToolType.PICK, true);
    }
}

public class IronOre extends Block {
    public IronOre() {
        super(ItemIDs.IRON_ORE, color(223, 223, 225), true, ToolType.PICK, true);
    }
}

public class Water extends Block {
    public Water(color colorScheme) {
        super(ItemIDs.WATER, colorScheme, false, ToolType.NOTYPE, false);
        hardness = 100000;
    }
    
    public Water() {
        this(color(64, 64, 255));
    }
}

public class Wood extends Block {
    public Wood() {
        super(ItemIDs.WOOD, color(174, 125, 90), true, ToolType.AXE, true);
    }
}
