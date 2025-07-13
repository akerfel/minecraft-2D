public class FlameThrower extends MachineGun {

    public FlameThrower(ItemID itemID) {
       super(itemID); 
       this.c = color(244, 38, 42);
       this.reloadTime = 10;
       this.multiShotNumber = 2;
       this.bulletDiameterInBlocks = settings.flameThrowerBulletDiameterInBlocks;
       this.skewInitialBulletDirection = true;
       this.bulletIsOnFire = true;
       this.bulletSpeed = settings.flameThrowerBulletSpeed;
    }
}
