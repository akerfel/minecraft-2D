public class Tool extends Item {
    ToolMaterial toolMaterial; 
    ToolType toolType;
    int mult;            // Mining speed multiplier

    public Tool(ItemID itemID) {
        super(itemID, ItemType.TOOL);
        setToolMaterial();
        setToolType();
    }
    
    private void setToolMaterial() {
        if (woodToolIDs.contains(itemID)) {
            toolMaterial = ToolMaterial.WOOD;
            mult = 2;
            c = color(143, 119, 72);
            return;
        } else if (stoneToolIDs.contains(itemID)) {
            toolMaterial = ToolMaterial.STONE;
            mult = 4;
            c = color(112, 112, 112);
        } else if (ironToolIDs.contains(itemID)) {
            toolMaterial = ToolMaterial.IRON;
            mult = 6;
            c = color(167, 167, 167);
        } else if (goldToolIDs.contains(itemID)) {
            toolMaterial = ToolMaterial.GOLD;
            mult = 12;
            c = color(250, 238, 77);
        } else if (diamondToolIDs.contains(itemID)) {
            toolMaterial = ToolMaterial.DIAMOND;
            mult = 8;
            c = color(92, 219, 213);
        }    
    }
    
    private void setToolType() {
        if (swordIDs.contains(itemID)) {
            toolType = ToolType.SWORD;
            return;
        } else if (pickaxeIDs.contains(itemID)) {
            toolType = ToolType.PICKAXE;
            return;
        } else if (shovelIDs.contains(itemID)) {
            toolType = ToolType.SHOVEL;
            return;
        } else if (axeIDs.contains(itemID)) {
            toolType = ToolType.AXE;
            return;
        } else if (hoeIDs.contains(itemID)) {
            toolType = ToolType.HOE;
            return;
        }    
    }
}
