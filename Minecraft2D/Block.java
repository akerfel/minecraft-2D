import java.io.Serializable;
import java.awt.Color;

public class Block extends Item implements Serializable {
    String name;                  // Used as a unique identifier
    public boolean isWall;
    double prcntBroken;
    double timeDamagedLastTime;    // millis
    double hardness;
    String toolTypeForMining;
    boolean isMineable;

    public Block(String name, Color colorRGB, boolean isWall, String toolTypeForMining, boolean isMineable) {
        super("block");
        this.name = name;
        this.colorRGB = colorRGB;
        this.isWall = isWall;
        this.prcntBroken = 0;
        this.hardness = 1.5;
        this.toolTypeForMining = toolTypeForMining;
        this.isMineable = isMineable;
    }
}
