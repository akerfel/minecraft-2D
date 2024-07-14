public class MachineGun extends Item {
    float reloadTime; // in milliseconds
    float lastTimeShot; 
    
    public MachineGun(ItemID itemID) {
       super(itemID, ItemType.GUN, false); 
       this.c = color(31, 38, 42);
       this.reloadTime = 800;
       this.lastTimeShot = -10000;
    }
    
    void startReloadTimer() {
        lastTimeShot = millis();
    }
    
    boolean isReadyToShoot() {
        return millis() > lastTimeShot + reloadTime;
    }
}
