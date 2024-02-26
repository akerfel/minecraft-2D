public class Item {
    final String name;            // unique identifier   
    String type;
    color c;

    public Item(String type, String name) {
        this.type = type;
        this.name = name;
        c = color(255, 0, 0);
    }
    
    public String toString() {
        return name;
    }
}
