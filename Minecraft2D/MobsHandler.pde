void removeDeadMobs() {
    Iterator<Body> it = state.bodies.iterator();
    while (it.hasNext()) {
        Body body = it.next();
        if (!(body instanceof Player) && body.isDead()) {
            it.remove();
        }
    }
}

void removeFarMobs() {
    Iterator<Body> it = state.bodies.iterator();
    while (it.hasNext()) {
        Body body = it.next();
        if (body instanceof Mob) {
            if (state.player.coords.dist(((Mob) body).coords) > settings.mobDespawnRange) {
                it.remove();
            }
        }
    }
}

void maybeSpawnMobs() {
    println("bodies: " + state.bodies.size());
    if (state.bodies.size() < settings.maxMobs) {
        if (random(0, 1) < settings.pigSpawnChance) {
            spawnMob(MobType.PIG);
        }
        if (random(0, 1) < settings.zombieSpawnChance) {
            spawnMob(MobType.ZOMBIE);
        }
    }
}

void removeAllMobs() {
    state.bodies.clear();
    state.bodies.add(state.player);
}

PVector getSpawnCoordsForNewMob() {
    PVector randomDirection = PVector.random2D();
    randomDirection.normalize();
    float distanceToPlayer = random(settings.mobMinSpawnRange, settings.mobMaxSpawnRange);
    PVector diffToPlayer = randomDirection.mult(distanceToPlayer);
    return floorVector(state.player.coords.copy().add(diffToPlayer));
}

void spawnMob(MobType mobType) {
    PVector spawnCoords = getSpawnCoordsForNewMob();
    
    if (!getBlock(spawnCoords).isWallOrWater()) {
        switch(mobType) {
        case PIG:
            spawnMobIfNotCollidingWithAnother(new Pig(spawnCoords.x, spawnCoords.y));
            return;
        case ZOMBIE: 
            spawnMobIfNotCollidingWithAnother(new Zombie(spawnCoords.x, spawnCoords.y)); 
            return;
        }   
    }   
}
