import processing.pdf.*;

float screenWidth;
float screenHeight;
// int dotsCount = (int)(screenWidth/50);
int Y_AXIS = 1;
int X_AXIS = 2;

float[] terrainContour;

color[] bluesPalette = {
  // #b5f6f7
  // ,#61c5d7
  #1a94bb
  ,#0070a8
  ,#06548f
  ,#044685
  ,#041a4d
};

color[] firewatchPalette = {
  #ff7e49
  ,#ff5b41
  ,#cb283c
  ,#7d0030
  ,#530030
  ,#2e102c
};
color firewatchSky = #ffddc7;
color firewatchSun = #fde577;

color[] palette = firewatchPalette;

int dotsCount;
float scale;
float randomiser;
boolean useSplines;
boolean addSpikes;
float amplitude;
float spikeAmplitude;

void setup(){
  size(1280, 720);
  screenWidth = width;
  screenHeight = height;
  dotsCount = (int)(screenWidth/2);
  scale = 2;
  randomiser = 0;
  useSplines = false;
  amplitude = 0.5*(screenHeight/720);
  addSpikes = true;
  spikeAmplitude = 10;
  noLoop();
}

void draw(){
  // testDraw();
  mainDraw();
}

void testDraw(){
  pushMatrix();
  background(#eeeeee);
  GenerateTerrainContour();
  popMatrix();
  offsetToTargetLevel(height/2.0);
  renderLandscape(palette[0]);
}

void mainDraw(){
  beginRecord(PDF, "Landscape.pdf");
  background(#fbbdb6);
  background(#eeeeee);
  background(firewatchSky);
  renderSun();
  // fill(#1678c3);
  // setGradient(0,0,screenWidth, screenHeight, #1a94bb, #fbbdb6,  Y_AXIS);
  pushMatrix();
  for (int i = 0; i < palette.length; i++){
    randomiser = random(1000);
    spikeAmplitude = map(i, 0, palette.length-1, 3, 20);
    amplitude = map(i, 0, palette.length-1, 0.3*screenHeight*(screenHeight/720), 0.6*screenHeight*(screenHeight/720));
    scale = map(i, 0, palette.length-1, 2*(screenWidth/1280), 3*(screenWidth/1280));
    // dotsCount = (int)map(i, 0, palette.length-1, screenWidth, screenWidth/(palette.length));
    GenerateTerrainContour();
    popMatrix();
    pushMatrix();
    float targetLevel = map(i, 0, palette.length-1, 0.5*screenHeight, 0.8*screenHeight);
    offsetToTargetLevel(targetLevel);
    renderLandscape(palette[i]);
  }
  popMatrix();
  endRecord();
}

void renderSun(){
  noStroke();
  fill(firewatchSun);
  float size = 150;
  float x = map(random(1), 0, 1, 0.1*screenWidth, 0.9*screenWidth);
  float y = map(random(1), 0, 1, 0.3*screenHeight, 0.5*screenHeight);
  ellipse(x,y,size,size);
}

void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {

  noFill();

  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  }
  else if (axis == X_AXIS) {  // Left to right gradient
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
  }
}

void GenerateTerrainContour()
{
    terrainContour = new float[dotsCount];
    for (int i = 0; i < dotsCount; i++)
    {
      float t = map(i, 0, dotsCount-1, 0, scale);
      float noise = noise(randomiser + t);
      float spike = map(random(1), 0, 1, -spikeAmplitude/2.0, spikeAmplitude/2.0);
      float y = map(noise, 0, 1, -amplitude/2, amplitude/2);
      if (addSpikes)
        y += spike;
      terrainContour[i] = y;
    }
 }

 void changeNoiseParams(){
   scale *= 1.1;
   println("Scale="+scale);
 }

 void offsetToTargetLevel(float targetLevel){
   translate(0, targetLevel);
 }

 void renderLandscape(color fillColor){
    noStroke();
    fill(fillColor);
    beginShape();
    if (useSplines)
      renderSplined();
    else
      renderLinear();
    endShape(CLOSE);
 }

 void renderLinear(){
   vertex(0, screenHeight);
   vertex(0, screenHeight);
   vertex(0, terrainContour[0]);
   for (int i = 0; i < dotsCount; i++){
     float x = map(i, 0, dotsCount-1, 0, screenWidth);
     float y = terrainContour[i];
     vertex(x, y);
   }
   vertex(screenWidth, terrainContour[dotsCount-1]);
   vertex(screenWidth, screenHeight);
   vertex(screenWidth, screenHeight);
 }

 void renderSplined(){
   curveVertex(0, screenHeight);
   curveVertex(0, screenHeight);
   curveVertex(0, terrainContour[0]);
   for (int i = 0; i < dotsCount; i++){
     float x = map(i, 0, dotsCount-1, 0, screenWidth);
     float y = terrainContour[i];
     curveVertex(x, y);
   }
   curveVertex(screenWidth, terrainContour[dotsCount-1]);
   curveVertex(screenWidth, screenHeight);
   curveVertex(screenWidth, screenHeight);
 }

 void mouseClicked() {
   // changeNoiseParams();
   redraw();
 }
