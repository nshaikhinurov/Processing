import processing.pdf.*;

float PHI = (sqrt(5.0) - 1) / 2.0;
int seedsCount = 377;
float sketchSize;
float maxDistance;
boolean isClassical = true;

color[] palette = {
  #3d348b
  ,#7678ed
  ,#f7b801
  ,#f18701
  ,#ff4f00
};

void setup(){
  size(750, 750);
  sketchSize = 750.0;
  maxDistance = 0.8 * sketchSize/2.0;
  noLoop();
  beginRecord(PDF, "Fibonacci Sunflower.pdf");
}

void draw(){
  background(#eeeeee);
  noStroke();
  fill(#1678c3);
  fill(#000000);
  if (isClassical)
    renderSeeds();
  else
    renderDots();
  endRecord();
}

void renderSeeds(){
  for (int i = 0; i < seedsCount; i++){
    renderSeed(i);
  }
}

void renderSeed(int k){
  float seedAngle = getSeedAngle(k);
  float maxSeedDistance = getSeedDistance(seedsCount);
  float seedDistance = getSeedDistance(k);
  float actualSeedDistance = map(seedDistance, 0, maxSeedDistance, 0, maxDistance);
  float seedSize = map(k, 0, seedsCount-1, 3, 30);

  if(actualSeedDistance < 0.15 * maxDistance)
    return;

  fill(palette[floor(random(palette.length))]);
  // fill(#333333);
  ellipse(
    sketchSize/2.0 + cos(seedAngle)*actualSeedDistance,
    sketchSize/2.0 + sin(seedAngle)*actualSeedDistance,
    seedSize,
    seedSize
  );
}

void renderDots(){
  int circlesCount = 21;
  int dotsCount = 7;
  for (int k = 0; k < circlesCount; k++){
    float angle = getSeedAngle(k);
    float radius = pow(getSeedDistance(k), 3.5);
    float size = k / (float)circlesCount * 35;

    if(radius < 0.15 * pow(getSeedDistance(circlesCount), 3.5))
      continue;

    for (int i = 0; i < dotsCount; i++){
      ellipse(
        sketchSize/2.0 + cos(angle + radians(i * 360.0/dotsCount))*radius,
        sketchSize/2.0 + sin(angle + radians(i * 360.0/dotsCount))*radius,
        size,
        size
      );
    }
  }
}

float getSeedDistance(int k){
  return pow(k,1.2);
  // return sqrt(k);
}

float getSeedAngle(int k){
  return TWO_PI*PHI*k;
}

void mouseClicked() {
  redraw();
}
