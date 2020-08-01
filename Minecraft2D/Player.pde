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
        float xMove = v*(int(isRight) - int(isLeft));
        float yMove = v*(int(isDown)  - int(isUp));
        float xNewPos = coords.x + xMove;
        float yNewPos = coords.y + yMove;
        
        if (!getBlock(new PVector(xNewPos, yNewPos)).isWall) {
            coords.x = xNewPos;
            coords.y = yNewPos;
        }
        if (getPlayerBlock().isWall) {
            coords.x -= xMove;
            coords.y -= yMove;
        }
        println("New pos: " + xNewPos + ", " + yNewPos);
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
