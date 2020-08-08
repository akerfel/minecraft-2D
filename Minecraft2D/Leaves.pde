public class Leaves extends Block {
    public Leaves() {
        super("leaves", color(0, 124, 0), true, "sword", true);    
        this.hardness = 0.2;
    }
    
    public String toString() {
        return "leaves";    
    }
}
