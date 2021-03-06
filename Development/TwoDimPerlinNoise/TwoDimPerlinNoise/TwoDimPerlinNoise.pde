import processing.pdf.*;
import java.util.*;

color redColor = #F44336;
color yellowColor = #FFEB3B;
color indigoColor = #3F51B5;
color blackColor = #212121;
color whiteColor = #eeeeee;
color[] palette1 = {
  #581845
  ,#900c3f
  ,#c70039
  ,#ff5733
  ,#ffc305
};
color[] bw = {
  whiteColor,blackColor
};

float inc;
int seed;

void setup(){
  // size(1000, 1000);
  size(500, 500);
  noiseDetail(1000);
  inc  = 0.02;
  seed = millis();
  // seededRender(1);
  saveHighRes(1);
  saveHighRes(2);
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

void seededRender(int resolutionMultiplier){
  randomSeed(seed);
  noiseSeed(seed);
  render(resolutionMultiplier);
}

void render(int resolutionMultiplier){
  background(whiteColor);
  float[] noiseArr = generateNoise(resolutionMultiplier);
  renderNoise(noiseArr, resolutionMultiplier);
}

float[] generateNoise(int resolutionMultiplier){
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

void renderNoise(float[] noiseArr, int resolutionMultiplier){
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
