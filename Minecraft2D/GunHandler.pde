MachineGun getHeldGun() {
    return (MachineGun) state.player.getSelectedItemSlot().item;
}

boolean heldGunIsReadyToShoot() {
    return !state.inventoryIsOpen && getHeldGun().isReadyToShoot();
}

void shootPlayerGun() {
    MachineGun gun = getHeldGun();
    gun.startReloadTimer();
    addPlayerBullets();
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
    PVector startCoords = state.player.getCenterCoords();
    PVector bulletVectorCornerToCenter = new PVector(settings.bulletDiameterInBlocks/2, settings.bulletDiameterInBlocks/2);
    startCoords.sub(bulletVectorCornerToCenter);
    PVector direction = determineDirectionOfPlayerBullet();
    return new Bullet(startCoords, direction, settings.bulletDiameterInBlocks);
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
