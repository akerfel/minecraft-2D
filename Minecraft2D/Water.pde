public class Water extends Block {
    public Water() {
        super("water", color(64, 64, 255) + color(random(-15, 15), random(-15, 15), 0), false, "nothing", false);    
        hardness = 100000;
    }
    
    public String toString() {
        return "water";    
    }
}
