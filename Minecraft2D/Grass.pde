public class Grass extends Block {
    public Grass() {
        super("grass", color(127, 178, 56), false, "shovel", false);    
    }
    
    public Grass(color colorScheme) {
        super("grass", color(127, 178, 56) + colorScheme, false, "shovel", false);    
    }
    
    public String toString() {
        return "grass";    
    }
}
