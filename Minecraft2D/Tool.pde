public class Tool extends Item {
    String toolType;     // E.g. "pick", "shovel" or "axe"
    String material;     // E.g. "wood", "stone" or "iron"
    int mult;            // Mining speed multiplier
    
    // E.g. for making new tool: 
    // Tool diamondPick = new Tool("diamond", "pick");
    public Tool(String material, String toolType) {
        super("tool");
        this.toolType = toolType;
        this.material = material;
        switch (material) {
            case "wood":
                mult = 2;
                c = color(143, 119, 72);
                break;
            case "stone":
                mult = 4;
                c = color(112, 112, 112);
                break;
            case "iron":
                mult = 6;
                c = color(167, 167, 167);
                break;
            case "diamond":
                mult = 8;
                c = color(92, 219, 213);
                break;
            case "netherite":
                mult = 8;
                c = color(25, 25, 25);
                break;
            case "gold":
                mult = 12;
                c = color(250, 238, 77);
                break;
        }
    }
}
