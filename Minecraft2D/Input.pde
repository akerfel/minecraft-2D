void keyPressed() {
    if (keyPressed) {
        if (key == 's') {
            player.movingDown = true;
            player.movingUp = false;
            //player.movingRight = false;
            //player.movingLeft = false;
        }
        else if (key == 'w') {
            player.movingUp = true;
            player.movingDown = false;
            //player.movingRight = false;
            //player.movingLeft = false;
        }
        if (key == 'd') {
            player.movingRight = true;
            player.movingLeft = false;
            //player.movingDown = false;
            //player.movingUp = false;
        }
        if (key == 'a') {
            player.movingLeft = true;
            player.movingRight= false;
            //player.movingDown = false;
            //player.movingUp = false;
        }
    }
    else {
        player.movingLeft = false;
        player.movingRight = false;
        player.movingDown = false;
        player.movingUp = false;
    }
    
    println("player coords: " + player.coords.x + ", " + player.coords.y);
    
}

void keyReleased() {
    if (key == 'd') {
        player.movingDown = false;
    }
    if (key == 'w') {
        player.movingUp = false;
    }
    if (key == 's') {
        player.movingRight = false;
    }
    if (key == 'a') {
        player.movingLeft = false;
    }
    
    println("player coords: " + player.coords.x + ", " + player.coords.y);
    loadInitalVisibleChunks();
}
