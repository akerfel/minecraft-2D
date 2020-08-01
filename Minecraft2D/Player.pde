// Movement code mostly taken from http://studio.processingtogether.com/sp/pad/export/ro.91tcpPtI9LrXp

public class Player {
    PVector coords;
    float v;
    boolean isLeft, isRight, isUp, isDown;
    
    public Player(float x, float y) {
        coords = new PVector(x, y);
        v = 0.1;
    }
    
    void move() {
        // Save previous coords
        float xPrevious = coords.x;
        float yPrevious = coords.y;
        // Change coords
        coords.x += v*(int(isRight) - int(isLeft));
        coords.y += v*(int(isDown)  - int(isUp));
        // If new coords are inside wall, go back to old coords
        if (getPlayerBlock().isWall) {
            coords.x = xPrevious;
            coords.y = yPrevious;
        }
    }
    
    boolean setMove(final int k, final boolean b) {
        switch (k) {
            case +'W':
            case UP:
                  return isUp = b;
         
            case +'S':
            case DOWN:
                  return isDown = b;
         
            case +'A':
            case LEFT:
                  return isLeft = b;
         
            case +'D':
            case RIGHT:
                  return isRight = b;
         
            default:
                  return b;
        }
    }
}
