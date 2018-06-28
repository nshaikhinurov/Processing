import processing.pdf.*;

Line[] lines;

color[] palette = {
  #581845
  ,#900c3f
  ,#c70039
  ,#ff5733
  ,#ffc305
};

color bgc = #eeeeee;

void setup(){
  size(750, 750);
  Config.sketchSize = 750;
  Config.fieldSize = 750.0 * 0.8;
  Config.gap = Config.fieldSize / (Config.N-1);
  Config.thickness = Config.gap / 1.6;
  noLoop();
}

void generateLines(){
  lines = new Line[0];
  for (int i = 0; i < Config.N; i++)
    generateRow(i);
};

void generateRow(int rowNumber){
  float yCoordinate = 0.1*Config.sketchSize + rowNumber*Config.gap;
  float[] gapsCoordinates = new float[Config.partsCount-1];

  do{
    for (int i = 0; i < gapsCoordinates.length; i++){
      gapsCoordinates[i] = random(Config.fieldSize);
    }
    gapsCoordinates = sort(gapsCoordinates);
  } while (areLinesTooShort(gapsCoordinates));

  lines = (Line[])append(lines, new Line(
    0.1*Config.sketchSize,
    yCoordinate,
    0.1*Config.sketchSize + gapsCoordinates[0] - Config.gap/2.0,
    yCoordinate
  ));
  for (int i = 0; i < gapsCoordinates.length-1; i++){
    lines = (Line[])append(lines, new Line(
      0.1*Config.sketchSize + gapsCoordinates[i] + Config.gap/2.0,
      yCoordinate,
      0.1*Config.sketchSize + gapsCoordinates[i+1] - Config.gap/2.0,
      yCoordinate
    ));
  }
  lines = (Line[])append(lines, new Line(
    0.1*Config.sketchSize + gapsCoordinates[gapsCoordinates.length-1] + Config.gap/2.0,
    yCoordinate,
    0.1*Config.sketchSize + Config.fieldSize,
    yCoordinate
  ));
}

boolean areLinesTooShort(float[] gapsCoordinates){
  float minLength = gapsCoordinates[0] - Config.gap/2.0;
  for(int i = 1; i < gapsCoordinates.length; i++)
    minLength = min(minLength, gapsCoordinates[i] - gapsCoordinates[i-1] - Config.gap);
  minLength = min(minLength, Config.fieldSize - (gapsCoordinates[gapsCoordinates.length-1] + Config.gap/2.0));
  if(minLength < Config.thickness)
    return true;
  return false;
}

void draw(){
  beginRecord(PDF, "../ColoredLines.pdf");
  background(bgc);
  strokeWeight(Config.thickness);
  generateLines();
  renderLines();
  endRecord();
}

void renderLines(){
  for (int i = 0; i < lines.length; i++){
    Line line = lines[i];
    stroke(palette[floor(random(palette.length))]);
    line(line.startX, line.startY, line.endX, line.endY);
  }
}

void mouseClicked() {
  redraw();
}
