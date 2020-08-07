public class Grass extends Block {
    public Grass() {
        super(color(127, 178, 56), false, "shovel");    
    }
    
    public Grass(color colorScheme) {
        super(color(127, 178, 56) + colorScheme, false, "shovel");    
    }
    
    public String toString() {
        return "Grass";    
    }
}
