public class Grass extends Block {
    public Grass() {
        super("grass", color(127, 178, 56) + color(random(-3, 3), random(-3, 3), random(-3, 3)), false, "shovel", false);    
    }
    
    public Grass(color colorScheme) {
        super("grass", color(127, 178, 56) + colorScheme + color(random(-20, 20), random(-20, 20), random(-20, 20)), false, "shovel", false);    
    }
    
    public String toString() {
        return "grass";    
    }
}
