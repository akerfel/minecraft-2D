import java.io.Serializable;
import java.awt.Color;

public class Item implements Serializable {
    String type;
    Color colorRGB;

    public Item(String type) {
        this.type = type;
    }
}
