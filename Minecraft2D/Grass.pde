public class Grass extends Block {
    public Grass() {
        super(color(127, 178, 56), false);    
    }
    
    public Grass(color colorScheme) {
        super(color(127, 178, 56) + colorScheme, false);    
    }
    
    public String toString() {
        return "Grass";    
    }
}
