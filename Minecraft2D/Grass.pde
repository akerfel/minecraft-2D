public class Grass extends Block {
    public Grass(color colorScheme) {
        super(color(127, 178, 56) + colorScheme, false);    
    }
    
    public String toString() {
        return "Grass";    
    }
}
