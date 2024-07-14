public abstract class Mob extends Body {

    public Mob(float x, float y, float speedFactor, float mobWidthInBlocks, color c) {
        super(x, y, speedFactor, mobWidthInBlocks, c);
    }
    
    float determineSpeed() {
        return speedFactor;
    }
}
