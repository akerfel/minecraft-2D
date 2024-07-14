public abstract class Mob extends Body {

    public Mob(float x, float y, float speedFactor, color c) {
        super(x, y, speedFactor, settings.mobWidthInBlocks, c);
    }
    
    float determineSpeed() {
        return speedFactor;
    }
}
