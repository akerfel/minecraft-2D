public class Zombie extends Mob {

    public Zombie(float x, float y) {
        super(x, y, settings.zombieSpeedFactor, settings.zombieColor);
        c = color(102, 0, 0);
    }

    void determineDirection() {
        direction = state.player.coords.copy();
        direction.sub(this.coords);
        direction.normalize();
    }
}
