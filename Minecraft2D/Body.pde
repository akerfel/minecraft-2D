public abstract class Body {
    PVector coords;
    float speedFactor;
    color c;
    PVector direction;
    float widthInBlocks;

    public Body(float x, float y, float speedFactor, float widthInBlocks, color c) {
        coords = new PVector(x, y);
        this.speedFactor = speedFactor;
        this.direction = new PVector(0, 0);
        this.widthInBlocks = widthInBlocks;
        this.c = c;
    }

    void update() {
        float xPrevious = coords.x;
        float yPrevious = coords.y;
        
        float speed = determineSpeed();
        determineDirection();
        
        coords.x += direction.x * speed;
        coords.y += direction.y * speed;
        
        revertStepIfWalkedIntoWall(xPrevious, yPrevious);
        revertStepIfWalkedIntoBody(xPrevious, yPrevious);
    }
    
    abstract float determineSpeed();
    
    abstract void determineDirection();
    
    public boolean isCollidingWithWall() {
        return squareIsCollidingWithWall(coords, widthInBlocks);
    }
    
    public boolean isCollidingWithWallOrWater() {
        return squareIsCollidingWithWallOrWater(coords, widthInBlocks);
    }
    
    public boolean isCollidingWithAnotherBody() {
        for (Body otherBody : state.bodies) {
            if (bodiesAreColliding(this, otherBody)) {
                return true;
            }
        }
        return false;
    }
    
    void revertStepIfWalkedIntoWall(float xPrevious, float yPrevious) {
        float xCollide = coords.x;
        float yCollide = coords.y;
        
        if (isCollidingWithWall()) {
            coords.x = xPrevious;
            coords.y = yPrevious;
        }
        else {
            return;    
        }
        
        coords.x = xCollide;
        if (isCollidingWithWall()) {
            coords.x = xPrevious;
        }
        else {
            return;
        }
        
        coords.y = yCollide;
        if (isCollidingWithWallOrWater()) {
            coords.y = yPrevious;
        }
    }
    
    void revertStepIfWalkedIntoBody(float xPrevious, float yPrevious) {
        float xCollide = coords.x;
        float yCollide = coords.y;
        
        if (isCollidingWithAnotherBody()) {
            coords.x = xPrevious;
            coords.y = yPrevious;
        }
        else {
            return;    
        }
        
        coords.x = xCollide;
        if (isCollidingWithAnotherBody()) {
            coords.x = xPrevious;
        }
        
        coords.y = yCollide;
        if (isCollidingWithAnotherBody()) {
            coords.y = yPrevious;
        }
    }
}
