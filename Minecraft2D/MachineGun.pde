public class MachineGun extends Item {
    float reloadTime; // in milliseconds
    float lastTimeShot; 
    int multiShotNumber;

    public MachineGun(ItemID itemID) {
       super(itemID, ItemType.GUN, false); 
       this.c = color(31, 38, 42);
       this.reloadTime = 100;
       this.lastTimeShot = -10000;
       this.multiShotNumber = 5;
    }
    
    void startReloadTimer() {
        lastTimeShot = millis();
    }
    
    boolean isReadyToShoot() {
        return millis() > lastTimeShot + reloadTime;
    }
}
