public class Tool extends Item {
    String toolType;     // E.g. "pick", "shovel" or "axe"
    String material;     // E.g. "wood", "stone" or "iron"
    int mult;            // Mining speed multiplier
    
    public Tool(String toolType, String material) {
        super("tool");
        this.toolType = toolType;
        this.material = material;
        switch (material) {
            case "wood":
                mult = 2;
                break;
            case "stone":
                mult = 4;
                break;
            case "iron":
                mult = 6;
                break;
            case "diamond":
                mult = 8;
                break;
            case "netherite":
                mult = 8;
                break;
            case "gold":
                mult = 12;
                break;
        }
    }
}
