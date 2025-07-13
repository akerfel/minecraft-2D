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
            Block block = state.visibleBlocks[int(x)][int(y)];
            if (!block.isWall) {
                draw2dBlock(block, xPixels[x], yPixels[y]);
            }
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
                // Only draw the west and south wall if they are visible
                if (x > 0 && !state.visibleBlocks[int(x) - 1][int(y)].isWall) {
                    drawWestWallOf3dBlock(block, xPixels[x], yPixels[y]);
                }
                if (y < settings.viewDistance - 1 && !state.visibleBlocks[int(x)][int(y) + 1].isWall) {
                    drawSouthWallOf3dBlock(block, xPixels[x], yPixels[y]);
                }
                drawTopOf3dBlock(block, xPixels[x], yPixels[y]);
            }
        }
    }
}



// x and y are pixel positions of the upper left corner of the block
void draw2dBlock(Block block, float x, float y) {
    fill(block.c);
    square(x, y, settings.pixelsPerBlock + 1);
    if (settings.drawInnerSquaresInBlocks) {
        drawInnerSquareInBlock(block, x, y);
    }
}

// x and y are pixel positions of the upper left corner of the block
void draw3dBlock(Block block, float x, float y) {
    drawWestWallOf3dBlock(block, x, y);
    drawSouthWallOf3dBlock(block, x, y);
    drawTopOf3dBlock(block, x, y);
}

// x and y are pixel positions of the upper left corner of the block
void drawSouthWallOf3dBlock(Block block, float x, float y) {
    float offset3d = settings.offsetFactor3d * settings.pixelsPerBlock;
    float x3d = x + offset3d;
    float y3d = y - offset3d;
    float perBlock = settings.pixelsPerBlock;
    
    // NW = North West corner pixel position
    float xSW = x;
    float xSE = x + perBlock;
    
    float ySW = y + perBlock;
    float ySE = y + perBlock;
    
    float x3dSW = x3d;
    float x3dSE = x3d + perBlock;
    
    float y3dSW = y3d + perBlock;
    float y3dSE = y3d + perBlock;
    
    color c = darkenColor(block.c, settings.southWallShadeFactor);
    fill(c);
    stroke(c);
    quad(xSW, ySW, x3dSW, y3dSW, x3dSE, y3dSE, xSE, ySE);
    
    if (settings.noStrokeMode) {
        noStroke();
    }
}

// x and y are pixel positions of the upper left corner of the block
void drawWestWallOf3dBlock(Block block, float x, float y) {
    float offset3d = settings.offsetFactor3d * settings.pixelsPerBlock;
    float x3d = x + offset3d;
    float y3d = y - offset3d;
    float perBlock = settings.pixelsPerBlock;
    
    // NW = North West corner pixel position
    float xNW = x;
    float xSW = x;
    
    float yNW = y;
    float ySW = y + perBlock;
    
    float x3dNW = x3d;
    float x3dSW = x3d;
    
    float y3dNW = y3d;
    float y3dSW = y3d + perBlock;
    
    color c = darkenColor(block.c, settings.westWallShadeFactor);
    fill(c);
    stroke(c);
    quad(xNW , yNW, x3dNW, y3dNW, x3dSW, y3dSW, xSW, ySW);
    
    if (settings.noStrokeMode) {
        noStroke();
    }
}

// x and y are pixel positions of the upper left corner of the block
void drawTopOf3dBlock(Block block, float x, float y) {
    float offset3d = settings.offsetFactor3d * settings.pixelsPerBlock;
    float x3d = x + offset3d;
    float y3d = y - offset3d;
    float perBlock = settings.pixelsPerBlock;
    
    fill(block.c);
    stroke(block.c);
    rect(x3d, y3d, perBlock, perBlock);
    
    if (settings.drawInnerSquaresInBlocks) {
        drawInnerSquareInBlock(block, x3d, y3d);
    }
    
    if (block.prcntBroken > 0) {
        drawBlockBreakingTexture(block, x3d, y3d);
    }
    
    if (settings.noStrokeMode) {
        noStroke();
    }
}

color darkenColor(color c, float factor) {
  factor = constrain(factor, 0, 1);
  
  float r = red(c);
  float g = green(c);
  float b = blue(c);
  
  r *= factor;
  g *= factor;
  b *= factor;
  
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

color randomFireColor() {
  // Hue in range for red–orange–yellow (~0 to 60 degrees out of 360)
  float h = random(0, 60); // red to yellow
  float s = random(180, 255); // high saturation
  float b = random(200, 255); // bright

  // HSB mode simplfies this
  colorMode(HSB, 360, 255, 255);
  color c = color(h, s, b);
  colorMode(RGB, 255);
  return c;
}

void drawBullet(Bullet bullet) {
    if (getHeldGun() instanceof FlameThrower) {
        fill(randomFireColor());
    } else {
        fill(10);
    }
    drawCircleWithTopLeftCornerAt(bullet.coords, bullet.diameterInBlocks);
}

void drawCircleWithTopLeftCornerAt(PVector coords, float diameterInBlocks) {
    PVector pixelPosition = coordsToPixelPosition(coords);
    float widthInPixels = diameterInBlocks * settings.pixelsPerBlock;
    ellipseMode(CORNER);
    circle(pixelPosition.x, pixelPosition.y, widthInPixels);
    ellipseMode(CENTER);
}
