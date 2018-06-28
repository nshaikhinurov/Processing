import processing.pdf.*;

Line[] lines;

color bgc = #eeeeee;
color[] palette = {
  #581845
  ,#900c3f
  ,#c70039
  ,#ff5733
  ,#ffc305
};

int numberOfRows = 25;
int numberOfLinesInARow = numberOfRows / 5;
float fieldSize;
float gap;
float thickness;

void setup(){
  size(750, 750);
  fieldSize = 0.8*width;
  gap = fieldSize / (numberOfRows-1);
  thickness = gap / 1.6;
  noLoop();
}

void draw(){
  generateLines();

  beginRecord(PDF, "../HorizontalWords.pdf");
  background(bgc);
  strokeWeight(thickness);
  translate(0.1*width, 0.1*height);
  renderLines();
  endRecord();
}

void generateLines(){
  lines = new Line[0];
  for (int i = 0; i < numberOfRows; i++)
    generateRow(i);
};

void generateRow(int rowNumber){
  float yCoordinate = rowNumber*gap;
  float[] gapsCoordinates = new float[numberOfLinesInARow-1];

  do{
    for (int i = 0; i < gapsCoordinates.length; i++){
      gapsCoordinates[i] = random(fieldSize);
    }
    gapsCoordinates = sort(gapsCoordinates);
  } while (areLinesTooShort(gapsCoordinates));

  lines = (Line[])append(lines, new Line(
    0,
    yCoordinate,
    gapsCoordinates[0] - gap/2.0,
    yCoordinate
  ));
  for (int i = 0; i < gapsCoordinates.length-1; i++){
    lines = (Line[])append(lines, new Line(
      gapsCoordinates[i] + gap/2.0,
      yCoordinate,
      gapsCoordinates[i+1] - gap/2.0,
      yCoordinate
    ));
  }
  lines = (Line[])append(lines, new Line(
    gapsCoordinates[gapsCoordinates.length-1] + gap/2.0,
    yCoordinate,
    fieldSize,
    yCoordinate
  ));
}

boolean areLinesTooShort(float[] gapsCoordinates){
  float minLength = gapsCoordinates[0] - gap/2.0;
  for(int i = 1; i < gapsCoordinates.length; i++)
    minLength = min(minLength, gapsCoordinates[i] - gapsCoordinates[i-1] - gap);
  minLength = min(minLength, fieldSize - (gapsCoordinates[gapsCoordinates.length-1] + gap/2.0));
  if(minLength < thickness)
    return true;
  return false;
}

void renderLines(){
  for (Line line : lines){
    color lineColor = getRandomPaletteColor(palette);
    stroke(lineColor);
    line(line.startX, line.startY, line.endX, line.endY);
  }
}

color getRandomPaletteColor(color[] palette){
  return palette[floor(random(palette.length))];
}

void mouseClicked() {
  redraw();
}
