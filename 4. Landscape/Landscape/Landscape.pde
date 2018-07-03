import processing.pdf.*;

float[] terrainContour;

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
  dotsCount = (int)(0.5*width);
  scale = 2;
  randomiser = 0;
  useSplines = false;
  amplitude = 0.5*height/720;
  addSpikes = true;
  spikeAmplitude = 10;
  noLoop();
}

void draw(){
  // testDraw();
  mainDraw();
}

void testDraw(){
  background(#eeeeee);
  generateTerrainContour();
  pushMatrix();
  offsetToTargetLevel(height/2.0);
  renderLandscape(palette[0]);
  popMatrix();
}

void mainDraw(){
  beginRecord(PDF, "../Landscape.pdf");
  background(firewatchSky);
  renderSun();
  for (int i = 0; i < palette.length; i++){
    randomiser = random(1000);
    spikeAmplitude = map(i, 0, palette.length-1, 3, 20);
    amplitude = map(i, 0, palette.length-1, 0.3*height*height/720, 0.6*height*height/720);
    scale = map(i, 0, palette.length-1, 2.0*width/1280, 3.0*width/1280);
    generateTerrainContour();

    pushMatrix();
    float targetLevel = map(i, 0, palette.length-1, 0.5*height, 0.8*height);
    offsetToTargetLevel(targetLevel);
    renderLandscape(palette[i]);
    popMatrix();
  }
  endRecord();
}

void renderSun(){
  noStroke();
  fill(firewatchSun);
  float size = 150;
  float x = map(random(1), 0, 1, 0.1*width, 0.9*width);
  float y = map(random(1), 0, 1, 0.3*height, 0.5*height);
  ellipse(x,y,size,size);
}

void generateTerrainContour(){
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

void offsetToTargetLevel(float targetLevel){
  translate(0, targetLevel);
}

void renderLandscape(color fillColor){
  noStroke();
  fill(fillColor);
  beginShape();
  addVertex(0, height);
  addVertex(0, height);
  addVertex(0, terrainContour[0]);
  for (int i = 0; i < dotsCount; i++){
    float x = map(i, 0, dotsCount-1, 0, width);
    float y = terrainContour[i];
    addVertex(x, y);
  }
  addVertex(width, terrainContour[dotsCount-1]);
  addVertex(width, height);
  addVertex(width, height);
  endShape(CLOSE);
}

void addVertex(float x, float y){
  if (useSplines)
    curveVertex(x,y);
  else
    vertex(x, y);
}

void mouseClicked() {
  redraw();
}
