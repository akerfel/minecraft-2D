public class MachineGun extends Item {
    float reloadTime; // in milliseconds
    float lastTimeShot; 
    float bulletSpeed; 
    int multiShotNumber;
    float bulletDiameterInBlocks;
    boolean skewInitialBulletDirection;
    boolean bulletIsOnFire;

    public MachineGun(ItemID itemID) {
       super(itemID, ItemType.GUN, false); 
       this.c = color(31, 38, 42);
       this.reloadTime = 200;
       this.lastTimeShot = -10000;
       this.bulletSpeed = settings.bulletBaseSpeed;
       this.multiShotNumber = 1;
       this.bulletDiameterInBlocks = settings.bulletDiameterInBlocks;
       this.skewInitialBulletDirection = false;
       this.bulletIsOnFire = false;
    }
    
    void startReloadTimer() {
        lastTimeShot = millis();
    }
    
    boolean isReadyToShoot() {
        return millis() > lastTimeShot + reloadTime;
    }
}
