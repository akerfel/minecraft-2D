public class Water extends Block {
    public Water() {
        super(color(64, 64, 255), false, "nothing");    
        hardness = 100000;
    }
    
    public String toString() {
        return "water";    
    }
}
