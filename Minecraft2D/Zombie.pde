import java.util.ArrayList;
import java.util.List;

public class Zombie extends Mob {

    public Zombie(float x, float y) {
        super(x, y, settings.zombieSpeedFactor, settings.zombieWidthInBlocks, settings.zombieColor);
        c = color(102, 0, 0);
    }

    void determineDirection() {
        if (canSeePlayer()) {
            direction = state.player.coords.copy();
            direction.sub(this.coords);
            direction.normalize();
            return;
        }
        direction = new PVector(0, 0);
    }
    
    List<PVector> bresenhamLine(float x0, float y0, float x1, float y1) {
        List<PVector> line = new ArrayList<>();

        float dx = Math.abs(x1 - x0);
        float dy = Math.abs(y1 - y0);
        float sx = x0 < x1 ? 1 : -1;
        float sy = y0 < y1 ? 1 : -1;
        float err = dx - dy;

        while (true) {
            line.add(new PVector(x0, y0));
            if (x0 == x1 && y0 == y1) {
                break;
            }
            float e2 = 2 * err;
            if (e2 > -dy) {
                err -= dy;
                x0 += sx;
            }
            if (e2 < dx) {
                err += dx;
                y0 += sy;
            }
        }
        return line;
    }
    
    boolean canSeePlayer() {
        float x0 = Math.round(coords.x);
        float y0 = Math.round(coords.y);
        float x1 = Math.round(state.player.coords.x);
        float y1 = Math.round(state.player.coords.y);

        List<PVector> line = bresenhamLine(x0, y0, x1, y1);
        for (PVector point : line) {
            Block block = getBlock(point.x, point.y);
            if (block != null && block.isWall) {
                return false;
            }
        }
        return true;
    }
}
