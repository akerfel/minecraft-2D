public class Animal {
    public PVector coords;
    float speed;
    public color c;
   
    public Animal(float x, float y) {
        coords = new PVector(x, y);
        speed = 0.02;
        c = color(255, 192, 203);
        println("made animal at " + coords.x + ", " + coords.y);
    }
}
