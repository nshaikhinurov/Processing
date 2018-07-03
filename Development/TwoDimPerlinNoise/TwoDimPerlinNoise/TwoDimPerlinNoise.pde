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

float inc = 0.05;
int numberOfDots = 250;

void setup(){
  size(1000, 1000);
  noiseDetail(1000);
  noLoop();
}

void draw(){
  beginRecord(PDF, "../TwoDimPerlinNoise.pdf");
  background(whiteColor);
  float[] noiseArr = generateNoise();
  renderNoise(noiseArr);
  endRecord();
}

float[] generateNoise(){
  float[] noiseArr = new float[numberOfDots*numberOfDots];
  float randomiser = random(1000);
  float yOff = randomiser;
  for (int y = 0; y < numberOfDots; y++){
    float xOff = randomiser;
    for (int x = 0; x < numberOfDots; x++){
      int index = x + y*numberOfDots;
      noiseArr[index] = noise(xOff, yOff);
      xOff += inc;
    }
    yOff += inc;
  }
  return noiseArr;
}

void renderNoise(float[] noiseArr){
  pushMatrix();
  translate(0.1*width,0.1*height);
  noStroke();
  float size = 0.8*width / (2*numberOfDots - 1);
  size*=1.1;
  for (int i = 0; i < numberOfDots; i++)
    for (int j = 0; j < numberOfDots; j++){
      float x = lerp(0, 0.8*width, 1.0*j/(numberOfDots-1));
      float y = lerp(0, 0.8*width, 1.0*i/(numberOfDots-1));
      int index = i*numberOfDots + j;
      color fillColor = getColorFromPalette(bw, noiseArr[index]);
      fill(fillColor);
      ellipse(x,y,size,size);
    }
  popMatrix();
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

void mouseClicked() {
  redraw();
}
