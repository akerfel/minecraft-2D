public class Tool extends Item {
    ToolMaterial material; 
    int mult;            // Mining speed multiplier

    // E.g. for making new tool:
    // Tool diamondPick = new Tool("diamond", "pick");
    public Tool(ItemID itemID) {
        super(ItemType.TOOL, itemID);
        
        if (woodToolIDs.contains(itemID)) {
            mult = 2;
            c = color(143, 119, 72);
            return;
        } else if (stoneToolIDs.contains(itemID)) {
            mult = 4;
            c = color(112, 112, 112);
        } else if (ironToolIDs.contains(itemID)) {
            mult = 6;
            c = color(167, 167, 167);
        } else if (goldToolIDs.contains(itemID)) {
            mult = 12;
            c = color(250, 238, 77);
        } else if (diamondToolIDs.contains(itemID)) {
            mult = 8;
            c = color(92, 219, 213);
        }
    }
}
