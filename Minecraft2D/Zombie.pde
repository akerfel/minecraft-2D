import java.util.ArrayList;
import java.util.List;

public class Zombie extends Mob {
    PVector lastSeenPlayerCoords;

    public Zombie(float x, float y) {
        super(x, y, settings.zombieBaseSpeed, settings.zombieWidthInBlocks, settings.zombieColor);
        c = color(102, 0, 0);
        lastSeenPlayerCoords = null;
    }

    void determineDirection() {
        if (canSeePlayer()) {
            lastSeenPlayerCoords = state.player.coords.copy();
        }
        if (lastSeenPlayerCoords != null) {
            setDirectionTowards(lastSeenPlayerCoords);
        }
    }
    
    void setDirectionTowards(PVector target) {
        direction = target.copy();
        direction.sub(this.coords);
        direction.normalize();
    }
    
    boolean canSeePlayer() {
        if (getDistancesBetweenBodiesInBlocks(this, state.player) > settings.mobLineOfSightRange) {
            return false;
        }
        
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
