void drawWorld() {
    drawVisible2dBlocks();
    drawBodies();
    drawBullets();
    drawVisible3dBlocks();
}

void drawVisible2dBlocks() {
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
        for (int x = settings.viewDistance - 1; x > -1 ; x--) {
            draw2dBlock(state.visibleBlocks[int(x)][int(y)], xPixels[x], yPixels[y]);
        }
    }
}

void drawVisible3dBlocks() {
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
        for (int x = settings.viewDistance - 1; x > -1 ; x--) {
            Block block = state.visibleBlocks[int(x)][int(y)];
            if (block.isWall) {
                if (x > 0 && state.visibleBlocks[int(x) - 1][int(y)] != null && state.visibleBlocks[int(x) - 1][int(y)].isWall && 
                    y < settings.viewDistance - 1 && state.visibleBlocks[int(x)][int(y) + 1] != null && state.visibleBlocks[int(x)][int(y) + 1].isWall) {
                    drawTopOf3dBlock(block, xPixels[x], yPixels[y]);
                }
                else {
                    draw3dBlock(block, xPixels[x], yPixels[y]);
                }
            }
        }
    }
}

// x and y are pixel positions of the upper left corner of the block
void draw2dBlock(Block block, float x, float y) {
    if (!block.isWall) {
        fill(block.c);
        square(x, y, settings.pixelsPerBlock + 1);
        if (settings.drawInnerSquaresInBlocks) {
            drawInnerSquareInBlock(block, x, y);
        }
    }
}

// x and y are pixel positions of the upper left corner of the block
void draw3dBlock(Block block, float x, float y) {
    if (block.isWall) {
        fill(block.c);
        
        // 3d
        float offset3d = settings.offsetFactor3d * settings.pixelsPerBlock;
        float x3d = x + offset3d;
        float y3d = y - offset3d;
        float perBlock = settings.pixelsPerBlock;
        
        // NW = North West corner pixel position
        float xNW = x;
        float xSW = x;
        float xNE = x + perBlock;
        float xSE = x + perBlock;
        
        float yNW = y;
        float ySW = y + perBlock;
        float yNE = y;
        float ySE = y + perBlock;
        
        float x3dNW = x3d;
        float x3dSW = x3d;
        float x3dNE = x3d + perBlock;
        float x3dSE = x3d + perBlock;
        
        float y3dNW = y3d;
        float y3dSW = y3d + perBlock;
        float y3dNE = y3d;
        float y3dSE = y3d + perBlock;
        
        color c = darkenColor(block.c, 0.87);
        fill(c);
        stroke(c);
        quad(xNW , yNW, x3dNW, y3dNW, x3dSW, y3dSW, xSW, ySW);
        
        c = darkenColor(block.c, 0.92);
        fill(c);
        stroke(c);
        quad(xSW, ySW, x3dSW, y3dSW, x3dSE, y3dSE, xSE, ySE);
        
        fill(block.c);
        stroke(block.c);
        rect(x3d, y3d, perBlock, perBlock);
        
        if (block.prcntBroken > 0) {
            drawBlockBreakingTexture(block, x3d, y3d);
        }
        
        if (settings.noStrokeMode) {
            noStroke();
        }
    }
}

// x and y are pixel positions of the upper left corner of the block
void drawTopOf3dBlock(Block block, float x, float y) {
    if (block.isWall) {
        fill(block.c);
        
        // 3d
        float offset3d = settings.offsetFactor3d * settings.pixelsPerBlock;
        float x3d = x + offset3d;
        float y3d = y - offset3d;
        float perBlock = settings.pixelsPerBlock;
        
        fill(block.c);
        stroke(block.c);
        rect(x3d, y3d, perBlock, perBlock);
        
        if (block.prcntBroken > 0) {
            drawBlockBreakingTexture(block, x3d, y3d);
        }
        
        if (settings.noStrokeMode) {
            noStroke();
        }
    }
}

color darkenColor(color c, float factor) {
  // Ensure the factor is between 0 and 1
  factor = constrain(factor, 0, 1);
  
  // Get the RGB components of the color
  float r = red(c);
  float g = green(c);
  float b = blue(c);
  
  // Decrease each component by the factor
  r *= factor;
  g *= factor;
  b *= factor;
  
  // Return the new darker color
  return color(r, g, b);
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
