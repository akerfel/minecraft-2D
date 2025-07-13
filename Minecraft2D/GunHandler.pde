MachineGun getHeldGun() {
    return (MachineGun) state.player.getSelectedItemSlot().item;
}

boolean heldGunIsReadyToShoot() {
    if (!playerHasRequiredAmountOfBullets()) {
        return false;
    }
    return getHeldGun().isReadyToShoot();
}

boolean playerHasRequiredAmountOfBullets() {
    MachineGun gun = getHeldGun();
    Item requiredBullet = createItem(ItemID.IRON_BULLET);
    return state.player.inventory.hasItem(requiredBullet, gun.multiShotNumber);
}

void shootPlayerGun() {
    if (heldGunIsReadyToShoot()) {
        MachineGun gun = getHeldGun();
        gun.startReloadTimer();
        addPlayerBullets();
        consumePlayerBullets();
    }
}

void consumePlayerBullets() {
    ItemCount toRemove = new ItemCount(createItem(ItemID.IRON_BULLET), getHeldGun().multiShotNumber);
    state.player.inventory.removeItems(toRemove);
}

void addPlayerBullets() {
    int numBullets = getHeldGun().multiShotNumber;
    if (numBullets % 2 == 1) {
        for (int i = - floor(float(numBullets) / 2.0); i < floor(float(numBullets) / 2.0 + 1); i++) {
            Bullet bullet = createPlayerBullet();
            PVector offset = bullet.direction.copy().rotate(HALF_PI).setMag(i);
            bullet.coords.add(offset);
            state.bullets.add(bullet);
        }
    }
    else {
        for (int i = - floor(float(numBullets) / 2.0); i < floor(float(numBullets) / 2.0); i++) {
            Bullet bullet = createPlayerBullet();
            PVector offset = bullet.direction.copy().rotate(HALF_PI).setMag(i + 0.5);
            bullet.coords.add(offset);
            state.bullets.add(bullet);
        }
    }
}

Bullet createPlayerBullet() {
    float bulletDiameterInBlocks = settings.bulletDiameterInBlocks;
    if (getHeldGun() instanceof FlameThrower) {
        bulletDiameterInBlocks = settings.flameThrowerBulletDiameterInBlocks;
    }
    
    PVector startCoords = state.player.getCenterCoords();
    PVector bulletVectorCornerToCenter = new PVector(bulletDiameterInBlocks/2, bulletDiameterInBlocks/2);
    startCoords.sub(bulletVectorCornerToCenter);
    PVector direction = determineDirectionOfPlayerBullet();
    
    
    if (getHeldGun() instanceof FlameThrower) {
        float angle = random(-PI/4, PI/4);
        direction.rotate(angle);
    }
    
    return new Bullet(startCoords, direction, bulletDiameterInBlocks);
}

PVector determineDirectionOfPlayerBullet() {
    return state.player.getVectorToMouse().normalize();
}

void updateBullets() {
    for (Bullet bullet : state.bullets) {
        bullet.update();    
    }
    removeDeadBullets();
}

void removeDeadBullets() {
    Iterator<Bullet> it = state.bullets.iterator();
    while (it.hasNext()) {
        if (it.next().isDead()) {
            it.remove();
        }
    }
}
