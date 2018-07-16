import processing.pdf.*;
import java.util.*;

color blackColor = #212121;
color whiteColor = #eeeeee;

color[] bw = {
  whiteColor,blackColor
};

float inc;
int seed;
int resolutionMultiplier;

void setup(){
  size(1000, 1000);
  // noiseDetail(1000);
  noiseDetail(50);
  inc  = 0.02;
  seed = millis();
  seededRender(1);
  // saveHighRes(1);
  // saveHighRes(2);
  noLoop();
}

void saveHighRes(int resolutionMultiplier) {
  PGraphics hires = createGraphics(
    width * resolutionMultiplier,
    height * resolutionMultiplier,
    JAVA2D);
    println("Generating high-resolution image...");

    beginRecord(hires);
    seededRender(resolutionMultiplier);
    endRecord();

    hires.save(seed + "-highres-"+resolutionMultiplier+"x.png");
    println("Finished");
  }

void seededRender(int rm){
  randomSeed(seed);
  noiseSeed(seed);
  resolutionMultiplier = rm;
  render();
}

void render(){
  background(whiteColor);
  float[] noiseArr = generateNoise();
  // renderNoise(noiseArr);
  renderSine(noiseArr);
}

float[] generateNoise(){
  float[] noiseArr = new float[width*height*resolutionMultiplier*resolutionMultiplier];
  float randomiser = random(1000);
  float yOff = randomiser;
  for (int y = 0; y < height*resolutionMultiplier; y++){
    float xOff = randomiser;
    for (int x = 0; x < width*resolutionMultiplier; x++){
      int index = x + y*width*resolutionMultiplier;
      noiseArr[index] = noise(xOff, yOff);
      xOff = randomiser + x*inc/resolutionMultiplier;
    }
    yOff = randomiser + y*inc/resolutionMultiplier;
  }
  return noiseArr;
}

void renderNoise(float[] noiseArr){
  noStroke();
  float size = 1;
  for (int y = 0; y < height*resolutionMultiplier; y++){
    for (int x = 0; x < width*resolutionMultiplier; x++){
      int index = x + y*width*resolutionMultiplier;
      color fillColor = color(noiseArr[index]*255);
      fill(fillColor);
      rect(x,y,size,size);
    }
  }
}

void renderSine(float[] noiseArr){
  noStroke();
  float size = 1;
  float xPeriod = 0;
  float yPeriod = 1;
  float noisePower = 0;
  for (int y = 0; y < height*resolutionMultiplier; y++){
    for (int x = 0; x < width*resolutionMultiplier; x++){
      int index = x + y*width*resolutionMultiplier;
      float xyValue = xPeriod*x/width*resolutionMultiplier + yPeriod*y/height*resolutionMultiplier + noisePower*noiseArr[index];
      float sine = abs(sin(xyValue*PI));
      float normalize = lerp(0,255,1-sine);
      color fillColor = color( normalize );
      fill(fillColor);
      rect(x,y,size,size);
    }
  }
}

color getColorWithAlpha(color c, float a){
  float r = c >> 16 & 0xFF;
  float g = c >> 8 & 0xFF;
  float b = c & 0xFF;
  return color(r,g,b,a);
}

color lerpColorFromPalette(color[] palette, float position){
  float palettePosition = map(position, 0, 1, 0, palette.length-1);
  color color1 = palette[(int)palettePosition];
  color color2 = palette[(int)palettePosition+1];
  float amount = map(palettePosition, (int)palettePosition, (int)palettePosition+1, 0, 1);
  return lerpColor(color1,color2,amount);
}

color getColorFromPalette(color[] palette, float position){
  float palettePosition = map(position, 0, 1, 0, palette.length-1);
  float colorIndex = round(palettePosition);
  return palette[(int)colorIndex];
}
