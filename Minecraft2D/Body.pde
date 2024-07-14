public abstract class Body {
    PVector coords;
    float speedFactor;
    color c;
    PVector direction;
    float diameterInBlocks;
    int hp;

    public Body(float x, float y, float speedFactor, float widthInBlocks, color c) {
        coords = new PVector(x, y);
        this.speedFactor = speedFactor;
        this.direction = new PVector(0, 0);
        this.diameterInBlocks = widthInBlocks;
        this.c = c;
        this.hp = 1;
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
    
    void damage(int damage) {
        hp -= damage;    
    }
    
    boolean isDead() {
        return hp <= 0;    
    }
    
    abstract float determineSpeed();
    
    abstract void determineDirection();
    
    public boolean isCollidingWithWall() {
        return squareIsCollidingWithWall(coords, diameterInBlocks);
    }
    
    public boolean isCollidingWithWallOrWater() {
        return squareIsCollidingWithWallOrWater(coords, diameterInBlocks);
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
