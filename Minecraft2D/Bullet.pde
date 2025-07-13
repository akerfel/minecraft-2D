class Bullet {
    PVector coords;
    float baseSpeed;
    PVector direction;
    float diameterInBlocks;
    int hp; // bullet will be removed if hp is 0
    int damage;
    boolean isOnFire;
    int creationTime;

    Bullet(PVector coords, PVector direction, float diameterInBlocks, float baseSpeed) {
        this.coords = coords.copy();
        this.direction = direction.normalize();
        this.baseSpeed = baseSpeed;
        this.diameterInBlocks = diameterInBlocks;
        this.hp = 1;
        this.damage = 1;
        this.isOnFire = false;
        this.creationTime = millis();
    }
    
    void update() {
        coords.add(direction.copy().setMag(baseSpeed));
        
        if (isCollidingWithWall() ||
            (isOnFire && millis() - creationTime > settings.flameThrowerBulletLiveTime)) {
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
        return squareIsCollidingWithWall(coords, this.diameterInBlocks);
    }
    
    boolean isDead() {
        return hp <= 0;    
    }
    
    boolean isAlive() {
        return !isDead();    
    }
}
