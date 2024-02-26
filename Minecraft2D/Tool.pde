public class Tool extends Item {
    ToolType toolType;     // E.g. "pick", "shovel" or "axe"
    ToolMaterial material;     // E.g. "wood", "stone" or "iron"
    int mult;            // Mining speed multiplier

    // E.g. for making new tool:
    // Tool diamondPick = new Tool("diamond", "pick");
    public Tool(ToolMaterial material, ToolType toolType) {
        super("tool", material.name() + "_" + toolType.name());
        println(toolType.name());
        this.toolType = toolType;
        this.material = material;
        switch (material) {
        case WOOD:
            mult = 2;
            c = color(143, 119, 72);
            break;
        case STONE:
            mult = 4;
            c = color(112, 112, 112);
            break;
        case IRON:
            mult = 6;
            c = color(167, 167, 167);
            break;
        case GOLD:
            mult = 12;
            c = color(250, 238, 77);
            break;
        case DIAMOND:
            mult = 8;
            c = color(92, 219, 213);
            break;
        }
    }

    public String getInventoryLabel() {
        switch(toolType) {
            case PICK:
                return "PICK";
            case SHOVEL:
                return "SHVL";
            case AXE:
                return "AXE";
            case SWORD:
                return "SWRD";
            default:
                return "";
        }
    }
}
