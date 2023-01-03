public class Block extends Item {
    String name;
    public boolean isWall;
    float prcntBroken;
    float timeDamagedLastTime;    // millis
    float hardness;
    String toolTypeForMining;
    boolean isMineable;

    public Block(String name, color c, boolean isWall, String toolTypeForMining, boolean isMineable) {
        super("block");
        this.name = name;
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
}


public class Dirt extends Block {
    public Dirt() {
        super("dirt", color(151, 109, 77), false, "shovel", true);
    }

    public String toString() {
        return "dirt";
    }
}

public class Grass extends Block {
    public Grass() {
        super("grass", color(127, 178, 56) + color(random(-15, 15), random(-15, 15), random(-15, 15)), false, "shovel", false);
    }

    public Grass(color colorScheme) {
        super("grass", color(127, 178, 56) + colorScheme + color(random(-15, 15), random(-15, 15), random(-15, 15)), false, "shovel", false);
    }

    public String toString() {
        return "grass";
    }
}

public class Leaves extends Block {
    public Leaves() {
        super("leaves", color(0, 124, 0) + color(random(-30, 30), random(-0, 30), random(-30, 30)), true, "axe", true);
        this.hardness = 0.2;
    }

    public String toString() {
        return "leaves";
    }
}

public class Planks extends Block {
    public Planks() {
        super("planks", color(194, 155, 115), true, "axe", true);
    }

    public String toString() {
        return "planks";
    }
}

public class Sand extends Block {
    public Sand() {
        super("sand", color(247, 233, 163), false, "shovel", true);
    }

    public String toString() {
        return "sand";
    }
}

public class Stone extends Block {
    public Stone() {
        super("stone", color(112, 112, 112), true, "pick", true);
    }

    public String toString() {
        return "stone";
    }
}

public class Water extends Block {
    public Water() {
        super("water", color(64, 64, 255) + color(random(-15, 15), random(-15, 15), 0), false, "nothing", false);
        hardness = 100000;
    }

    public String toString() {
        return "water";
    }
}

public class Wood extends Block {
    public Wood() {
        super("wood", color(174, 125, 90), true, "axe", true);
    }

    public String toString() {
        return "wood";
    }
}
