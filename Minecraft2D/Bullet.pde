class Bullet {
    PVector coords;
    float baseSpeed;
    PVector direction;
    float diameterInBlocks;
    int hp; // bullet will be removed if hp is 0
    int damage;

    Bullet(PVector coords, PVector direction, float diameterInBlocks) {
        this.coords = coords.copy();
        this.direction = direction.normalize();
        this.baseSpeed = settings.bulletBaseSpeed;
        this.diameterInBlocks = diameterInBlocks;
        this.hp = 1;
        this.damage = 1;
    }
    
    void update() {
        coords.add(direction.copy().setMag(baseSpeed));
        
        if (isCollidingWithWall()) {
            hp = 0;  
            return;
        }
        
        handleMobCollision();
    }
    
    void handleMobCollision() {
        if (isAlive()) {
            for (Body body : state.bodies) {
                if (!(body instanceof Player) && circlesAreColliding(this.coords, body.coords, this.diameterInBlocks, body.diameterInBlocks)) {
                    if (!body.isDead()) {
                        body.damage(damage);
                        hp--;
                    }
                }
            }
        }
    }
    
    boolean isCollidingWithWall() {
        return squareIsCollidingWithWall(coords, settings.bulletDiameterInBlocks);
    }
    
    boolean isDead() {
        return hp <= 0;    
    }
    
    boolean isAlive() {
        return !isDead();    
    }
}
