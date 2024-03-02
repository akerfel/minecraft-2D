public class Tool extends Item {
    ToolType toolType;
    ToolMaterial toolMaterial; 
    int mult;            // Mining speed multiplier

    public Tool(ItemID itemID, ToolType toolType, ToolMaterial toolMaterial, int mult, color c) {
        super(itemID, ItemType.TOOL, false);
        this.toolType = toolType;
        this.toolMaterial = toolMaterial;
        this.mult = mult;
        this.c = c;
    }
}
