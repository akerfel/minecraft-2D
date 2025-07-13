public class FlameThrower extends MachineGun {

    public FlameThrower(ItemID itemID) {
       super(itemID); 
       this.c = color(244, 38, 42);
       this.reloadTime = 10;
       this.lastTimeShot = -10000;
       this.multiShotNumber = 2;
    }
}
