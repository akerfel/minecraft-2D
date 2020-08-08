public class Leaves extends Block {
    public Leaves() {
        super("leaves", color(0, 124, 0) + color(random(-30, 30), random(-0, 30), random(-30, 30)), true, "sword", true);    
        this.hardness = 0.2;
    }
    
    public String toString() {
        return "leaves";    
    }
}
