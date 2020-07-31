void keyPressed() {
    if (key == 'd') {
        player.coords.x++;
    }
    else if (key == 'a') {
        player.coords.x--;
    }
    else if (key == 's') {
        player.coords.y++;
    }
    else if (key == 'w') {
        player.coords.y--;
    }
    println("player coords: " + player.coords.x + ", " + player.coords.y);
    loadInitalVisibleChunks();
}
