void drawWorld() {
    drawVisibleBlocks();
    drawBodies();
    drawBullets();
}

void drawVisibleBlocks() {
    // xPixels and yPixels store the top left corner pixel positions of each block
    float[] xPixels = new float[settings.viewDistance];
    float[] yPixels = new float[settings.viewDistance];
    float xPlayerPixelOffset = (state.player.coords.x % 1) * settings.pixelsPerBlock;
    float yPlayerPixelOffset = (state.player.coords.y % 1) * settings.pixelsPerBlock;
    for (float i = 0; i < settings.viewDistance; i++) {
        float xPos = width/2 + (i - settings.viewDistance/2) * settings.pixelsPerBlock;
        float yPos = height/2 + (i - settings.viewDistance/2) * settings.pixelsPerBlock;
        xPixels[int(i)] = xPos - xPlayerPixelOffset;
        yPixels[int(i)] = yPos - yPlayerPixelOffset;
    }

    for (int y = 0; y < settings.viewDistance; y++) {
        for (int x = 0; x < settings.viewDistance; x++) {
            drawBlock(state.visibleBlocks[int(x)][int(y)], xPixels[x], yPixels[y]);
        }
    }
}

void drawBlock(Block block, float xPixel, float yPixel) {
    fill(block.c);
    square(xPixel, yPixel, settings.pixelsPerBlock + 1);
    
    if (settings.drawInnerSquaresInBlocks) {
        drawInnerSquareInBlock(block, xPixel, yPixel);
    }
    
    if (block.prcntBroken > 0) {
        drawBlockBreakingTexture(block, xPixel, yPixel);
    }
}

private void drawInnerSquareInBlock(Block block, float xPixel, float yPixel) {
    int colorDiff = 10;
    int innerRedValue = max(0, int(red(block.c)) - colorDiff);
    int innerGreenValue = max(0, int(green(block.c)) - colorDiff);
    int innerBlueValue = max(0, int(blue(block.c)) - colorDiff);
    color innerColor = color(innerRedValue, innerGreenValue, innerBlueValue);
    fill(innerColor);
    int offset = int(settings.pixelsPerBlock * settings.offsetInnerSquare);
    square(xPixel + offset, yPixel + offset, settings.pixelsPerBlock - offset * 2);
}

void drawBlockBreakingTexture(Block block, float xPixel, float yPixel) {
    fill(block.prcntBroken * 255);
    circle(xPixel + settings.pixelsPerBlock/2, yPixel + settings.pixelsPerBlock/2, (block.prcntBroken * settings.pixelsPerBlock));
}

void drawBodies() {
    for (Body body : state.bodies) {
        drawBody(body);
    }
}

void drawBullets() {
    for (Bullet bullet : state.bullets) {
        drawBullet(bullet);
    }
}

PVector coordsToPixelPosition(PVector coords) {
    float xBlocksToPlayer = coords.x - state.player.coords.x;
    float yBlocksToPlayer = coords.y - state.player.coords.y;
    float x = width/2 + xBlocksToPlayer * settings.pixelsPerBlock;
    float y = height/2 + yBlocksToPlayer * settings.pixelsPerBlock;
    return new PVector(x, y);
}

void drawBody(Body body) {
    fill(body.c);
    drawCircleWithTopLeftCornerAt(body.coords, body.diameterInBlocks);
}

void drawBullet(Bullet bullet) {
    fill(10);
    drawCircleWithTopLeftCornerAt(bullet.coords, bullet.diameterInBlocks);
}

void drawCircleWithTopLeftCornerAt(PVector coords, float diameterInBlocks) {
    PVector pixelPosition = coordsToPixelPosition(coords);
    float widthInPixels = diameterInBlocks * settings.pixelsPerBlock;
    ellipseMode(CORNER);
    circle(pixelPosition.x, pixelPosition.y, widthInPixels);
    ellipseMode(CENTER);
}
