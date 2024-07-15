public abstract class Mob extends Body {

    public Mob(float x, float y, float baseSpeed, float mobWidthInBlocks, color c) {
        super(x, y, baseSpeed, mobWidthInBlocks, c);
    }
    
    float determineSpeed() {
        return baseSpeed;
    }
}
